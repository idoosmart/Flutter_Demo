package com.example.flutter_bluetooth.ble.reconnect;

import android.annotation.SuppressLint;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothManager;
import android.bluetooth.BluetoothProfile;
import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;


import com.example.flutter_bluetooth.ble.callback.ScanCallBack;
import com.example.flutter_bluetooth.dfu.BLEDevice;
import com.example.flutter_bluetooth.dfu.parser.DFUServiceParser;
import com.example.flutter_bluetooth.dfu.parser.ScannerServiceParser;
import com.example.flutter_bluetooth.logger.Logger;
import com.example.flutter_bluetooth.utils.CommonUtils;
import com.example.flutter_bluetooth.utils.PairedDeviceUtils;
import com.example.flutter_bluetooth.utils.PhoneInfoUtil;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * Created by asus on 2017/9/27.
 * 扫描设备
 */
@SuppressLint("MissingPermission")
public class ScanManager extends NewLeScanner {
    private static final long DEFAULT_SCAN_TIME_OUT = 30000;
    private static ScanManager instance;

    private BluetoothManager mBluetoothManager;
    private boolean mIsScanning = false;

    // true表示按服务过滤，否则名称
    private boolean mIsFilterByService = false;
    private String mNameKeyWords = "";
    private Handler mTimeOutHandler;

    private Map<String, BLEDevice> mBLEDeviceMap = new HashMap<>();
    private ExecutorService singleThreadPool;

    private List<ScanCallBack> mScanCallbacks = new ArrayList<>();

    private Handler mMainHandler = new Handler(Looper.getMainLooper());

    public void unregisterScanCallBack(ScanCallBack callBack) {
        Iterator<ScanCallBack> it = mScanCallbacks.iterator();
        while (it.hasNext()) {
            ScanCallBack item = it.next();
            if (item.equals(callBack)) {
                it.remove();
            }
        }
    }


    public void registerScanCallBack(ScanCallBack callBack) {
        if (!mScanCallbacks.contains(callBack)) {
            mScanCallbacks.add(callBack);
        }
    }

    /**
     * 极端情况下，handler有可能被回收;
     * removeCallbacks时，不要调用该方法
     */
    private Handler getTimeOutHandler() {
        if (mTimeOutHandler == null) {
            mTimeOutHandler = new Handler(Looper.getMainLooper());
        }
        return mTimeOutHandler;
    }

    @Override
    public void callbackOnLeScan(final BluetoothDevice device, final int rssi, final byte[] scanRecord) {
        singleThreadPool.execute(new Runnable() {
            @Override
            public void run() {
                if (DFUServiceParser.decodeDFUAdvData(scanRecord)) {
                    handleDfuScene(device, rssi, scanRecord);
                } else {
                    handleNormalScene(device, rssi, scanRecord);
                }
            }
        });
    }


    private ScanManager() {
        super();
        init();
    }

    public static ScanManager getManager() {
        if (instance == null) {
            instance = new ScanManager();
        }
        return instance;
    }

    private void init() {
        mBluetoothManager = (BluetoothManager) CommonUtils.getAppContext().getSystemService(Context.BLUETOOTH_SERVICE);
        mTimeOutHandler = new Handler(Looper.getMainLooper());
    }

    public void startScanDevicesByService(long time) {
        startScanDevices(true, time);
    }

    public void startScanDevicesByName(long time, String name) {
        mNameKeyWords = name;
        startScanDevices(false, time);
    }

    private void startScanDevices(boolean isFilterByService, long time) {
        Logger.p("[ScanManager] startScanDevices()");
        Logger.p("[ScanManager] " + PairedDeviceUtils.getAllPairedDeviceInfo());
        String msg = PhoneInfoUtil.getPhoneBluetoothAndGPSInfo();
        if (!TextUtils.isEmpty(msg)) {
            Logger.e("[ScanManager] printPhoneEnvInfo, " + msg);
        }
        if (!BluetoothAdapter.getDefaultAdapter().isEnabled()) {
            Logger.e("[ScanManager] bluetooth switch is closed, can not scan device.");
            onScanFinished();
            return;
        }
        if (!PhoneInfoUtil.hasPhoneBluetoothPermission()) {
            Logger.e("[ScanManager] hasPhoneBluetoothPermission false.");
            Logger.e("[ScanManager] " + PhoneInfoUtil.getPhoneBluetoothAndGPSInfo());
            onScanFinished();
            return;
        }
        if (mIsScanning) {
            Logger.e("[ScanManager] at state of scanning, ignore this action");
            return;
        }
        singleThreadPool = Executors.newSingleThreadExecutor();

        mIsFilterByService = isFilterByService;
        if (time < 0) {
            time = DEFAULT_SCAN_TIME_OUT;
        }

        if (mTimeOutHandler != null) {
            mTimeOutHandler.removeCallbacks(timeOutRunnable);
        }
        getTimeOutHandler().postDelayed(timeOutRunnable, time);

        mIsScanning = true;
        mBLEDeviceMap.clear();
        startLeScan();
        onStart();

        getConnectedDevicesAndSendNotify();
    }

