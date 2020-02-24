# Copyright (C) 2017 arttttt(SmokeDevTeam)
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

# Audio
PRODUCT_PACKAGES += \
    audio.primary.vendor.tegra \
    libaudioavp \
    libbt-client-api \
    libnvaudioservice \
    libnvcapaudioservice \
    libnvcapclk \
    libnvoice \
    alsaold

# Executables & Apps
PRODUCT_PACKAGES += \
    macaddr.sh

# Firmware
PRODUCT_PACKAGES += \
    lp5521 \
    bq27520_atl \
    bq27520_lgc

# HAL
PRODUCT_PACKAGES += \
    libsensors.lsm6db0 \
    libsensors.mpu6515

# Keylayout
PRODUCT_PACKAGES += \
    atmel-maxtouch \
    synaptics_dsx \
    tegra-rt5671_headphone_detect

# Wireless
PRODUCT_PACKAGES += \
    mocha_fw_bcmdhd \
    mocha_fw_bcmdhd_apsta \
    mocha_bcm4350 \
    mocha_nvram
