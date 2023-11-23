#
# Copyright (C) 2023 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Inherit from houji device
$(call inherit-product, device/xiaomi/houji/device.mk)

PRODUCT_DEVICE := houji
PRODUCT_NAME := lineage_houji
PRODUCT_BRAND := Xiaomi
PRODUCT_MODEL := 23127PN0CC
PRODUCT_MANUFACTURER := xiaomi

PRODUCT_GMS_CLIENTID_BASE := android-xiaomi

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="houji-user 14 UKQ1.230804.001 V816.0.9.0.UNCCNXM release-keys"

BUILD_FINGERPRINT := Xiaomi/houji/houji:14/UKQ1.230804.001/V816.0.9.0.UNCCNXM:user/release-keys