    private void onStart() {
        for (ScanCallBack mScanCallback : mScanCallbacks) {
            mScanCallback.onStart();
        }
    }

    private final Runnable timeOutRunnable = () -> {
        getBondWithPhoneList();
        scanTaskFinished();
    };

    /**
     * 单次扫描任务完成
     */
    private void scanTaskFinished() {

        Logger.p("[ScanManager] this task of scan is finished");
        if (mTimeOutHandler != null) {
            mTimeOutHandler.removeCallbacks(timeOutRunnable);
        }
        stopLeScan();
        mIsScanning = false;
        sendNotifyOfScanFinishedToListeners();


    }

    /**
     * 获取与手机配对的BLE设备
     */
    private void getBondWithPhoneList() {
        try {
            Logger.p("[ScanManager] to get bond with phone list.");
            Set<BluetoothDevice> bluetoothDeviceSet = BluetoothAdapter.getDefaultAdapter().getBondedDevices();
            for (BluetoothDevice device : bluetoothDeviceSet) {
                if (device != null && device.getType() == BluetoothDevice.DEVICE_TYPE_LE) {
                    BLEDevice bleDevice = new BLEDevice();
                    bleDevice.mDeviceAddress = device.getAddress();
                    bleDevice.mDeviceName = device.getName();
                    bleDevice.mDeviceId = -111;
                    bleDevice.mRssi = -1;
                    bleDevice.type = BLEDevice.TYPE_FROM_PHONE_PAIRED;
                    if (!mBLEDeviceMap.containsKey(bleDevice.mDeviceAddress)) {
                        mBLEDeviceMap.put(bleDevice.mDeviceAddress, bleDevice);
                        sendNotifyOfFindOneDeviceToListeners(bleDevice);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 发送扫描完成通知
     */
    private void sendNotifyOfScanFinishedToListeners() {
        onScanFinished();
    }

    private void onScanFinished() {
        for (ScanCallBack mScanCallback : mScanCallbacks) {
            mScanCallback.onScanFinished();
        }
    }

    /**
     * 发现一个设备
     */
    private void sendNotifyOfFindOneDeviceToListeners(BLEDevice device) {
        Logger.p("[ScanManager] find device:" + device.toString());
        mMainHandler.post(() -> onFindDevice(device));
    }

    private void onFindDevice(BLEDevice device) {
        for (ScanCallBack mScanCallback : mScanCallbacks) {
            mScanCallback.onFindDevice(device);
        }
    }

    /**
     * 获取当前手机已连上的手环设备（同一个手环，可以被同一个手机上的多个应用程序连接）
     */
    private void getConnectedDevicesAndSendNotify() {
        List<BluetoothDevice> deviceList = mBluetoothManager.getConnectedDevices(BluetoothProfile.GATT);
        Logger.p("[ScanManager] getConnectedDevicesAndSendNotify "+deviceList);
        if (deviceList == null || deviceList.size() == 0) {
            return;
        }

        String gattConnectedListInfo = "";
        for (BluetoothDevice device : deviceList) {
            gattConnectedListInfo += device.getAddress() + "/" + device.getName();

            if (!mBLEDeviceMap.containsKey(device.getAddress())) {
                BLEDevice newDeviceInfo = new BLEDevice();
                if (TextUtils.isEmpty(device.getName())) {
                    continue;
                }
                newDeviceInfo.mDeviceName = device.getName();
                newDeviceInfo.mDeviceAddress = device.getAddress();
                //下面这两个参数，无法从device中获取，所有就自定义两个参数
                newDeviceInfo.mRssi = -1;
                newDeviceInfo.mDeviceId = -111;
                mBLEDeviceMap.put(device.getAddress(), newDeviceInfo);
                sendNotifyOfFindOneDeviceToListeners(newDeviceInfo);
            }
        }
        Logger.p("[ScanManager] " + "gattConnectedList=" + gattConnectedListInfo);
    }


    public void stopScanDevices() {
        if (mIsScanning) {
            Logger.p("[ScanManager] stopScanDevices()");
            scanTaskFinished();
        } else {
            if (mTimeOutHandler != null) {
                mTimeOutHandler.removeCallbacks(timeOutRunnable);
            }
            stopLeScan();
            Logger.p("[ScanManager] stopScanDevices(), mIsScanning = false");
        }

    }

    private void handleNormalScene(BluetoothDevice device, int rssi, byte[] scanRecord) {
        String name = device.getName();
        byte[] temp = ScannerServiceParser.decodeManufacturer(scanRecord);


        int deviceId = 0;
        if (temp != null && temp.length > 2) {
            deviceId = (temp[0] & 0xFF) | ((temp[1] & 0xFF) << 8);
        }
        int bootload_version = 0;
        if (temp != null && temp.length > 3) {
            bootload_version = temp[3] & 0xFF;
        }
        if (TextUtils.isEmpty(name)) {
            // 避免部分手机拿到的为null, 再拿一遍
            name = ScannerServiceParser.decodeDeviceName(scanRecord);
            if (TextUtils.isEmpty(name)) {
                return;
            }
        }

        if (mIsFilterByService) {
            boolean isFilterDevice = ScannerServiceParser.isInNormalMode(scanRecord);
            if (!isFilterDevice) {
                return;
            }
        } else {
            if (!checkKeyWord(name)) {
                return;
            }
        }

        String address = device.getAddress();

        if (mBLEDeviceMap.containsKey(address)) {
            return;
        }
        BLEDevice d = new BLEDevice();
        d.mDeviceName = name;
        d.mDeviceAddress = address;
        d.mRssi = rssi;
        d.mDeviceId = deviceId;
        d.bootload_version = bootload_version;

        if (temp != null) {
            //GT01加的协议
            //DEVICE_ID(2BYTE)+ MAC地址（6BYTE）+ VERSION(协议版本：1开始)(1BYTE)  + 手表手环（标志 1是手表，2是手环，0表示无效/不存在）（1BYTE） + （固件版本 bootloader版本 外部flash_bin）(1BYTE)
            if (temp.length >= 10) {
                d.type = temp[9] & 0xff;
            }

            d.otaFactoryDeviceInfo = new BLEDevice.OTAFactoryDeviceInfo();
            if (temp.length >= 14) {
                d.otaFactoryDeviceInfo.version = temp[10] & 0xff;
                d.otaFactoryDeviceInfo.bootload_version = temp[11] & 0xff;
                d.otaFactoryDeviceInfo.special_version = temp[12] & 0xff;
                d.otaFactoryDeviceInfo.flash_bin_version = temp[13] & 0xff;
            }


            //工厂OTA升级参数
            if (temp.length > 17) {
                d.otaFactoryDeviceInfo.version = (temp[8]) | (temp[9] << 8);
                d.otaFactoryDeviceInfo.bootload_version = (temp[10]) | (temp[11] << 8);
                d.otaFactoryDeviceInfo.special_version = (temp[12]) | (temp[13] << 8);
                d.otaFactoryDeviceInfo.flash_bin_version = (temp[14]) | (temp[15] << 8);
                d.otaFactoryDeviceInfo.internal_version = ((int) (temp[16]) & 0xFF) | ((int) ((int) temp[17] << 8));

            }
        }

        mBLEDeviceMap.put(address, d);
        sendNotifyOfFindOneDeviceToListeners(d);
    }

    private void handleDfuScene(BluetoothDevice device, int rssi, byte[] scanRecord) {
        byte[] temp = ScannerServiceParser.decodeManufacturer(scanRecord);
        if (temp == null || temp.length < 2) {
            return;
        }

        BLEDevice d = new BLEDevice();

        String name = device.getName();
        if (TextUtils.isEmpty(name)) {
            name = ScannerServiceParser.decodeDeviceName(scanRecord);
            if (TextUtils.isEmpty(name)) {
                return;
            }
        }

        if (mIsFilterByService) {
            boolean isFilterDevice = ScannerServiceParser.isInDFUMode(scanRecord);
            if (!isFilterDevice) {
                return;
            }
        } else {
            if (!checkKeyWord(name)) {
                return;
            }
        }

        String address = device.getAddress();
        if (!mBLEDeviceMap.containsKey(address)) {
            d.mDeviceName = name;
            d.mDeviceAddress = address;
            d.mRssi = rssi;
            d.mDeviceId = (temp[0] & 0xFF) | ((temp[1] & 0xFF) << 8);
            d.mIsInDfuMode = true;
            mBLEDeviceMap.put(address, d);
            sendNotifyOfFindOneDeviceToListeners(d);
        }
    }

    private boolean checkKeyWord(String deviceName) {
        if (TextUtils.isEmpty(deviceName)) {
            return false;
        }
        //如果为空，则返回所有
        if (TextUtils.isEmpty(mNameKeyWords)) {
            return true;
        }
        //包含关键字
        if (deviceName.toLowerCase().contains(mNameKeyWords.toLowerCase())) {
            return true;
        }

        return false;
    }
}
