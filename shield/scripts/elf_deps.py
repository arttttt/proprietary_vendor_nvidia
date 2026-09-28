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

From R on, the build runs check_elf_file on every prebuilt ELF module: each
DT_NEEDED entry has to be named in LOCAL_SHARED_LIBRARIES, and a library's
DT_SONAME has to match the file name it installs under. The blobs already
say what they need, so the list is read out of them with readelf rather than
kept by hand, and rerunning this after a blob update keeps the two in step.

    shield/scripts/elf_deps.py           rewrite the Android.mk files
    shield/scripts/elf_deps.py --check   exit 1 if anything is out of date

libc, libm, libdl and libc++ are left out: the build supplies them to every
prebuilt on its own (build/make/core/cc_prebuilt_internal.mk).

A SONAME that does not match the installed name is reported, not fixed. Where
the mismatch is deliberate the module carries LOCAL_CHECK_ELF_FILES := false
by hand, with the reason next to it, and this script leaves it alone.

Set READELF to pick the tool; otherwise llvm-readelf or readelf from PATH.
"""

import glob
import os
import re
import shutil
import subprocess
import sys

IMPLICIT = {"libc", "libm", "libdl", "libc++"}
ELF_CLASSES = {"SHARED_LIBRARIES", "EXECUTABLES"}
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def readelf_tool():
    tool = os.environ.get("READELF")
    if tool:
        return tool
    for name in ("llvm-readelf", "readelf"):
        path = shutil.which(name)
        if path:
            return path
    sys.exit("no readelf: set READELF or put llvm-readelf in PATH")


def dynamic(readelf, path):
    out = subprocess.run([readelf, "-d", path], capture_output=True,
                         text=True, check=True).stdout
    needed = re.findall(r"\(NEEDED\)\s+Shared library: \[(.+?)\]", out)
    soname = re.findall(r"\(SONAME\)\s+Library soname: \[(.+?)\]", out)
    return needed, soname[0] if soname else None


def process(mk, readelf, problems):
    base = os.path.dirname(mk)
    text = open(mk).read()
    parts = re.split(r"(include \$\(CLEAR_VARS\))", text)
    out = [parts[0]]
    for i in range(1, len(parts), 2):
        block = parts[i + 1]
        cls = re.search(r"^LOCAL_MODULE_CLASS\s*:=\s*(\S+)", block, re.M)
        mod = re.search(r"^LOCAL_MODULE\s*:=\s*(\S+)", block, re.M)
        src = re.search(r"^LOCAL_SRC_FILES\s*:=\s*(\S+)", block, re.M)
        if cls and mod and src and cls.group(1) in ELF_CLASSES \
                and "$(BUILD_PREBUILT)" in block:
            path = os.path.join(base, src.group(1))
            needed, soname = dynamic(readelf, path)
            libs = [n[:-3] for n in needed
                    if n.endswith(".so") and n[:-3] not in IMPLICIT]
            block = re.sub(r"^LOCAL_SHARED_LIBRARIES\s*:=.*\n", "", block,
                           flags=re.M)
            if libs:
                block = block.replace(
                    "include $(BUILD_PREBUILT)",
                    "LOCAL_SHARED_LIBRARIES := " + " ".join(libs) +
                    "\ninclude $(BUILD_PREBUILT)", 1)
            installed = mod.group(1) + ".so"
            if cls.group(1) == "SHARED_LIBRARIES" and soname \
                    and soname != installed \
                    and "LOCAL_CHECK_ELF_FILES := false" not in block:
                problems.append("%s: %s has SONAME %s" %
                                (mk, installed, soname))
        out += [parts[i], block]
    return "".join(out)


def main():
    check = "--check" in sys.argv[1:]
    readelf = readelf_tool()
    problems, stale = [], []
    for mk in sorted(glob.glob(os.path.join(ROOT, "**", "Android.mk"),
                               recursive=True)):
        old = open(mk).read()
        new = process(mk, readelf, problems)
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
