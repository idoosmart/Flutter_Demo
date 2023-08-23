package com.example.flutter_bluetooth.utils;

import android.annotation.SuppressLint;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.os.Build;
import android.text.TextUtils;

import com.example.flutter_bluetooth.logger.Logger;

import java.lang.reflect.Method;
import java.util.Set;

/**
 * Created by zhouzj on 2018/1/23.
 */
@SuppressLint("MissingPermission")
public class PairedDeviceUtils {

    public static boolean isPaired(String macAddress) {
        return getPairedDevice(macAddress) != null;
    }

    public static BluetoothDevice getPairedDevice(String macAddress) {
        if (TextUtils.isEmpty(macAddress)) return null;
        Set<BluetoothDevice> bluetoothDeviceSet = BluetoothAdapter.getDefaultAdapter().getBondedDevices();
        for (BluetoothDevice device : bluetoothDeviceSet) {
            if (macAddress.equals(device.getAddress())) {
                return device;
            }
        }

        return null;
    }

    public static BluetoothDevice getPairedDeviceByEndWithString(String suffix) {
        Set<BluetoothDevice> bluetoothDeviceSet = BluetoothAdapter.getDefaultAdapter().getBondedDevices();
        for (BluetoothDevice device : bluetoothDeviceSet) {
            if (device != null && !TextUtils.isEmpty(device.getAddress()) && device.getAddress().endsWith(suffix)) {
                return device;
            }
        }

        return null;
    }

    public static String getAllPairedDeviceInfo() {
        String pairedInfos = "phone has paired list:\n";
        Set<BluetoothDevice> bluetoothDeviceSet = BluetoothAdapter.getDefaultAdapter().getBondedDevices();
        for (BluetoothDevice device : bluetoothDeviceSet) {
            if (device != null) {
                String test = null;
                pairedInfos += device.getAddress() + "/" + device.getName() + "\n";
            }
        }
        return pairedInfos;
    }

    public static boolean removeBondState(String macAddress) {
        Logger.p("removeBondState");
        BluetoothDevice device = getPairedDevice(macAddress);
        if (device != null) {
            return removeBondState(device);
        }
        return true;
    }

    public static boolean removeBondState(BluetoothDevice device) {
        try {
            Logger.p("removeBondState: " + device);
            Method m = device.getClass().getMethod("removeBond",
                    (Class[]) null);
            m.invoke(device, (Object[]) null);

            return isPaired(device.getAddress());
        } catch (Exception e) {
            Logger.e("" + e.getMessage());
        }
        return false;
    }


    public static boolean isConnected(BluetoothDevice device) {
        BluetoothAdapter bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
        if (bluetoothAdapter == null) {
            return false;
        }
        //得到BluetoothDevice的Class对象
        Class<BluetoothDevice> bluetoothDeviceClass = BluetoothDevice.class;
        try {//得到连接状态的方法
            Method method = bluetoothDeviceClass.getDeclaredMethod("isConnected", (Class[]) null);
            //打开权限
            method.setAccessible(true);
            return (boolean) method.invoke(device, (Object[]) null);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 修改系统权限，不然就有些反射被系统限制了
     */
    public static void initSystemPermission() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.P) {
            return;
        }
        Logger.e("initSystemPermission......");
        try {
            Method forName = Class.class.getDeclaredMethod("forName", String.class);
            Method getDeclaredMethod = Class.class.getDeclaredMethod("getDeclaredMethod", String.class, Class[].class);
            Class<?> vmRuntimeClass = (Class<?>) forName.invoke(null, "dalvik.system.VMRuntime");
            Method getRuntime = (Method) getDeclaredMethod.invoke(vmRuntimeClass, "getRuntime", null);
            Method setHiddenApiExemptions = (Method) getDeclaredMethod.invoke(vmRuntimeClass, "setHiddenApiExemptions", new Class[]{String[].class});
            Object sVmRuntime = getRuntime.invoke(null);
            setHiddenApiExemptions.invoke(sVmRuntime, new Object[]{new String[]{"L"}});
        } catch (Throwable e) {
            Logger.e("initSystemPermission.....error.");
        }
    }

    /**
     * 创建绑定，系统的创建绑定不能带参数，默认模式是            TRANSPORT_AUTO 0, 但是bt 连接需要走经典模式，TRANSPORT_BREDR1
     *
     * @param device
     */
    public static void createBond(BluetoothDevice device) {
        try {
            initSystemPermission();
            Logger.e("createBond: " + device);
            Method m = device.getClass().getMethod("createBond",
                    Integer.TYPE);
            m.invoke(device, BluetoothDevice.TRANSPORT_BREDR);

        } catch (Exception e) {
            Logger.e(e.getMessage() + "");
        }
    }
}
