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

"""Copy a blob and rename strings of its .dynstr, in place.

    elf_rename.py SRC DST OLD=NEW [OLD=NEW ...]

.dynstr holds the names the dynamic linker reads: DT_SONAME and DT_NEEDED
entries, and the names of the symbols the blob imports and exports. Every
OLD must be as long as its NEW. The rename touches only whole NUL-terminated
strings inside that one section, so a path that merely ends in the same name
is left alone, the same text in .rodata -- a name the code hands to dlsym,
say -- keeps its meaning, and no section, segment or offset in the file
moves.

That is the point of doing it this way. patchelf changes a SONAME by
appending a segment and relocating the program headers, and bionic's
linker refused the result outright on this board:

  dlopen failed: missing PT_DYNAMIC in "/system/vendor/lib/hw/gralloc.nvidia.so"

A name of the same length needs none of that.
"""

import struct
import sys


def dynstr_bounds(data):
    """Return the file range [start, end) of the .dynstr section."""
    if data[:4] != b"\x7fELF":
        return None
    wide = data[4] == 2
    order = "<" if data[5] == 1 else ">"
    if wide:
        shoff, = struct.unpack_from(order + "Q", data, 0x28)
        shentsize, shnum, shstrndx = struct.unpack_from(order + "HHH", data, 0x3a)
        section = order + "IIQQQQ"
    else:
        shoff, = struct.unpack_from(order + "I", data, 0x20)
        shentsize, shnum, shstrndx = struct.unpack_from(order + "HHH", data, 0x2e)
        section = order + "IIIIII"
    headers = [struct.unpack_from(section, data, shoff + i * shentsize)
               for i in range(shnum)]
    names = headers[shstrndx][4]
    for name, _, _, _, offset, size in headers:
        if data[names + name:data.index(b"\0", names + name)] == b".dynstr":
            return offset, offset + size
    return None


def main(argv):
    if len(argv) < 4:
        sys.exit(__doc__)
    src, dst, pairs = argv[1], argv[2], argv[3:]
    data = open(src, "rb").read()
    bounds = dynstr_bounds(data)
    if bounds is None:
        sys.exit("%s: no .dynstr to rename in" % src)
    start, end = bounds
    # The table opens with the empty string, so its first name, too, has a
    # NUL on either side.
    head, table, tail = data[:start], data[start:end], data[end:]
    for pair in pairs:
        old, _, new = pair.partition("=")
        if not new or len(old) != len(new):
            sys.exit("%s: %r and %r must be the same length" % (src, old, new))
        needle = b"\0" + old.encode() + b"\0"
        if table.count(needle) == 0:
            sys.exit("%s: no string %r in .dynstr to rename" % (src, old))
        table = table.replace(needle, b"\0" + new.encode() + b"\0")
    open(dst, "wb").write(head + table + tail)


if __name__ == "__main__":
    main(sys.argv)
