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
