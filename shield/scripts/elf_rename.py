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

"""Copy a blob and rename library names inside it, in place.

    elf_rename.py SRC DST OLD=NEW [OLD=NEW ...]

Every OLD must be as long as its NEW. The rename touches only whole
NUL-terminated strings -- the form DT_SONAME and DT_NEEDED entries take in
.dynstr -- so a path that merely ends in the same name is left alone, and
no section, segment or offset in the file moves.

That is the point of doing it this way. patchelf changes a SONAME by
appending a segment and relocating the program headers, and bionic's
linker refused the result outright on this board:

  dlopen failed: missing PT_DYNAMIC in "/system/vendor/lib/hw/gralloc.nvidia.so"

A name of the same length needs none of that.
"""

import sys


def main(argv):
    if len(argv) < 4:
        sys.exit(__doc__)
    src, dst, pairs = argv[1], argv[2], argv[3:]
    data = open(src, "rb").read()
    for pair in pairs:
        old, _, new = pair.partition("=")
        if not new or len(old) != len(new):
            sys.exit("%s: %r and %r must be the same length" % (src, old, new))
        needle = b"\0" + old.encode() + b"\0"
        count = data.count(needle)
        if count == 0:
            sys.exit("%s: no string %r to rename" % (src, old))
        data = data.replace(needle, b"\0" + new.encode() + b"\0")
    open(dst, "wb").write(data)


if __name__ == "__main__":
    main(sys.argv)
