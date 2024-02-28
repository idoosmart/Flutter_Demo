package com.example.flutter_bluetooth.utils

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.fragment.app.Fragment


/**
 * @author tianwei
 * @date: 2022/5/19 7:09
 * @desc: 权限工具类
 */
object IDOPermission {
    /**
     * 检查ble扫描权限，针对不同的sdk版本，权限会有所不同
     * SDK>=31:
     * [Manifest.permission.BLUETOOTH_SCAN]
     * SDK<31:
     * [Manifest.permission.ACCESS_FINE_LOCATION]
     */
    @JvmStatic
    fun hasBlePermission(context: Context): Boolean {
        return hasPermissions(context, Permissions.getBleScanPermissions())
    }

    @JvmStatic
    fun hasOnlyBlePermission(context: Context): Boolean {
        return hasPermissions(context, Permissions.getOnlyBlePermissions())
    }

    fun requestBlePermission(activity: Activity, requestCode: Int) {
        requestPermissions(activity, Permissions.getBleScanPermissions(), requestCode);
    }

    fun hasAlwaysDeniedBlePermission(activity: Activity): Boolean {
        return hasAlwaysDeniedPermission(activity, Permissions.getBleScanPermissions())
    }

    fun hasPermissions(context: Context, permissions: Array<String>): Boolean {
        val deniedPermissions = findDeniedPermissions(context, permissions)
        return deniedPermissions.isNullOrEmpty()
    }

    private fun findDeniedPermissions(context: Context, permissions: Array<String>): List<String>? {
        if (permissions.isEmpty()) return null
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            return listOf()
        }
        return permissions.filter {
            ContextCompat.checkSelfPermission(context, it) != PackageManager.PERMISSION_GRANTED
        }
    }

    fun hasAlwaysDeniedPermission(activity: Activity, deniedPermissions: Array<String>): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) return false
        deniedPermissions.forEach {
            if (activity.shouldShowRequestPermissionRationale(it)) {
                return true
            }
        }
        return false
    }

    fun hasAlwaysDeniedPermission(
        fragment: Fragment,
        deniedPermissions: List<String>
    ): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) return false
        deniedPermissions.forEach {
            if (fragment.shouldShowRequestPermissionRationale(it)) {
                return true
            }
        }
        return false
    }

    fun requestPermissions(activity: Activity, permissions: Array<String>, requestCode: Int) {
        ActivityCompat.requestPermissions(activity, permissions, requestCode)
    }

    /**
     * @author tianwei
     * @date: 2022/5/19 7:23
     * @desc: 提供各种权限
     */
    object Permissions {
        fun getBleScanPermissions(): Array<String> {
            return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                arrayOf(
                    Manifest.permission.BLUETOOTH_SCAN,
                    Manifest.permission.BLUETOOTH_CONNECT
                )
            } else {
                arrayOf(
                    Manifest.permission.ACCESS_FINE_LOCATION,
                    Manifest.permission.ACCESS_COARSE_LOCATION,
                    Manifest.permission.BLUETOOTH_ADMIN,
                    Manifest.permission.BLUETOOTH
                )
            }
        }

        fun getOnlyBlePermissions():Array<String>{
            return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                arrayOf(
                    Manifest.permission.BLUETOOTH_SCAN,
                    Manifest.permission.BLUETOOTH_CONNECT
                )
            } else {
                arrayOf(
                    Manifest.permission.BLUETOOTH_ADMIN,
                    Manifest.permission.BLUETOOTH
                )
            }
        }
    }
}