#!/bin/bash

DEVICE="";
TARGETARCH="aarch64";

finddep()
{
  deploc="";
  echo "$1 $2" >> deplist_checked.txt;
  filearr=($(find .. -name "$1.so"))
  for possdep in ${filearr[@]};
  do
    if [ "$(file -b ${possdep} |awk -F, '{ gsub(/^[ \t]+/,"",$2); print $2 }')" == "$2" ]; then
      deploc=${possdep};
      break;
    fi;
  done;

  if [ "${TARGETARCH}" == "aarch64" -a "${2}" == "ARM" ]; then
    depname=${1}_32;
  else
    depname=${1};
  fi;

  if [ -z "${deploc}" ]; then
    if grep "^${1}$" deplist_known_targets.txt >/dev/null; then
      echo "                    $depname \\" >> deplist_targets.txt;
    else
      echo "                    $depname \\" >> deplist_notfound.txt;
    fi;
  else
    echo "                    $depname \\" >> ../${DEVICE}-generated.mk;
  fi;
}

getdeps()
{
  if [ -z "${1}" ]; then return; fi;

  FILEARCH=$(file -b ${1} |awk -F, '{ gsub(/^[ \t]+/,"",$2); print $2 }');
  for dep in $(objdump -x ${1} |grep NEEDED |awk '{ print $2 }' |rev |cut -d. -f2- |rev); do
    if ! grep "^${dep} ${FILEARCH}$" deplist_checked.txt >/dev/null; then
      finddep ${dep} "${FILEARCH}"
      getdeps ${deploc}
    fi;
  done;
}

DEVICE=${1};
if [ -n "${2}" ]; then TARGETARCH=${2}; fi;

> deplist_checked.txt

echo "PRODUCT_PACKAGES += \\" > ../${DEVICE}-generated.mk
echo "PRODUCT_PACKAGES += \\" > deplist_targets.txt
echo "PRODUCT_PACKAGES += \\" > deplist_notfound.txt

while read file; do
  filename="$(echo "${file}" |rev |cut -d. -f2- |cut -d/ -f1 |rev)"
  if [ "${TARGETARCH}" == "aarch64" -a "$(file -b ../${file} |awk -F, '{ gsub(/^[ \t]+/,"",$2); print $2 }')" == "ARM" ]; then
    filename=${filename}_32;
  fi;
  echo "                    ${filename} \\" >> ../${DEVICE}-generated.mk;
  getdeps ../${file};
done < ${1}.targets;

rm deplist_checked.txt
