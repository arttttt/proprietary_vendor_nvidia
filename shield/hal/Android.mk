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

LOCAL_PATH := $(call my-dir)

# Installed under the name the wrapper does not take. The device tree builds
# its own allocator as gralloc.tegra, which is the name ro.board.platform
# selects, and opens this one by full path. The file in this repository keeps
# the name NVIDIA gave it; only what it is installed as changes.
include $(CLEAR_VARS)
LOCAL_MODULE := gralloc.nvidia
LOCAL_SRC_FILES := lib/hw/gralloc.tegra.so
LOCAL_MODULE_SUFFIX := .so
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_TARGET_ARCH := arm
LOCAL_MODULE_PATH := $($(TARGET_2ND_ARCH_VAR_PREFIX)TARGET_OUT_VENDOR_SHARED_LIBRARIES)/hw
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_OWNER := nvidia
# The SONAME stays gralloc.tegra.so while the file is installed as
# gralloc.nvidia.so, and that is the whole point of the rename above; R's ELF
# check would insist the two match.
LOCAL_CHECK_ELF_FILES := false
LOCAL_SHARED_LIBRARIES := liblog libcutils libsync libnvgr libnvos libnvrm libnvrm_graphics libnvblit
include $(BUILD_PREBUILT)

# hwcomposer.tegra does not come from here, and neither does the HWC1 blob that
# used to sit in lib/hw/. The module of that name is built by
# hardware/nvidia/hwcomposer; declaring it in both places stops the build
# outright, with
#
#   vendor/nvidia/shield/hal: MODULE.TARGET.SHARED_LIBRARIES.hwcomposer.tegra
#   already defined by hardware/nvidia/hwcomposer.
#
# The old blob is in this repository's history if it is ever wanted as a
# reference for how the display controller was driven.

include $(CLEAR_VARS)
LOCAL_MODULE := keystore.tegra
LOCAL_SRC_FILES := lib/hw/keystore.tegra.so
LOCAL_MODULE_SUFFIX := .so
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_TARGET_ARCH := arm
LOCAL_MODULE_PATH := $($(TARGET_2ND_ARCH_VAR_PREFIX)TARGET_OUT_VENDOR_SHARED_LIBRARIES)/hw
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_OWNER := nvidia
LOCAL_SHARED_LIBRARIES := liblog
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := memtrack.tegra
LOCAL_SRC_FILES := lib/hw/memtrack.tegra.so
LOCAL_MODULE_SUFFIX := .so
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_TARGET_ARCH := arm
LOCAL_MODULE_PATH := $($(TARGET_2ND_ARCH_VAR_PREFIX)TARGET_OUT_VENDOR_SHARED_LIBRARIES)/hw
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_OWNER := nvidia
LOCAL_SHARED_LIBRARIES := liblog libcutils
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := vulkan.tegra
LOCAL_SRC_FILES := lib/hw/vulkan.tegra.so
LOCAL_MODULE_SUFFIX := .so
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_TARGET_ARCH := arm
LOCAL_MODULE_PATH := $($(TARGET_2ND_ARCH_VAR_PREFIX)TARGET_OUT_VENDOR_SHARED_LIBRARIES)/hw
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_OWNER := nvidia
LOCAL_SHARED_LIBRARIES := liblog libEGL libutils
include $(BUILD_PREBUILT)
