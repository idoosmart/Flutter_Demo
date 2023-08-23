package com.example.flutter_bluetooth.ble.reconnect;

import android.bluetooth.BluetoothAdapter;
import android.content.Context;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.os.PowerManager;

import androidx.annotation.NonNull;

import com.example.flutter_bluetooth.Config;
import com.example.flutter_bluetooth.ble.DeviceManager;
import com.example.flutter_bluetooth.ble.callback.ScanCallBack;
import com.example.flutter_bluetooth.dfu.BLEDevice;
import com.example.flutter_bluetooth.logger.Logger;
import com.example.flutter_bluetooth.utils.MacAdd1Utils;

/**
 * Created by zhouzj on 2017/10/10.
 * <p>
 * 扫描到已经绑定的设备，然后去自动连接；如果未扫描到，则一直扫描
 */

public class ScanTargetDeviceTask {

    private static final int SCAN_TIME_OUT = 30000;
    private static final int WHAT_DELAY = 1000;

    private static ScanTargetDeviceTask mTask;
    private boolean mIsFindDevice = false;
    private boolean mIsStopTask = false;
    private String mMacAddress = "";
    private String mMacAddressAdd1 = "";
    private String mMacAddressAdd2 = "";
    private int mRetryTimes = 0;
    private IStateChangeListener mIStateListener;
    private final Handler mHandler = new Handler(Looper.getMainLooper()) {
        @Override
        public void handleMessage(@NonNull Message msg) {
            if (msg.what == WHAT_DELAY) {
                toScanDevice();
            }
        }
    };

    private boolean check() {

        if (mIsStopTask) {
            Logger.e("[ScanTargetDeviceTask] check not allowed, mIsStopTask = true.");
            stopTask();
            return false;
        } else if (!BluetoothAdapter.getDefaultAdapter().isEnabled()) {
            Logger.e("[ScanTargetDeviceTask] check not allowed, phone bluetooth switch is closed.");
            mIStateListener.onStopByPhoneBluetoothSwitchClosed();
            stopTask();
            return false;
        } else if (DeviceManager.isConnected(mMacAddress)) {
            Logger.e("[ScanTargetDeviceTask] check not allowed, isConnected = true.");
            mIStateListener.onInConnectState();
            stopTask();
            return false;
        }

        return true;
    }

    private ScanCallBack mICallBack = new ScanCallBack() {
        @Override
        public void onStart() {

        }

        @Override
        public void onFindDevice(BLEDevice device) {

            if (!check()) {
                return;
            }

            if (mMacAddress.equals(device.mDeviceAddress)) {
                Logger.p("[ScanTargetDeviceTask] has find target device, start to connect");
                mIsFindDevice = true;
                ScanManager.getManager().stopScanDevices();
                mIStateListener.onFind(device);
            } else if (MacAdd1Utils.isMacAddressAdd1(mMacAddressAdd1, mMacAddressAdd2, device)) {
                Logger.p("[ScanTargetDeviceTask] has find target device(mac + 1)");
                mIsFindDevice = true;
                ScanManager.getManager().stopScanDevices();
                mIStateListener.onFind(device);
            }


        }

        @Override
        public void onScanFinished() {

            if (!check()) {
                return;
            }

            if (mIsFindDevice) {
                stopTask();
                return;
            }

            mRetryTimes++;
            int delayTime;
            if (mRetryTimes < 5) {
                delayTime = 1000 * 10;
            } else if (mRetryTimes < 30) {
                delayTime = 1000 * 15;
            } else {
                delayTime = 1000 * 45;
            }
            Logger.p("[ScanTargetDeviceTask] not find target device");
            mIStateListener.onNotFind();

            if (!isNeedScan() && mIStateListener.tryConnectDirect(mMacAddress)) {
                stopTask();
                return;
            }
            Logger.p("[ScanTargetDeviceTask] will retry after " + delayTime + "ms, retry times = " + mRetryTimes);
            if (mHandler.hasMessages(WHAT_DELAY)) {
                mHandler.removeMessages(WHAT_DELAY);
            }
            mHandler.sendEmptyMessageDelayed(WHAT_DELAY,delayTime);
        }
    };

