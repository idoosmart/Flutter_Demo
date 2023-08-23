package com.example.flutter_bluetooth.dfu.nodic.task;

import android.annotation.SuppressLint;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothManager;
import android.bluetooth.BluetoothProfile;
import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;

import com.example.flutter_bluetooth.dfu.BLEDevice;
import com.example.flutter_bluetooth.dfu.BleDFUConstants;
import com.example.flutter_bluetooth.dfu.parser.DFUServiceParser;
import com.example.flutter_bluetooth.dfu.parser.ScannerServiceParser;
import com.example.flutter_bluetooth.logger.Logger;
import com.example.flutter_bluetooth.utils.CommonUtils;
import com.example.flutter_bluetooth.utils.MacAdd1Utils;

import java.util.List;

/**
 * Created by Zhouzj on 2017/12/22.
 * 扫描目标设备,并且该设备处于dfu模式
 */
@SuppressLint("MissingPermission")
public class ScanTargetDFUDeviceTask {

    private static final long DEFAULT_SCAN_TIME_OUT = 30000;
    private static boolean mIsDoing = false;

    private BluetoothAdapter mBluetoothAdapter;
    private Handler mHandler;
    private IResult mIResult;
    private String mTargetDeviceMacAddress;
    private boolean mIsFindTargetDevice = false;
    private int mRetryTimes = 0;
    private static final int DEFAULT_MAX_RETRY_TIMES = 3;
    private int mMaxRetryTimes = 0;
    private String addOneMac;//加一的地址
    private String addOneMac2;//加一的地址
    private BluetoothAdapter.LeScanCallback mLeScanCallback = new BluetoothAdapter.LeScanCallback() {
        @Override
        public void onLeScan(BluetoothDevice device, int rssi, byte[] scanRecord) {
            if (mTargetDeviceMacAddress.equals(device.getAddress()) || addOneMac.equals(device.getAddress()) || addOneMac2.equals(device.getAddress())) {
                Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[ScanTargetDFUDeviceTask] -------onLeScan :" + device.getAddress());
                if (DFUServiceParser.decodeDFUAdvData(scanRecord)) {
                    mIsFindTargetDevice = true;
                    Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[ScanTargetDFUDeviceTask] has find target device, is in dfu mode:" + device.getAddress());
                    finished();
                    BLEDevice bleDevice = new BLEDevice();
                    bleDevice.mDeviceAddress = device.getAddress();
                    mIResult.onFindAndInDfuMode(bleDevice);
                } else {
                    BLEDevice bleDevice = getNormalModeBLEDevice(device, rssi, scanRecord);
                    if (bleDevice != null) {
                        mIsFindTargetDevice = true;
                        Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[ScanTargetDFUDeviceTask] has find target device, is not in dfu mode");
                        finished();
                        mIResult.onFindButNotInDfuMode(bleDevice);
                    } else {
                        Logger.e(BleDFUConstants.LOG_TAG_NODIC, "[ScanTargetDFUDeviceTask] has find target device, but device para is null");
                    }

                }
            }
//            Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[ScanTargetDFUDeviceTask] -------onLeScan :"+device.getAddress());
//            if (!mTargetDeviceMacAddress.equals(device.getAddress()) || !DFUManager.getAdd1MacAddress(mTargetDeviceMacAddress).equals(device.getAddress())){
//                return;
//            }

        }
    };

    private BLEDevice getNormalModeBLEDevice(BluetoothDevice device, int rssi, byte[] scanRecord) {
        byte[] temp = ScannerServiceParser.decodeManufacturer(scanRecord);
        BLEDevice d = new BLEDevice();

        if (temp != null && temp.length > 2) {
            d.mDeviceId = (temp[0] & 0xFF) | ((temp[1] & 0xFF) << 8);
//            d.mLen = 0;
//        d.mId = 0;
//        d.mIs = 0;
//        if (temp.length == 13) {
//            int id = (temp[10] & 0xff);
//            int is = (temp[11] & 0xff);
//            if (id == 10 && is == 240) {
//                d.mId = id;
//                d.mIs = is;
//                d.mLen = temp.length;
//            }
//        }
        }


//

        String name = device.getName();
        if (TextUtils.isEmpty(name)) {
            name = ScannerServiceParser.decodeDeviceName(scanRecord);
            if (TextUtils.isEmpty(name)) {
                return null;
            }
        }

        String address = device.getAddress();
        d.mDeviceName = name;
        d.mDeviceAddress = address;
        d.mRssi = rssi;

        boolean isFilterDevice = ScannerServiceParser.isInNormalMode(scanRecord);
        if (!isFilterDevice) {
            Logger.e(BleDFUConstants.LOG_TAG_NODIC, "[ScanTargetDFUDeviceTask] has find target device, but broadcast data is invalid");
        }
        return d;
    }

    public void start(IResult iResult, String macAddress) {
        start(iResult, macAddress, DEFAULT_MAX_RETRY_TIMES);
    }

