package com.example.flutter_bluetooth.utils

import android.os.Build
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

    /**
     * 可配置的需要忽略的手机型号
     */
    private var mSppBlackList = arrayListOf<String>()

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

    fun setSppBlackList(models: List<String>?) {
        mSppBlackList.clear()
        if (models != null) {
            mSppBlackList.addAll(models)
        }
    }

    /**
     * 手机型号是否要忽略,true：表示忽略
     */
    @JvmStatic
    fun checkSppBlackList(): Boolean {
        try {
            val model: String = Build.MODEL
            if (TextUtils.isEmpty(model)) {
                Logger.p("not ignore, model is empty!")
                return false
            }
            if (mSppBlackList.isEmpty()) {
                Logger.p("not ignore, config list is empty!")
                return false
            }
            val configPhoneModel = mSppBlackList.filter { model == it }
            Logger.p("config phone model : $configPhoneModel, model: $model")
            return configPhoneModel.isNotEmpty()
        } catch (e: Exception) {
        }
        return false
    }

}