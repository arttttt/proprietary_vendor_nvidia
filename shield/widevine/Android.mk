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

include $(CLEAR_VARS)
LOCAL_MODULE               := android.hardware.drm@1.2-service.widevine
LOCAL_VINTF_FRAGMENTS      := widevine.xml
LOCAL_SRC_FILES_32         := bin32/hw/android.hardware.drm@1.2-service.widevine
LOCAL_MULTILIB             := 32
LOCAL_INIT_RC              := etc/init/android.hardware.drm@1.2-service.widevine.rc
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_TAGS          := optional
LOCAL_MODULE_OWNER := widevine
LOCAL_VENDOR_MODULE        := true
LOCAL_MODULE_RELATIVE_PATH := hw
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := libwvdrmengine
LOCAL_SRC_FILES := lib/mediadrm/libwvdrmengine.so
LOCAL_MODULE_SUFFIX := .so
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_TARGET_ARCH := arm
LOCAL_MODULE_PATH := $($(TARGET_2ND_ARCH_VAR_PREFIX)TARGET_OUT_VENDOR_SHARED_LIBRARIES)/mediadrm
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_OWNER := widevine
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := liboemcrypto
LOCAL_SRC_FILES := lib/liboemcrypto.so
LOCAL_MODULE_SUFFIX := .so
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_TARGET_ARCH := arm
LOCAL_MODULE_PATH := $($(TARGET_2ND_ARCH_VAR_PREFIX)TARGET_OUT_VENDOR_SHARED_LIBRARIES)
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_OWNER := widevine
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := libwvhidl
LOCAL_SRC_FILES := lib/libwvhidl.so
LOCAL_MODULE_SUFFIX := .so
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_TARGET_ARCH := arm
LOCAL_MODULE_PATH := $($(TARGET_2ND_ARCH_VAR_PREFIX)TARGET_OUT_VENDOR_SHARED_LIBRARIES)
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_OWNER := widevine
LOCAL_SHARED_LIBRARIES     := android.hardware.drm@1.0 android.hardware.drm@1.1 android.hardware.drm@1.2 android.hidl.memory@1.0 libbase libc++ libc libcrypto libdl libhidlbase libhidlmemory liblog libm libprotobuf-cpp-lite libutils
LOCAL_CHECK_ELF_FILES      := false
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := libstlport
LOCAL_SRC_FILES := lib/libstlport.so
LOCAL_MODULE_SUFFIX := .so
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_TARGET_ARCH := arm
LOCAL_MODULE_PATH := $($(TARGET_2ND_ARCH_VAR_PREFIX)TARGET_OUT_VENDOR_SHARED_LIBRARIES)
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_OWNER := widevine
include $(BUILD_PREBUILT)
