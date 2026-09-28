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
LOCAL_MODULE := libwvdrmengine
LOCAL_PREBUILT_MODULE_FILE := $(call shield-intrinsics-fixed,$(LOCAL_PATH)/lib/mediadrm/libwvdrmengine.so)
LOCAL_MODULE_SUFFIX := .so
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_TARGET_ARCH := arm
LOCAL_MODULE_PATH := $($(TARGET_2ND_ARCH_VAR_PREFIX)TARGET_OUT_VENDOR_SHARED_LIBRARIES)/mediadrm
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_OWNER := widevine
LOCAL_SHARED_LIBRARIES := libcutils liblog libprotobuf-cpp-lite-v29 libstagefright_foundation libutils libw
include $(BUILD_PREBUILT)

# libwvdrmengine is the Pixel C plugin from Android 8.1, built against the
# protobuf of its day. R's libprotobuf-cpp-lite is 3.9.1 under a versioned
# SONAME and no longer exports what the plugin calls
# (google::protobuf::internal::empty_string_ among others), so the plugin's
# DT_NEEDED was rewritten with patchelf to libprotobuf-cpp-lite-v29.so, and
# this ships the Android 10 build of that library under the name -- the fix
# LineageOS device trees of this age carry on 18.1. Taken straight from the
# tree's own VNDK v29 snapshot rather than copied in here.
include $(CLEAR_VARS)
LOCAL_MODULE := libprotobuf-cpp-lite-v29
LOCAL_PREBUILT_MODULE_FILE := prebuilts/vndk/v29/arm/arch-arm-armv7-a-neon/shared/vndk-core/libprotobuf-cpp-lite.so
LOCAL_MODULE_SUFFIX := .so
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_TARGET_ARCH := arm
LOCAL_MODULE_PATH := $($(TARGET_2ND_ARCH_VAR_PREFIX)TARGET_OUT_VENDOR_SHARED_LIBRARIES)
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_OWNER := widevine
# Its SONAME stays libprotobuf-cpp-lite.so, which is how the snapshot built
# it; the file name is what the plugin now asks for.
LOCAL_CHECK_ELF_FILES := false
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := liboemcrypto
LOCAL_SRC_FILES := lib/liboemcrypto.so
LOCAL_MODULE_SUFFIX := .so
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_TARGET_ARCH := arm
LOCAL_MODULE_PATH := $($(TARGET_2ND_ARCH_VAR_PREFIX)TARGET_OUT_VENDOR_SHARED_LIBRARIES)
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_OWNER := nvidia
LOCAL_SHARED_LIBRARIES := libnvavp libnvos libnvrm liblog libtlk_secure_hdcp_up libcutils
include $(BUILD_PREBUILT)

