#!/system/bin/sh

#avoid firmware update at very first boot, which reboots abruptly
sleep 30

tool="/system/vendor/bin/cyload"
dev_file="/sys/class/leds/led_lightbar/version"
fw_bin_file="/system/vendor/firmware/psoc_foster_fw.cyacd"
result_latest="status: latest"
result_update="status: update"
result_error="status: error"
log_tool="/system/bin/log"
result=$($tool $dev_file v $fw_bin_file | grep "status:")

if [ "$result" == "$result_update" ]; then
    $log_tool -t "cyupdate" -p i "Update fw..."
    log=$($tool /dev/cy8c-led-boot f $fw_bin_file)
# need to print the message for debug purpuse.
    $log_tool -t "cyupdate" -p i $log
    mode=$(cat /sys/class/leds/led_lightbar/boot_mode)
    if [ "$mode" == "boot" ]; then
        $log_tool -t "cyupdate" -p i "error detected, retry flash"
        log=$($tool /dev/cy8c-led-boot f $fw_bin_file)
        $log_tool -t "cyupdate" -p i $log
    fi
    if [ "$mode" == "app" ]; then
        $log_tool -t "cyupdate" -p i "flash successfully"
    fi
    $log_tool -t "cyupdate" -p i "Update fw done"
fi

if [ "$result" == "$result_latest" ]; then
    $log_tool -t "cyupdate" -p i "Fw latest"
fi

if [ "$result" == "$result_error" ]; then
    $log_tool -t "cyupdate" -p i "Error detected, please fix"
fi