    private class ScanRunnable implements Runnable {

        @Override
        public void run() {
            toScanDevice();
        }
    }

    public static void start(String macAddress, IStateChangeListener iStateListener) {
        stop();

        mTask = new ScanTargetDeviceTask(macAddress, iStateListener);
        mTask.startTask();
    }

    public static void stop() {
        if (mTask != null) {
            mTask.stopTask();
        }

    }

    public static boolean cancelDelay() {
        if (mTask != null) {
            mTask.cancelDelayTimer();
            return true;
        }
        return false;
    }

    private void toScanDevice() {
        if (check()) {
            Logger.p("[ScanTargetDeviceTask] start again ...");
            ScanManager.getManager().startScanDevicesByService(SCAN_TIME_OUT);
        }
    }

    private void cancelDelayTimer() {
        Logger.p("[ScanTargetDeviceTask] cancelDelayTimer. ");
        mHandler.removeMessages(WHAT_DELAY);
        toScanDevice();
    }

    private ScanTargetDeviceTask(String macAddress, IStateChangeListener iStateListener) {
        mMacAddress = macAddress;
        mMacAddressAdd1 = MacAdd1Utils.getAdd1MacAddress(macAddress);
        mMacAddressAdd2 = MacAdd1Utils.getAdd2MacAddress(macAddress);
        mIStateListener = iStateListener;
    }

    private void startTask() {
        Logger.p("[ScanTargetDeviceTask] startTask()");
        ScanManager.getManager().stopScanDevices();

        if (!isNeedScan()) {
            Logger.p("[ScanTargetDeviceTask] startTask():isNeedScan = false");

            if (mIStateListener.tryConnectDirect(mMacAddress)) {
                stopTask();
                return;
            }

            Logger.p("[ScanTargetDeviceTask] startTask(): try connect direct failed, will start scan task.");
        }


        ScanManager.getManager().unregisterScanCallBack(mICallBack);
        ScanManager.getManager().registerScanCallBack(mICallBack);
        ScanManager.getManager().startScanDevicesByService(SCAN_TIME_OUT);
    }

    private void stopTask() {
        if (mIsStopTask) {
            return;
        }

        Logger.p("[ScanTargetDeviceTask] stopTask()");
        mIsStopTask = true;
        mHandler.removeMessages(WHAT_DELAY);

        ScanManager.getManager().stopScanDevices();
        ScanManager.getManager().unregisterScanCallBack(mICallBack);

        mRetryTimes = 0;
        mTask = null;
    }

    public interface IStateChangeListener {
        void onFind(BLEDevice bleDevice);

        void onNotFind();

        boolean tryConnectDirect(String macAddress);

        void onStopByPhoneBluetoothSwitchClosed();

        void onInConnectState();
    }

    /**
     * 熄屏状态下，不扫描，直接连接；
     * 有的手机（三星，android10）在息屏状态下扫描，app会系统冻结
     */
    private boolean isNeedScan() {
        //扫描一次，然后就直连一次，交替进行
        if (mRetryTimes != 0 && mRetryTimes % 2 == 0) {
            Logger.p("[ScanTargetDeviceTask] isNeedScan1 = false");
            return false;
        }


//        //前面20次，即使息屏了，也去扫描
//        //大于20次后，如果是息屏了，则不去扫描了，因为持续扫描会很耗电
//        if (mRetryTimes <= 20){
//            Logger.p("[ScanTargetDeviceTask] true，<=20");
//            return true;
//        }

        PowerManager powerManager = (PowerManager) Config.getApplication().getSystemService(Context.POWER_SERVICE);
        if (powerManager == null) {
            Logger.p("[ScanTargetDeviceTask] isNeedScan2 = true");
            return true;
        }

        boolean isScreenOn;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT_WATCH) {
            isScreenOn = powerManager.isInteractive();
        } else {
            isScreenOn = powerManager.isScreenOn();
        }
        Logger.p("[ScanTargetDeviceTask] isNeedScan3 = " + isScreenOn);
        return isScreenOn;
    }


}
