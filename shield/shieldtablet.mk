#
# Copyright (C) 2014 The CyanogenMod Project
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
#

# Base needed libs
PRODUCT_PACKAGES += keystore.tegra \
                    camera.tegra \
                    gralloc.tegra \
                    hwcomposer.tegra \
                    audio.primary.tegra \
                    memtrack.tegra \
                    vulkan.tegra \
                    sensors.default.mpl520.nvs \
                    libril-icera \
                    icera-switcherd \
                    downloader \
                    libnvomx \
                    libnvomxadaptor \
                    libnvomxilclient \
                    libstagefrighthw \
                    tlk_daemon \
                    ss_status

# Scripts and non exe/shared objects
PRODUCT_PACKAGES += ss_status.sh \
                    wifi_loader \
                    bt_loader \
                    set_hwui_params \
                    hdcp1x \
                    hdcp2x \
                    hdcp2xtest

# Firmware
PRODUCT_PACKAGES += enctune \
                    nvram_43241 \
                    bcm43241 \
                    fw_bcmdhd \
                    nvavp_aacdec_ucode \
                    nvavp_aud_ucode \
                    nvavp_mp3dec_ucode \
                    nvavp_os_0ff00000 \
                    nvavp_os_8ff00000 \
                    nvavp_os_eff00000 \
                    nvavp_os_f7e00000 \
                    nvavp_vid_ucode \
                    nvavp_vid_ucode_alt \
                    tegra_xusb_firmware \
                    fecs \
                    gpccs \
                    gpmu_ucode \
                    NETB_img \
                    nvhost_msenc031 \
                    nvhost_tsec \
                    vic03_ucode

# Raydium support
PRODUCT_PACKAGES += rm_ts_server \
                    librm_ts_service \
                    librm31080 \
                    ts.default \
                    touch_para_10 \
                    para_10_02_00_a0 \
                    para_10_03_00_20 \
                    para_10_03_00_b0 \
                    para_10_04_00_c0 \
                    para_10_06_00_b0 \
                    para_10_08_00_20 \
                    para_10_08_00_b0 \
                    para_10_09_01_c0 \
                    para_10_0a_00_b0 \
                    para_10_02_00_20 \
                    para_10_02_00_b0 \
                    para_10_03_00_a0 \
                    para_10_04_00_b0 \
                    para_10_05_00_c0 \
                    para_10_07_00_b0 \
                    para_10_08_00_a0 \
                    para_10_09_00_c0 \
                    para_10_09_02_c0 \
                    para_10_0b_00_a0

# Widevine drm
PRODUCT_PACKAGES += libdrmwvmplugin \
                    libwvdrmengine \
                    libWVStreamControlAPI_L1 \
                    libwvdrm_L1 \
                    libdrmdecrypt \
                    libwvm \
                    liboemcrypto

# Local shield calculated dependencies
PRODUCT_PACKAGES += libnvos \
                    libnvrm \
                    libnvrm_graphics \
                    libnvmm \
                    libnvmm_utils \
                    libnvavp \
                    libnvddk_2d_v2 \
                    libnvddk_vic \
                    libnvgr \
                    libnvmm_contentpipe \
                    libnvmmlite \
                    libnvmmlite_utils \
                    libnvtvmr \
                    libnvoice \
                    libnvaudiofx \
                    libnvcam_imageencoder \
                    libscf \
                    libnvcamlog \
                    libnvcamerautils \
                    libcuda \
                    libnvrm_gpu \
                    libphs \
                    libnvisp_v3 \
                    libnvmm_camera_v3 \
                    libnvodm_imager \
                    libnvvicsi_v3 \
                    libopencv24_tegra \
                    libtbb \
                    libnvfnet \
                    libnvfnetstorehdfx \
                    libnvcamerahdr_v3 \
                    libnvblit \
                    libnvhwc_service \
                    libtlk_secure_hdcp_up \
                    libtsechdcp \
                    libsensors_hal.nvs \
                    libsensors_fusion.mpl520.nvs \
                    libmllite \
                    libmplmpu

# Dependencies from aosp calculated to be needed
PRODUCT_PACKAGES += libdl \
                    liblog \
                    libcutils \
                    libc++ \
                    libc \
                    libm \
                    libutils \
                    libz \
                    libsync \
                    libhardware \
                    libbinder \
                    libpowermanager \
                    libui \
                    libmedia \
                    libOpenSLES \
                    libstagefright \
                    libtinyalsa \
                    libtinycompress \
                    libaudioutils \
                    libexpat \
                    libnbaio \
                    libaudiospdif \
                    libicuuc \
                    libcamera_client \
                    libgui \
                    libhardware_legacy \
                    libjpeg \
                    libandroid \
                    libEGL \
                    libGLESv2 \
                    libpng \
                    libstdc++ \
                    libjnigraphics \
                    libprotobuf-cpp-lite \
                    libcamera_metadata \
                    libcameraservice \
                    libcrypto \
                    libnetutils \
                    libril \
                    librilutils \
                    libusbhost
