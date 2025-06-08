# Copyright (C) 2017 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the License);
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an AS IS BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

PRODUCT_PACKAGES += \
                    libnvddk_2d_v2 \
                    libnvrm \
                    libnvrm_graphics \
                    libnvddk_vic \
                    libnvgr \
                    libnvmm_utils \
                    libnvavp \
                    libnvtvmr \
                    libnvmm \
                    libcuda \
                    libnvrm_gpu \
                    gralloc.tegra \
                    libnvblit \
                    hwcomposer.tegra \
                    libnvhwc_service \
                    libtlk_secure_hdcp_up \
                    libtsechdcp \
                    keystore.tegra \
                    memtrack.tegra \
                    vulkan.tegra \
                    libmplmpu \
                    libmllite \
                    downloader \
                    tlk_daemon \
                    ss_status \
                    rm_ts_server \
                    librm_ts_service \
                    ts.default \
                    libEGL_tegra \
                    libtsec_wrapper \
                    libnvglsi \
                    libnvrmapi_tegra \
                    libnvcpl \
                    libGLESv1_CM_tegra \
                    libglcore \
                    libGLESv2_tegra \
                    libnvRSDriver \
                    libnvRSCompiler \
                    libnvwsi \
                    libnvmm_audio \
                    libnvmm_msaudio \
                    libnvmm_parser \
                    libnvmm_contentpipe \
                    libnvmm_writer \
                    libnvmmlite_audio \
                    libnvmmlite_utils \
                    libnvmmlite \
                    libnvmmlite_image \
                    libnvparser \
                    libnvmmlite_video \
                    libnvtnr \
                    libnvomx \
                    libnvomxadaptor \
                    libnvomxilclient \
                    libstagefrighthw \
		    libcuda \
		    libnvavp \
		    libnvparser \
		    libnvtnr \
		    libnvtvmr \
		    libnvrm_mem \
		    libnvrm_host1x \
		    libnvwsi \
		    libnvrm_stream \
		    libnvsocsys \
		    libnvrm_surface \
		    libnvrm_sync \
		    libnvrmvkif \
		    libnvimp \
		    libnvrm_chip \
		    libnvidia-ptxjitcompiler \
		    libnvidia-glvkspirv \
		    libnvdc \
		    libnvcucompat \
		    libnvcolorutil \
		    libmempoollocal \
		    libdolbycontrol \
		    libnvhwcomposer.dolby \
		    libnvos

# App
#PRODUCT_PACKAGES += \
#		    SimpleKeyboard

# Audio
PRODUCT_PACKAGES += \
		    libaptX_encoder \
		    libaptXHD_encoder

# Camera	    
PRODUCT_PACKAGES += \
		    camera.tegra \
		    libnvcamerahdr_v3 \
		    libnvcameranrr \
		    libnvcamerautils \
		    libnvcam_imageencoder \
		    libnvcamlog \
		    libnvcudautils \
		    libnvfnet \
		    libnvfnetstoredefog \
		    libnvfnetstorehdfx \
		    libnvisp_v3 \
		    libnvmm_camera_v3 \
		    libnvodm_imager \
		    libscf \
		    libnvvicsi_v3 \
		    libnvtstitching \
		    libnvidia_v3 \
		    libopencv24_tegra \
		    libprotobuf-cpp-lold \
		    libtbb 

# nvphs
PRODUCT_PACKAGES += \
		    libnvgov_boot \
		    libnvgov_camera \
		    libnvgov_force \
		    libnvgov_generic \
		    libnvgov_gpucompute \
		    libnvgov_graphics \
		    libnvgov_il \
		    libnvgov_spincircle \
		    libnvgov_tbc \
		    libnvgov_ui \
		    libnvphsd \
		    libnvphs \
		    libnvphens \
		    public.libraries \
		    vendor.nvidia.hardware.phs@1.0-impl
