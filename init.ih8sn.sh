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
