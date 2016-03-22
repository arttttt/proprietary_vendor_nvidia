# Copyright (C) 2014 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Apk
PRODUCT_PACKAGES += NvCamera

# Libs. 32-bit only right now.
PRODUCT_COPY_FILES += \
    vendor/nvidia/shield_common/proprietary/vendor/lib/libcom_nvidia_nvcamera_util_NativeUtils.so:system/vendor/lib/libcom_nvidia_nvcamera_util_NativeUtils.so \
    vendor/nvidia/shield_common/proprietary/vendor/lib/libjni_nvmosaic_shield.so:system/vendor/lib/libjni_nvmosaic_shield.so \
    vendor/nvidia/shield_common/proprietary/vendor/lib/libnvjni_jpegutil.so:system/vendor/lib/libnvjni_jpegutil.so \
    vendor/nvidia/shield_common/proprietary/vendor/lib/libnvjni_tinyplanet.so:system/vendor/lib/libnvjni_tinyplanet.so \
    vendor/nvidia/shield_common/proprietary/vendor/lib/libnvraw_creator.so:system/vendor/lib/libnvraw_creator.so
