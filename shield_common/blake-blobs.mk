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
PRODUCT_PACKAGES += BlakePairing

# Libs for all arm archs
PRODUCT_COPY_FILES += \
    vendor/nvidia/shield_common/proprietary/vendor/lib/liblota.so:system/vendor/lib/liblota.so \
    vendor/nvidia/shield_common/proprietary/vendor/lib/libhidraw.so:system/vendor/lib/libhidraw.so \
    vendor/nvidia/shield_common/proprietary/vendor/lib/libfirmwareupdate.so:system/vendor/lib/libfirmwareupdate.so \
    vendor/nvidia/shield_common/proprietary/vendor/lib/libshieldtech.so:system/vendor/lib/libshieldtech.so \
    vendor/nvidia/shield_common/proprietary/vendor/lib/hw/audio.nvrc.tegra.so:system/vendor/lib/hw/audio.nvrc.tegra.so \
    vendor/nvidia/shield_common/proprietary/vendor/lib/hw/audio.nvwc.tegra.so:system/vendor/lib/hw/audio.nvwc.tegra.so

# Media files
PRODUCT_COPY_FILES += \
    vendor/nvidia/shield_common/proprietary/vendor/oem/media/blake_connecting.mp4:system/vendor/oem/media/blake_connecting.mp4 \
    vendor/nvidia/shield_common/proprietary/vendor/oem/media/blake_error.mp4:system/vendor/oem/media/blake_error.mp4 \
    vendor/nvidia/shield_common/proprietary/vendor/oem/media/blake_found.mp4:system/vendor/oem/media/blake_found.mp4 \
    vendor/nvidia/shield_common/proprietary/vendor/oem/media/blake_success.mp4:system/vendor/oem/media/blake_success.mp4 \
    vendor/nvidia/shield_common/proprietary/vendor/oem/media/pair_loop.mp4:system/vendor/oem/media/pair_loop.mp4 \
    vendor/nvidia/shield_common/proprietary/vendor/oem/media/pair_start.mp4:system/vendor/oem/media/pair_start.mp4 \
    vendor/nvidia/shield_common/proprietary/vendor/oem/media/sync_test.mp4:system/vendor/oem/media/sync_test.mp4 \
    vendor/nvidia/shield_common/proprietary/vendor/oem/media/update_error.mp4:system/vendor/oem/media/update_error.mp4 \
    vendor/nvidia/shield_common/proprietary/vendor/oem/media/update_idle.mp4:system/vendor/oem/media/update_idle.mp4 \
    vendor/nvidia/shield_common/proprietary/vendor/oem/media/update_in_progress.mp4:system/vendor/oem/media/update_in_progress.mp4 \
    vendor/nvidia/shield_common/proprietary/vendor/oem/media/update_intro.mp4:system/vendor/oem/media/update_intro.mp4 \
    vendor/nvidia/shield_common/proprietary/vendor/oem/media/update_success.mp4:system/vendor/oem/media/update_success.mp4
