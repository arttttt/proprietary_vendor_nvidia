# Copyright (C) 2017 The LineageOS Project
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

# Bins
PRODUCT_PACKAGES += \
    blake \
    lota

# Audio hals
PRODUCT_PACKAGES += \
    audio.nvrc.tegra \
    audio.nvwc.tegra

# Media files
PRODUCT_COPY_FILES += \
    vendor/nvidia/shield/shieldtech/media/sync_test.mp4:system/vendor/oem/media/sync_test.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/ota/ota_finish_BLAKE.mp4:system/vendor/oem/media/blakepairing/ota/ota_finish_BLAKE.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/ota/ota_finish_JARVIS.mp4:system/vendor/oem/media/blakepairing/ota/ota_finish_JARVIS.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/ota/ota_finish_PEPPER.mp4:system/vendor/oem/media/blakepairing/ota/ota_finish_PEPPER.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/ota/ota_finish_THUNDERSTRIKE.mp4:system/vendor/oem/media/blakepairing/ota/ota_finish_THUNDERSTRIKE.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/ota/ota_loop_BLAKE.mp4:system/vendor/oem/media/blakepairing/ota/ota_loop_BLAKE.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/ota/ota_loop_JARVIS.mp4:system/vendor/oem/media/blakepairing/ota/ota_loop_JARVIS.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/ota/ota_loop_PEPPER.mp4:system/vendor/oem/media/blakepairing/ota/ota_loop_PEPPER.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/ota/ota_loop_THUNDERSTRIKE.mp4:system/vendor/oem/media/blakepairing/ota/ota_loop_THUNDERSTRIKE.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/ota/ota_start_BLAKE.mp4:system/vendor/oem/media/blakepairing/ota/ota_start_BLAKE.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/ota/ota_start_JARVIS.mp4:system/vendor/oem/media/blakepairing/ota/ota_start_JARVIS.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/ota/ota_start_PEPPER.mp4:system/vendor/oem/media/blakepairing/ota/ota_start_PEPPER.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/ota/ota_start_THUNDERSTRIKE.mp4:system/vendor/oem/media/blakepairing/ota/ota_start_THUNDERSTRIKE.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/pairing/pair_connecting_BLAKE.mp4:system/vendor/oem/media/blakepairing/pairing/pair_connecting_BLAKE.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/pairing/pair_connecting_JARVIS.mp4:system/vendor/oem/media/blakepairing/pairing/pair_connecting_JARVIS.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/pairing/pair_connecting_PEPPER.mp4:system/vendor/oem/media/blakepairing/pairing/pair_connecting_PEPPER.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/pairing/pair_connecting_THUNDERSTRIKE.mp4:system/vendor/oem/media/blakepairing/pairing/pair_connecting_THUNDERSTRIKE.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/pairing/pair_error_BLAKE.mp4:system/vendor/oem/media/blakepairing/pairing/pair_error_BLAKE.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/pairing/pair_error_JARVIS.mp4:system/vendor/oem/media/blakepairing/pairing/pair_error_JARVIS.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/pairing/pair_error_PEPPER.mp4:system/vendor/oem/media/blakepairing/pairing/pair_error_PEPPER.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/pairing/pair_error_THUNDERSTRIKE.mp4:system/vendor/oem/media/blakepairing/pairing/pair_error_THUNDERSTRIKE.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/pairing/pair_success_BLAKE.mp4:system/vendor/oem/media/blakepairing/pairing/pair_success_BLAKE.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/pairing/pair_success_JARVIS.mp4:system/vendor/oem/media/blakepairing/pairing/pair_success_JARVIS.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/pairing/pair_success_PEPPER.mp4:system/vendor/oem/media/blakepairing/pairing/pair_success_PEPPER.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/pairing/pair_success_THUNDERSTRIKE.mp4:system/vendor/oem/media/blakepairing/pairing/pair_success_THUNDERSTRIKE.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/pairing/pair_found_BLAKE.mp4:system/vendor/oem/media/blakepairing/pairing/pair_found_BLAKE.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/pairing/pair_found_THUNDERSTRIKE.mp4:system/vendor/oem/media/blakepairing/pairing/pair_found_THUNDERSTRIKE.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/pairing/pair_loop.mp4:system/vendor/oem/media/blakepairing/pairing/pair_loop.mp4 \
    vendor/nvidia/shield/shieldtech/media/blakepairing/pairing/pair_start.mp4:system/vendor/oem/media/blakepairing/pairing/pair_start.mp4
