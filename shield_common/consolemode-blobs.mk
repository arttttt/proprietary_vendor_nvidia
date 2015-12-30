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
PRODUCT_PACKAGES += ConsoleUI

# Libs. 32-bit only right now.
PRODUCT_COPY_FILES += \
    vendor/nvidia/shield_common/proprietary/vendor/lib/liblota.so:system/vendor/lib/liblota.so \
    vendor/nvidia/shield_common/proprietary/vendor/lib/libnvhwc_service.so:system/vendor/lib/libnvhwc_service.so \
    vendor/nvidia/shield_common/proprietary/vendor/lib/libshieldtech.so:system/vendor/lib/libshieldtech.so
