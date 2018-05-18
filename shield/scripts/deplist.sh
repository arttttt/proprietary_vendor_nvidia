#!/bin/bash

DEVICE="";
TARGETARCH="aarch64";
TARGETVERSION="t210";

finddep()
{
  deploc="";
  echo "$1 $2" >> deplist_checked.txt;
  filearr=($(find .. -name "$1.${TARGETVERSION}.so"))
  filearr+=($(find .. -name "$1.so"))
  for possdep in ${filearr[@]};
  do
    if [ "$(readelf -h ${possdep} |grep Machine |awk '{ print tolower($2) }')" == "$2" ]; then
      deploc=${possdep};
      break;
    fi;
  done;

  if [ "${TARGETARCH}" == "aarch64" -a "${2}" == "arm" ]; then
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

  FILEARCH=$(readelf -h ${1} |grep Machine |awk '{ print tolower($2) }');
  for dep in $(objdump -x ${1} |grep NEEDED |awk '{ print $2 }' |rev |cut -d. -f2- |rev); do
    if ! grep "^${dep} ${FILEARCH}$" deplist_checked.txt >/dev/null; then
      finddep ${dep} "${FILEARCH}"
      getdeps ${deploc}
    fi;
  done;
}

DEVICE=${1};
if [ -n "${2}" ]; then TARGETARCH=${2}; fi;
if [ -n "${3}" ]; then TARGETVERSION=${3}; fi;

> deplist_checked.txt

echo "# Copyright (C) 2017 The Android Open Source Project" > ../${DEVICE}-generated.mk
echo "#" >> ../${DEVICE}-generated.mk
echo "# Licensed under the Apache License, Version 2.0 (the "License");" >> ../${DEVICE}-generated.mk
echo "# you may not use this file except in compliance with the License." >> ../${DEVICE}-generated.mk
echo "# You may obtain a copy of the License at" >> ../${DEVICE}-generated.mk
echo "#" >> ../${DEVICE}-generated.mk
echo "#      http://www.apache.org/licenses/LICENSE-2.0" >> ../${DEVICE}-generated.mk
echo "#" >> ../${DEVICE}-generated.mk
echo "# Unless required by applicable law or agreed to in writing, software" >> ../${DEVICE}-generated.mk
echo "# distributed under the License is distributed on an "AS IS" BASIS," >> ../${DEVICE}-generated.mk
echo "# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied." >> ../${DEVICE}-generated.mk
echo "# See the License for the specific language governing permissions and" >> ../${DEVICE}-generated.mk
echo "# limitations under the License." >> ../${DEVICE}-generated.mk
echo "" >> ../${DEVICE}-generated.mk
echo "PRODUCT_PACKAGES += \\" >> ../${DEVICE}-generated.mk
echo "PRODUCT_PACKAGES += \\" > deplist_targets.txt
echo "PRODUCT_PACKAGES += \\" > deplist_notfound.txt

while read file; do
  filename="$(echo "${file}" |sed 's/.'${TARGETVERSION}'//' |rev |cut -d. -f2- |cut -d/ -f1 |rev)"
  if [ "${TARGETARCH}" == "aarch64" -a "$(readelf -h ../${file} |grep Machine |awk '{ print tolower($2) }')" == "arm" ]; then
    filename=${filename}_32;
  fi;
  echo "                    ${filename} \\" >> ../${DEVICE}-generated.mk;
  getdeps ../${file};
done < ${1}.targets;

sed -i '$ s/ \\$//' ../${DEVICE}-generated.mk

rm deplist_checked.txt
