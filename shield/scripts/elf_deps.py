#!/usr/bin/env python3
#
# Copyright (C) 2026 Artem Bambalov
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""Write each blob's LOCAL_SHARED_LIBRARIES from the blob itself.

From R on, the build runs check_elf_file on every prebuilt ELF module, and
it asks two things. Every DT_NEEDED entry has to be named in
LOCAL_SHARED_LIBRARIES, and every symbol the blob leaves undefined has to be
defined by one of the libraries named there. A library's DT_SONAME also has
to match the file name it installs under.

The first is read straight out of the blob with readelf. The second is where
these 2016 blobs fall short: plenty of them call into liblog, libnvos or
libnvrm without listing it, and got away with it because a neighbour had
already loaded the library into the process. Which library defines each such
symbol is worked out once, against a built tree, and kept in
elf_extra_deps.txt next to this script, so the everyday run needs nothing but
the blobs:

    elf_deps.py                    rewrite the Android.mk files
    elf_deps.py --check            exit 1 if anything is out of date
    elf_deps.py --resolve OBJ OUT [ONLY]
                                   work out the extra libraries against a
                                   built tree's obj directory (for example
                                   out/target/product/mocha/obj) and write
                                   them to OUT; copy OUT over
                                   elf_extra_deps.txt and run without flags.
                                   ONLY, a file of module names, limits it
                                   to the blobs the product really builds

--resolve reads nothing but OBJ and the blobs, and writes nothing but OUT,
so it can run on the build machine without touching the checkout there.

ONLY matters because this repository carries blobs no product installs, and
the build checks only what it builds. Several of the unused ones (the
*_tegra_impl GL libraries, nvcgcserver, libnvmm_service) were built against
an older libnvrm and name symbols no blob here defines; resolving them would
be a list of failures about files that never reach an image. The list comes
from the build itself:

    ninja -f out/combined-<product>.ninja -t commands droid \
        | grep -o 'obj/[A-Z_]*/[^/ ]*_intermediates/check_elf_files' ...

libc, libm, libdl and libc++ are left out of the lists: the build gives them
to every prebuilt itself (build/make/core/cc_prebuilt_internal.mk).

Blobs built before Android 8 call __aeabi_* helpers that libc no longer
exports. Those are not resolved here but repaired: a blob that depends on
libm and calls one of them gets
LOCAL_PREBUILT_MODULE_FILE := $(call shield-intrinsics-fixed,...), which
installs a copy rewritten by fixup-intrinsics.py to libw.so and s_aeabi_*
(see ../Android.mk), and its list names libw where the blob named libm.
The ELF check then reads that copy, and libw answers.

Some symbols are answered by a shim the device tree attaches at run time
through TARGET_LD_SHIM_LIBS; no built tree shows those as reachable, so
they are added to elf_extra_deps.txt by hand, under their own comment.
Keep that section when copying a fresh --resolve result over the file.

A SONAME that does not match the installed name is reported, not fixed:
whether the file or the name is wrong is a decision. Where the installed
name is the right one, the module takes its file through
$(call shield-renamed,<source>,OLD=NEW ...) by hand (see ../Android.mk),
which renames the SONAME -- or a DT_NEEDED entry -- to a name of the same
length. This script reads the source and the renames from that call, applies
the renames to what the blob names, and leaves the line alone.

