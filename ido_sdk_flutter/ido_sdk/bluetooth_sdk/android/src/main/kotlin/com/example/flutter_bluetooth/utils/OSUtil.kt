package com.example.flutter_bluetooth.utils

import android.text.TextUtils
import com.example.flutter_bluetooth.logger.Logger
import java.util.Locale

object OSUtil {

    private const val OS_NAME_PROPERTY = "ro.product.system.name"
    private const val OS_BRAND_PROPERTY = "ro.product.system.brand"

    private const val OS_NAME = "magic"
    private const val OS_BRAND = "honor"

    private var mOSName: String? = null
    private var mOSBrand: String? = null
    private var mIsMagic = false

    private fun getSystemProperty(key: String, defaultValue: String): String {
        try {
            val clz = Class.forName("android.os.SystemProperties")
            val get = clz.getMethod("get", String::class.java, String::class.java)
            return get.invoke(clz, key, defaultValue) as String
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return defaultValue
    }

    /**
     * 是否是荣耀MagicOS
     */
    fun isMagicOS(): Boolean {
        try {
            if (mOSName == null && mOSBrand == null) {
                mOSBrand = getSystemProperty(OS_BRAND_PROPERTY, "").lowercase(Locale.getDefault())
                mOSName = getSystemProperty(OS_NAME_PROPERTY, "").lowercase(Locale.getDefault())
                mIsMagic = TextUtils.equals(OS_BRAND, mOSBrand) &&
                        TextUtils.equals(OS_NAME, mOSName)
            }
            Logger.p("os: $mOSBrand-$mOSName")
        } catch (_: Exception) {
        }
        return mIsMagic
    }

}