#!/system/bin/sh
echo "cat BKB partition"
BKB=$(cat /dev/block/platform/sdhci-tegra.3/by-name/BKB | grep -a XIAOMI)
echo "cat of BKB partition was sucessfull"
if [ "$BKB" = "" ]; then
echo "BKB partition is NULL, generating the mac"
Serialno=$(echo $(dmesg | grep -i androidboot.serialno) | sed 's|.*serialno=||' | awk '{print $1}')
md5sumserialno=$(echo -n $Serialno | md5sum)
mac="0c:1d:${md5sumserialno:7:2}:${md5sumserialno:9:2}:${md5sumserialno:11:2}:${md5sumserialno:14:2}"
mount -o remount,rw /system
echo $mac > /system/etc/mocha_macaddr.txt
chmod 644 /system/etc/mocha_macaddr.txt
mount -o remount,ro /system
else
echo "original mac address found"
fi
