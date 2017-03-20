#!/system/bin/sh

# Copyright (c) 2012-2014, NVIDIA CORPORATION.  All rights reserved.
#
# NVIDIA CORPORATION and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA CORPORATION is strictly prohibited.

if [ $(getprop ro.boot.commchip_id) -gt 0 ]; then
	echo "setting user configured value of WiFi chipset"
	setprop wifi.commchip_id $(getprop ro.boot.commchip_id)
	exit
fi
# vendor id defines
BRCM=0x02d0
TI=0x0097
MRVL=0x02df
brcm_symlink=y

#find hardware used and assigned corresponding mmc interface used for wifi chip
mmc=mmc2
if [ $(getprop ro.product.name) == "cardhu" ]; then
	mmc=mmc1
fi

vendor=$(cat /sys/bus/sdio/devices/$mmc:0001:1/vendor)
device=$(cat /sys/bus/sdio/devices/$mmc:0001:1/device)

vendor_device="$vendor"_"$device"
#Read vendor and product idea enumerated during kernel boot
if [ -z "$(getprop persist.commchip_vendor)" ]; then
	/system/bin/log -t "wifiloader" -p i "persist.commchip_vendor not defined. Reading enumerated data"
	setprop persist.commchip_vendor $vendor
	setprop persist.commchip_device $device
elif [ $vendor_device = $(getprop persist.commchip_vendor)"_"$(getprop persist.commchip_device) ]; then
	/system/bin/log -t "wifiloader" -p i "persist.commchip_vendor defined by user. Using user-defined config"
	#check if symlinks are available; if available, do not create symlinks
	#this check is needed when data partition is remounted after encryption
	if [ -L /data/misc/wifi/firmware/fw_bcmdhd.bin ]; then
		brcm_symlink=n
	fi
else
	/system/bin/log -t "wifiloader" -p i "Comm chip replaced by user. reset symlinks if needed"
	if [ $vendor = $BRCM ]; then
		/system/bin/rm /data/misc/wifi/firmware/fw_bcmdhd.bin
		/system/bin/rm /data/misc/wifi/firmware/fw_bcmdhd_apsta.bin
		/system/bin/rm /data/misc/wifi/firmware/nvram.txt
	fi
	setprop persist.commchip_vendor $vendor
	setprop persist.commchip_device $device
fi

#Find device and set configurations
#ti comm chip
if [ $vendor_device = $TI"_0x4076" ]; then
	commchip_id=wl12xx
#broadcomm comm chip
elif [ $vendor = $BRCM ]; then
	if [ $device = "0x4329" ]; then
		/system/bin/log -t "wifiloader" -p i  "BCM4329 chip identified"
		chip="4329"
	elif [ $device = "0x4330" ]; then
		/system/bin/log -t "wifiloader" -p i  "BCM4330 chip identified"
		chip="4330"
	elif [ $device = "0x4334" ]; then
		/system/bin/log -t "wifiloader" -p i  "BCM3434 chip identified"
		chip="4334"
	elif [ $device = "0xa94d" ]; then
		/system/bin/log -t "wifiloader" -p i  "BCM43341 chip identified"
		chip="43341"
	elif [ $device = "0x4324" ]; then
		/system/bin/log -t "wifiloader" -p i  "BCM43241 chip identified"
		chip="43241"
	elif [ $device = "0x4335" ]; then
                /system/bin/log -t "wifiloader" -p i  "BCM4335 chip identified"
                chip="4335"
	elif [ $device = "0x4339" ]; then
                /system/bin/log -t "wifiloader" -p i  "BCM4339 chip identified"
                chip="4339"
	fi

	if [ $brcm_symlink = y ]; then
		/system/bin/ln -s /system/vendor/firmware/bcm$chip/fw_bcmdhd.bin /data/misc/wifi/firmware/fw_bcmdhd.bin
		/system/bin/ln -s /system/vendor/firmware/bcm$chip/fw_bcmdhd.bin /data/misc/wifi/firmware/fw_bcmdhd_apsta.bin
		/system/bin/ln -s /system/etc/nvram_$chip.txt /data/misc/wifi/firmware/nvram.txt
		echo "/data/misc/wifi/firmware/fw_bcmdhd.bin" > /data/misc/wifi/firmware/firmware_path
	fi
	insmod /system/lib/modules/cfg80211.ko
	if [  $chip = "4335" ]; then
		insmod /system/lib/modules/bcm4335.ko
	else
		insmod /system/lib/modules/bcmdhd.ko
	fi
	setprop wifi.supplicant p2p_supplicant
#marvel comms chip
elif [ $vendor_device = "$MRVL""_0x9129" ]; then
	/system/bin/log -t "wifiloader" -p i  "MRVL8797 chip identified"
	insmod /system/lib/modules/cfg80211.ko
	insmod /system/lib/modules/mlan.ko
	insmod /system/lib/modules/sd8xxx.ko "drv_mode=1 cfg80211_wext=12 fw_name=sd8797_uapsta.bin"
	setprop wifi.supplicant p2p_supplicant
fi

#increase the wmem default and wmem max size
echo 262144 > /proc/sys/net/core/wmem_default
echo 262144 > /proc/sys/net/core/wmem_max

#sleep for -1 timeout, so that wifiloader can be run as daemon
sleep 4294967295