Set READELF and NM to pick the tools; otherwise llvm-readelf and llvm-nm
(or readelf and nm) from PATH.
"""

import glob
import os
import re
import shutil
import subprocess
import sys

IMPLICIT = ["libc", "libm", "libdl", "libc++"]
ELF_CLASSES = {"SHARED_LIBRARIES", "EXECUTABLES"}
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
EXTRA_FILE = os.path.join(ROOT, "scripts", "elf_extra_deps.txt")
# What fixup-intrinsics.py rewrites to libw; keep the two lists in step.
FIXUP_AEABI = {
    "__aeabi_uldivmod", "__aeabi_ldivmod", "__aeabi_d2lz", "__aeabi_d2ulz",
    "__aeabi_l2d", "__aeabi_ul2d", "__aeabi_f2lz", "__aeabi_f2ulz",
    "__aeabi_l2f", "__aeabi_ul2f",
}


def needs_fixup(path):
    """The test fixup-intrinsics.py applies before rewriting a blob."""
    data = open(path, "rb").read()
    return b"libm.so" in data and any(s.encode() in data for s in FIXUP_AEABI)


def tool(env, names):
    path = os.environ.get(env)
    if path:
        return path
    for name in names:
        found = shutil.which(name)
        if found:
            return found
    sys.exit("no %s: set %s or put %s in PATH" % (names[0], env, names[0]))


def run(args):
    return subprocess.run(args, capture_output=True, text=True,
                          check=True).stdout


def dynamic(readelf, path):
    out = run([readelf, "-d", path])
    needed = re.findall(r"\(NEEDED\)\s+Shared library: \[(.+?)\]", out)
    soname = re.findall(r"\(SONAME\)\s+Library soname: \[(.+?)\]", out)
    return needed, soname[0] if soname else None


def strip_version(sym):
    return sym.split("@", 1)[0]


def undefined(nm, path):
    """Strong undefined dynamic symbols; weak ones may stay unresolved."""
    syms = set()
    for line in run([nm, "-D", "--undefined-only", path]).splitlines():
        parts = line.split()
        if len(parts) >= 2 and parts[-2] == "U":
            syms.add(strip_version(parts[-1]))
    return syms


def defined(nm, path):
    syms = set()
    for line in run([nm, "-D", "--defined-only", path]).splitlines():
        parts = line.split()
        if parts:
            syms.add(strip_version(parts[-1]))
    return syms


RENAMED_RE = re.compile(r"^LOCAL_PREBUILT_MODULE_FILE\s*:=\s*\$\(call "
                        r"shield-renamed,(.*),([^,()]+)\)\s*$", re.M)
INNER_RE = re.compile(r"\$\(LOCAL_PATH\)/([^,()\s]+)")


def renames_of(block):
    m = RENAMED_RE.search(block)
    if not m:
        return {}
    return dict(p.split("=", 1) for p in m.group(2).split())
FIXED_RE = re.compile(r"^LOCAL_PREBUILT_MODULE_FILE\s*:=\s*\$\(call "
                      r"shield-intrinsics-fixed,\$\(LOCAL_PATH\)/(\S+)\)", re.M)


def source_of(block):
    """A blob's path relative to its makefile. A fixed-up blob names it only
    in its shield-intrinsics-fixed call: R rejects LOCAL_SRC_FILES beside
    LOCAL_PREBUILT_MODULE_FILE as unused sources."""
    src = re.search(r"^LOCAL_SRC_FILES\s*:=\s*(\S+)", block, re.M)
    if src:
        return src.group(1)
    fixed = FIXED_RE.search(block)
    if fixed:
        return fixed.group(1)
    renamed = RENAMED_RE.search(block)
    if renamed:
        inner = INNER_RE.search(renamed.group(1))
        return inner.group(1) if inner else None
    return None


def blocks(mk):
    """Yield (module, class, source path) for every prebuilt ELF module."""
    base = os.path.dirname(mk)
    for block in re.split(r"include \$\(CLEAR_VARS\)", open(mk).read())[1:]:
        cls = re.search(r"^LOCAL_MODULE_CLASS\s*:=\s*(\S+)", block, re.M)
        mod = re.search(r"^LOCAL_MODULE\s*:=\s*(\S+)", block, re.M)
        src = source_of(block)
        if cls and mod and src and cls.group(1) in ELF_CLASSES \
                and "$(BUILD_PREBUILT)" in block:
            yield mod.group(1), cls.group(1), os.path.join(base, src)


def makefiles():
    return sorted(glob.glob(os.path.join(ROOT, "**", "Android.mk"),
                            recursive=True))


def read_extra():
    extra = {}
    if os.path.exists(EXTRA_FILE):
        for line in open(EXTRA_FILE):
            line = line.split("#", 1)[0].split()
            if line:
                extra[line[0].rstrip(":")] = line[1:]
    return extra


def process(mk, readelf, extra, problems):
    base = os.path.dirname(mk)
    parts = re.split(r"(include \$\(CLEAR_VARS\))", open(mk).read())
    out = [parts[0]]
    for i in range(1, len(parts), 2):
        block = parts[i + 1]
        cls = re.search(r"^LOCAL_MODULE_CLASS\s*:=\s*(\S+)", block, re.M)
        mod = re.search(r"^LOCAL_MODULE\s*:=\s*(\S+)", block, re.M)
        src = source_of(block)
        if cls and mod and src and cls.group(1) in ELF_CLASSES \
                and "$(BUILD_PREBUILT)" in block:
            name = mod.group(1)
            path = os.path.join(base, src)
            needed, soname = dynamic(readelf, path)
            renames = renames_of(block)
            needed = [renames.get(n, n) for n in needed]
            soname = renames.get(soname, soname)
            fixup = needs_fixup(path)
            libs = []
            for n in needed:
                if not n.endswith(".so"):
                    continue
                n = n[:-3]
                if n == "libm" and fixup:
                    libs.append("libw")
                elif n not in IMPLICIT:
                    libs.append(n)
            libs += [l for l in extra.get(name, []) if l not in libs]
            block = re.sub(r"^LOCAL_SHARED_LIBRARIES\s*:=.*\n", "", block,
                           flags=re.M)
            block = re.sub(r"^LOCAL_ALLOW_UNDEFINED_SYMBOLS\s*:=.*\n", "",
                           block, flags=re.M)
            # The source is named in one place only: LOCAL_SRC_FILES for a
            # blob installed as shipped, the fixup call for one that is not.
            fixed_line = ("LOCAL_PREBUILT_MODULE_FILE := $(call "
                          "shield-intrinsics-fixed,$(LOCAL_PATH)/%s)" % src)
            src_line = "LOCAL_SRC_FILES := %s" % src
            if RENAMED_RE.search(block):
                pass
            elif fixup:
                if re.search(r"^LOCAL_SRC_FILES\s*:=", block, re.M):
                    block = re.sub(FIXED_RE.pattern + r"\n", "", block,
                                   flags=re.M)
                    block = re.sub(r"^LOCAL_SRC_FILES\s*:=.*$",
                                   lambda m: fixed_line, block, count=1,
                                   flags=re.M)
            else:
                block = FIXED_RE.sub(lambda m: src_line, block, count=1)
            add = ""
            if libs:
                add += "LOCAL_SHARED_LIBRARIES := " + " ".join(libs) + "\n"
            block = block.replace("include $(BUILD_PREBUILT)",
                                  add + "include $(BUILD_PREBUILT)", 1)
            installed = name + ".so"
            # soname already has any shield-renamed rename applied, so a
            # module renamed to its shipped name compares equal here.
            if cls.group(1) == "SHARED_LIBRARIES" and soname \
                    and soname != installed:
                problems.append("%s: %s has SONAME %s" %
                                (mk, installed, soname))
        out += [parts[i], block]
    return "".join(out)


def resolve(obj, out_path, only_path=None):
    readelf = tool("READELF", ["llvm-readelf", "readelf"])
    nm = tool("NM", ["llvm-nm", "nm"])

    # Every library the build knows, by module name: our blobs from their
    # sources, everything else from what the build produced.
    libs = {}
    for path in glob.glob(os.path.join(obj, "SHARED_LIBRARIES",
                                       "*_intermediates", "*.so")):
        mod = os.path.basename(os.path.dirname(path))[:-len("_intermediates")]
        if os.path.basename(path) == mod + ".so":
            libs[mod] = path
    # Soong libraries reach obj/ only when a make module links them; the
    # rest are found where soong leaves them, as out/soong/.intermediates/
    # <dir>/<module>/android_arm_<cpu>_shared/<module>.so.
    soong = os.path.join(os.path.dirname(os.path.dirname(
        os.path.dirname(os.path.dirname(os.path.abspath(obj))))),
        "soong", ".intermediates")
    for path in glob.glob(os.path.join(soong, "**", "android_arm_*_shared",
                                       "*.so"), recursive=True):
        variant = os.path.dirname(path)
        mod = os.path.basename(os.path.dirname(variant))
        if os.path.basename(path) == mod + ".so" and mod not in libs \
                and "_vendor" not in variant and "_apex" not in variant:
            libs[mod] = path
    blobs = {}
    for mk in makefiles():
        for mod, cls, path in blocks(mk):
            blobs[mod] = path
            if cls == "SHARED_LIBRARIES":
                libs[mod] = path

    cache = {}

    def syms_of(mod):
        if mod not in cache:
            cache[mod] = defined(nm, libs[mod]) if mod in libs else set()
        return cache[mod]

    def needed_of(mod):
        if mod not in libs:
            return []
        return [n[:-3] for n in dynamic(readelf, libs[mod])[0]
                if n.endswith(".so")]

    providers = {}
    for mod in libs:
        for sym in syms_of(mod):
            providers.setdefault(sym, []).append(mod)

    only = None
    if only_path:
        only = set(open(only_path).read().split())

    lines, unsolved = [], []
    for mod in sorted(blobs):
        if only is not None and mod not in only:
            continue
        path = blobs[mod]
        needed = [n[:-3] for n in dynamic(readelf, path)[0]
                  if n.endswith(".so")]
        have = set()
        for lib in set(needed) | set(IMPLICIT):
            have |= syms_of(lib)
        missing = undefined(nm, path) - have
        if not missing:
            continue

        # The libraries this blob reaches through its own DT_NEEDED chain are
        # the ones that really answer at run time; prefer them.
        closure, todo = set(), list(needed)
        while todo:
            lib = todo.pop()
            if lib not in closure:
                closure.add(lib)
                todo += needed_of(lib)

        fixed_up = needs_fixup(path)
        extra = []
        for sym in sorted(missing):
            # Repaired by fixup-intrinsics.py and answered by libw.
            if sym in FIXUP_AEABI and fixed_up:
                continue
            cands = [p for p in providers.get(sym, []) if p != mod]
            if not cands:
                unsolved.append("%s: %s defined nowhere" % (mod, sym))
                continue
            pick = next((c for c in cands if c in closure), None) \
                or next((c for c in cands if c in blobs), None) \
                or sorted(cands)[0]
            if pick not in extra and pick not in needed:
                extra.append(pick)
        if extra:
            lines.append("%s: %s" % (mod, " ".join(extra)))

    with open(out_path, "w") as f:
        f.write("# Libraries these blobs use without naming them in "
                "DT_NEEDED, resolved\n# against a built tree by "
                "elf_deps.py --resolve. See that script.\n")
        for line in lines:
            f.write(line + "\n")
    for u in unsolved:
        print("unresolved: " + u, file=sys.stderr)
    return 1 if unsolved else 0


def main():
    args = sys.argv[1:]
    if args[:1] == ["--resolve"]:
        if len(args) not in (3, 4):
            sys.exit("usage: elf_deps.py --resolve OBJ_DIR OUT_FILE [ONLY]")
        return resolve(*args[1:])

    check = "--check" in args
    readelf = tool("READELF", ["llvm-readelf", "readelf"])
    extra = read_extra()
    problems, stale = [], []
    for mk in makefiles():
        old = open(mk).read()
        new = process(mk, readelf, extra, problems)
        if new != old:
            stale.append(os.path.relpath(mk, ROOT))
            if not check:
                open(mk, "w").write(new)
    for p in problems:
        print("SONAME mismatch, needs a decision: " + p, file=sys.stderr)
    for s in stale:
        print(("out of date: " if check else "updated: ") + s)
    return 1 if problems or (check and stale) else 0


if __name__ == "__main__":
    sys.exit(main())
