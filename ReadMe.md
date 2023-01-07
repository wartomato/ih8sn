ih8sn injects various build properties via a config on init and partially on boot.
It can be build inline with a ROM.

Example config file:
```
# BUILD_FINGERPRINT=OnePlus/OnePlus7Pro_EEA/OnePlus7Pro:12/SKQ1.211113.001/P.202210112115:user/release-keys
# BUILD_DESCRIPTION=OnePlus7Pro-user 12 SKQ1.211113.001 2210112115 release-keys
# BUILD_SECURITY_PATCH_DATE=2022-08-05
BUILD_TAGS=release-keys
BUILD_TYPE=user
# BUILD_VERSION_RELEASE=12
# BUILD_VERSION_RELEASE_OR_CODENAME=12
DEBUGGABLE=0
# MANUFACTURER_NAME=OnePlus
# PRODUCT_NAME=OnePlus7Pro_EEA
# PRODUCT_MODEL=GM1913
```
Only the properties that should be altered should be enabled by removing the "# " in front of the line.
By default a few are enabled plus some boot properties:
```
ro.boot.flash.locked=1
ro.boot.vbmeta.device_state=locked
ro.boot.verifiedbootstate=green
ro.boot.veritymode=enforcing
ro.is_ever_orange=0
ro.secure=1
ro.warranty_bit=0
```
All needed config - apart from building ih8sn with the ROM - need to be copied on build to system/etc as shown here:
```
PRODUCT_COPY_FILES +=
$(LOCAL_PATH)/configs/ih8sn.conf:$(TARGET_COPY_OUT_SYSTEM)/etc/ih8sn.conf
```
Depending on the injection for the device, the config file can be renamed with different props

- serial number
- Product
- Model
- rf_version (radio frequency, if applicable to determine a device variant)

A script will rename the appropriate config to use and inject it.
If you just want to inject the properties, use the "ih8sn.conf" included in the repo!

use an init script like this (named "init.ih8sn.sh) and build it with the init files:
```
#! /vendor/bin/sh

# Copyright (c) 2013-2014, 2019 The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of The Linux Foundation nor
#       the names of its contributors may be used to endorse or promote
#       products derived from this software without specific prior written
#       permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NON-INFRINGEMENT ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

#
# set the vendor path to get some sh commands from the toybox
#
export PATH=/vendor/bin

#
# get properties and if a valid config file is found, rename it to ih8sn.conf
#
serialno=`getprop ro.boot.serialno`
product=`getprop ro.build.product`
model=`getprop ro.product.model`
rf_version=`getprop ro.boot.rf_version`

if [[ -f `/system/etc/ih8sn.conf.${serialno}` ]]; then
    mv /system/etc/ih8sn.conf.${serialno} /system/etc/ih8sn.conf
elif [[ -f `/system/etc/ih8sn.conf.${product}` ]]; then
    mv /system/etc/ih8sn.conf.${product} /system/etc/ih8sn.conf
elif [[ -f `/system/etc/ih8sn.conf.${model}` ]]; then
    mv /system/etc/ih8sn.conf.${model} /system/etc/ih8sn.conf
else [[ -f `/system/etc/ih8sn.conf.rf${rf_version}` ]]; then
    mv /system/etc/ih8sn.conf.rf${rf_version} /system/etc/ih8sn.conf
fi
```
Inclusion in the init's Android.bp with:
```
sh_binary {
    name: "init.ih8sn.sh",
    src: "init.ih8sn.sh",
    device_specific: true,
}
```
