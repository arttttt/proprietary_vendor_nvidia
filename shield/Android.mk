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

# A blob installed under a name other than its DT_SONAME gets the name it
# ships as written into a copy, the same way: R's ELF check requires the two
# to match, and so does the linker once two libraries could answer to one
# SONAME.
#
#   LOCAL_PREBUILT_MODULE_FILE := $(call shield-soname-fixed,<source>,<soname>)
SHIELD_PATCHELF := prebuilts/extract-tools/linux-x86/bin/patchelf-0_9

define shield-soname-fixed
$(strip $(eval _ssf_out := $(TARGET_OUT_INTERMEDIATES)/SHIELD_SONAME_FIXED/$(2)/$(notdir $(1)))\
$(if $(filter $(_ssf_out),$(SHIELD_SONAME_FIXED)),,\
$(eval SHIELD_SONAME_FIXED += $(_ssf_out))\
$(eval $(call _shield-soname-fixed-rule,$(1),$(_ssf_out),$(2))))\
$(_ssf_out))
endef

define _shield-soname-fixed-rule
$(2): $(1) $(SHIELD_PATCHELF)
	@mkdir -p $$(dir $$@)
	$$(hide) cp -f $$< $$@
	$$(hide) $(SHIELD_PATCHELF) --set-soname $(3) $$@
endef

include $(call all-makefiles-under,$(LOCAL_PATH))
endif
