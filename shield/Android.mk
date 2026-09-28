# Copyright (C) 2017 The Android Open Source Project
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

ifeq ($(TARGET_TEGRA_VARIANT),shield)
LOCAL_PATH := $(call my-dir)

# Blobs built before Android 8 call __aeabi_* helpers libc no longer exports.
# scripts/fixup-intrinsics.py points them at libw instead (libm.so -> libw.so,
# __aeabi_x -> s_aeabi_x, same lengths, rewritten in place). It runs here, on
# a copy in the intermediates, and the module installs that copy -- so R's
# ELF check, which reads the prebuilt before it is installed, sees the blob
# as it will ship rather than one that looks broken until a later step
# repairs it. The files in this repository stay as NVIDIA shipped them.
#
#   LOCAL_PREBUILT_MODULE_FILE := $(call shield-intrinsics-fixed,$(LOCAL_PATH)/lib/x.so)
#
# scripts/elf_deps.py writes that line for every blob that needs it.
SHIELD_INTRINSICS_FIXUP := $(LOCAL_PATH)/scripts/fixup-intrinsics.py

define shield-intrinsics-fixed
$(strip $(eval _sif_out := $(TARGET_OUT_INTERMEDIATES)/SHIELD_INTRINSICS_FIXUP/$(1))\
$(if $(filter $(_sif_out),$(SHIELD_INTRINSICS_FIXED)),,\
$(eval SHIELD_INTRINSICS_FIXED += $(_sif_out))\
$(eval $(call _shield-intrinsics-fixed-rule,$(1),$(_sif_out))))\
$(_sif_out))
endef

# One output per blob, and the script is handed that one file, so parallel
# jobs never write the same path.
define _shield-intrinsics-fixed-rule
$(2): $(1) $(SHIELD_INTRINSICS_FIXUP)
	@mkdir -p $$(dir $$@)
	$$(hide) cp -f $$< $$@
	$$(hide) python3 $(SHIELD_INTRINSICS_FIXUP) $$@ >/dev/null
endef

# A library whose name has to change -- its SONAME, or a DT_NEEDED entry
# naming a library that ships under another name -- is renamed in a copy by
# scripts/elf_rename.py, always to a name of the same length, rewriting only
# the whole NUL-terminated string in place. Nothing in the file moves; patchelf
# moved the program headers, and bionic refused what it produced.
#
#   LOCAL_PREBUILT_MODULE_FILE := $(call shield-renamed,<source>,OLD=NEW ...)
#
# The source may itself be a shield-intrinsics-fixed copy.
SHIELD_RENAME := $(LOCAL_PATH)/scripts/elf_rename.py

define shield-renamed
$(strip $(eval _srn_out := $(TARGET_OUT_INTERMEDIATES)/SHIELD_RENAMED/$(subst =,-,$(firstword $(2)))/$(notdir $(1)))\
$(if $(filter $(_srn_out),$(SHIELD_RENAMED)),,\
$(eval SHIELD_RENAMED += $(_srn_out))\
$(eval $(call _shield-renamed-rule,$(1),$(_srn_out),$(2))))\
$(_srn_out))
endef

define _shield-renamed-rule
$(2): $(1) $(SHIELD_RENAME)
	@mkdir -p $$(dir $$@)
	$$(hide) python3 $(SHIELD_RENAME) $$< $$@ $(3)
endef

include $(call all-makefiles-under,$(LOCAL_PATH))
endif
