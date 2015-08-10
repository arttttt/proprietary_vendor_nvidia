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

# Inherit the common libs
$(call inherit-product-if-exists, vendor/nvidia/shield_common/blake-blobs.mk)

# Arch specific libs and binaries
PRODUCT_COPY_FILES += \
    vendor/nvidia/shield_common/proprietary/vendor/lib64/libblake_jni.so:system/vendor/lib64/libblake_jni.so \
    vendor/nvidia/shield_common/proprietary/vendor/lib64/liblota.so:system/vendor/lib64/liblota.so \
    vendor/nvidia/shield_common/proprietary/vendor/lib64/hw/blake.tegra.so:system/vendor/lib64/hw/blake.tegra.so \
    vendor/nvidia/shield_common/proprietary/vendor/bin/blake64:system/vendor/bin/blake \
    vendor/nvidia/shield_common/proprietary/vendor/bin/lota64:system/vendor/bin/lota
