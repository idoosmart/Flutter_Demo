package com.example.flutter_bluetooth.utils;

import android.Manifest;
import android.bluetooth.BluetoothAdapter;
import android.content.Context;
import android.content.pm.PackageManager;
import android.location.LocationManager;
import android.os.Build;
import android.os.Environment;

import androidx.core.app.ActivityCompat;

import com.example.flutter_bluetooth.Config;

/**
 * Created by zhouzj on 2018/7/26.
 */

public class PhoneInfoUtil {

    /**
     * 判断sd卡是否存在
     *
     * @return true:存在；false：不存在
     */
    public static boolean isSdcardExisting() {
        String state = Environment.getExternalStorageState();
        if (Environment.MEDIA_MOUNTED.equals(state)) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * 是否打开GPS
     *
     * @return
     */
    public static boolean isGPSOpen() {

        LocationManager locationManager = ((LocationManager) Config.getApplication().getSystemService(Context.LOCATION_SERVICE));
        return locationManager != null && locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER);

    }

    public static boolean isBluetoothOpen() {
        return BluetoothAdapter.getDefaultAdapter().isEnabled();
    }

    public static boolean hasBluetoothPermission() {
        return ActivityCompat.checkSelfPermission(Config.getApplication(), Manifest.permission.BLUETOOTH) == PackageManager.PERMISSION_GRANTED;
    }

    public static boolean hasBluetoothAdminPermission() {
        return ActivityCompat.checkSelfPermission(Config.getApplication(), Manifest.permission.BLUETOOTH_ADMIN) == PackageManager.PERMISSION_GRANTED;
    }

    public static boolean hasLocationPermission() {
        return ActivityCompat.checkSelfPermission(Config.getApplication(), Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED;
    }

    public static boolean hasBluetoothScanPermission() {
        return ActivityCompat.checkSelfPermission(Config.getApplication(), Manifest.permission.BLUETOOTH_SCAN) == PackageManager.PERMISSION_GRANTED;
    }

    public static boolean hasBluetoothConnectPermission() {
        return ActivityCompat.checkSelfPermission(Config.getApplication(), Manifest.permission.BLUETOOTH_CONNECT) == PackageManager.PERMISSION_GRANTED;
    }

    /**
     * 获取当前系统语言
     *
     * @return
     */
    public static String getLanguage() {
        return Config.getApplication().getResources().getConfiguration().locale.getLanguage();
    }

    /**
     * 获取当前手机系统版本号
     *
     * @return 系统版本号
     */
    public static String getSystemVersionCode() {
        return Build.VERSION.RELEASE;
    }

    public static int getSystemVersion() {
        return Build.VERSION.SDK_INT;
    }

    public static String getPhoneBluetoothAndGPSInfo() {
        String msg = "";
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            if (!PhoneInfoUtil.isBluetoothOpen()) {
                msg = "[bluetooth switch: off]";
            } else if (!PhoneInfoUtil.hasBluetoothScanPermission()) {
                msg = "[bluetooth scan permission: no]";
            } else if (!PhoneInfoUtil.hasBluetoothConnectPermission()) {
                msg = "[bluetooth connect permission: no]";
            }
        } else {
            if (!PhoneInfoUtil.isBluetoothOpen()) {
                msg = "[bluetooth switch: off]";
            } else if (!PhoneInfoUtil.hasBluetoothAdminPermission()) {
                msg = "[bluetooth permission: no]";
            } else if (!PhoneInfoUtil.isGPSOpen()) {
                msg = "[gps switch: off]";
            } else if (!PhoneInfoUtil.hasLocationPermission()) {
                msg = "[gps permission: no]";
            }
        }
        return msg;
    }

    public static boolean hasPhoneBluetoothPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            if (!PhoneInfoUtil.isBluetoothOpen()) {
                return false;
            } else if (!PhoneInfoUtil.hasBluetoothScanPermission()) {
                return false;
            } else if (!PhoneInfoUtil.hasBluetoothConnectPermission()) {
                return false;
            }
        } else {
            if (!PhoneInfoUtil.isBluetoothOpen()) {
                return false;
            } else if (!PhoneInfoUtil.hasBluetoothAdminPermission()) {
                return false;
            } else if (!PhoneInfoUtil.isGPSOpen()) {
                return false;
            } else if (!PhoneInfoUtil.hasLocationPermission()) {
                return false;
            }
        }
        return true;
    }
}