    public void start(IResult iResult, String macAddress, int maxRetryTimes) {
        mMaxRetryTimes = maxRetryTimes;

        Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[ScanTargetDFUDeviceTask] start");
        if (mIsDoing) {
            Logger.e(BleDFUConstants.LOG_TAG_NODIC, "[ScanTargetDFUDeviceTask] at state of scanning, ignore this action");
            return;
        }

        mIResult = iResult;
        mTargetDeviceMacAddress = macAddress;
        addOneMac = MacAdd1Utils.getAdd1MacAddress(mTargetDeviceMacAddress);
        addOneMac2 = MacAdd1Utils.getAdd2MacAddress(mTargetDeviceMacAddress);
        if (!checkParas()) {
            mIsDoing = false;
            return;
        }
        init();

        if (isOnConnectedState()) {
            return;
        }

        startScanDevices();

        mIsDoing = true;
    }

    private void restart() {
        if (!BluetoothAdapter.getDefaultAdapter().isEnabled()) {
            finished();
            mIResult.onNotFind();
            Logger.e(BleDFUConstants.LOG_TAG_NODIC, "[ScanTargetDFUDeviceTask] bluetooth switch is closed, task finished!");
            return;
        }

        mRetryTimes++;

        Logger.e(BleDFUConstants.LOG_TAG_NODIC, "[ScanTargetDFUDeviceTask] restart times is " + mRetryTimes);
        if (mRetryTimes >= mMaxRetryTimes) {
            finished();
            Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[ScanTargetDFUDeviceTask] out of max retry times, task finished!");
            mIResult.onNotFind();
            return;
        }


        startScanDevices();
    }

    private boolean checkParas() {

        return true;
    }

    private void init() {
        mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
        mHandler = new Handler(Looper.getMainLooper());
    }


    private void startScanDevices() {
        Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[ScanTargetDFUDeviceTask] startScanDevices()");

        long time = DEFAULT_SCAN_TIME_OUT;

        if (android.os.Build.MANUFACTURER.equalsIgnoreCase("xiaomi")
                || android.os.Build.MANUFACTURER.equalsIgnoreCase("meizu")) {
            time = time > 15000L ? time : 15000L;
        }

        mHandler.removeCallbacks(scanTimeOutRunnable);
        mHandler.postDelayed(scanTimeOutRunnable, time);
        mBluetoothAdapter.startLeScan(mLeScanCallback);
    }

    private Runnable scanTimeOutRunnable = new Runnable() {
        @Override
        public void run() {
            oneScanWorkFinished();
        }
    };

    /**
     * 单次扫描任务完成
     */
    private void oneScanWorkFinished() {
        Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[ScanTargetDFUDeviceTask] a scan work finished.");
        mHandler.removeCallbacks(scanTimeOutRunnable);
        mBluetoothAdapter.stopLeScan(mLeScanCallback);

        if (!mIsFindTargetDevice) {

            Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[ScanTargetDFUDeviceTask] not find target device,  wait for restart....");
            mHandler.postDelayed(new Runnable() {
                @Override
                public void run() {
                    restart();
                }
            }, 3000);

        }
    }


    public void stop() {
        if (!mIsDoing) {
            return;
        }
        Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[ScanTargetDFUDeviceTask] stop task");
        release();
    }

    private void finished() {
        Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[ScanTargetDFUDeviceTask] task finished.");
        release();
    }

    private void release() {
        mHandler.removeCallbacksAndMessages(null);
        mBluetoothAdapter.stopLeScan(mLeScanCallback);
        mIsDoing = false;
        mRetryTimes = 0;
    }

    /**
     * 判断手环是否已被手机连接（同一个手环，可以被同一个手机上的多个应用程序连接）
     */
    private boolean isOnConnectedState() {
        BluetoothManager bluetoothManager = (BluetoothManager) CommonUtils.getAppContext().getSystemService(Context.BLUETOOTH_SERVICE);
        List<BluetoothDevice> deviceList = bluetoothManager
                .getConnectedDevices(BluetoothProfile.GATT);
        if (deviceList == null || deviceList.size() == 0) {
            return false;
        }

        for (BluetoothDevice device : deviceList) {

            if (mTargetDeviceMacAddress.equals(device.getAddress())) {
//                BLEDevice bleDevice = SPDataUtils.getInstance().getLastConnectedDeviceInfo();
//                if (bleDevice != null && mTargetDeviceMacAddress.equals(bleDevice.mDeviceAddress)) {
//                    Logger.e(BleDFUConstants.LOG_TAG_NODIC, "[ScanTargetDFUDeviceTask] target device is connected by other app");
                BLEDevice bleDevice = new BLEDevice();
                bleDevice.mDeviceAddress = mTargetDeviceMacAddress;
                mIResult.onFindButHasConnectedToPhone(bleDevice);
                return true;
//                }
            }
        }

        return false;
    }

    public interface IResult {
        void onNotFind();

        void onFindAndInDfuMode(BLEDevice bleDevice);

        void onFindButHasConnectedToPhone(BLEDevice bleDevice);

        void onFindButNotInDfuMode(BLEDevice bleDevice);
    }

}
