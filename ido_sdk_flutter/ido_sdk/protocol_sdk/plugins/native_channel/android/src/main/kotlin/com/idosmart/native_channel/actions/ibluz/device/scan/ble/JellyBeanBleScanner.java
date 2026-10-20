package com.idosmart.native_channel.actions.ibluz.device.scan.ble;

import android.annotation.SuppressLint;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothManager;
import android.content.Context;
import android.util.Log;

import com.idosmart.native_channel.actions.ibluz.device.scan.BaseScanner;
import com.idosmart.native_channel.actions.ibluz.device.scan.ScanState;
import com.idosmart.native_channel.actions.ibluz.device.scan.SimpleScanCallback;


public class JellyBeanBleScanner extends BaseScanner {
    private String TAG = "JellyBeanBleScanner";

    public BluetoothAdapter mBluetooth = null;
    private SimpleScanCallback mScanCallback = null;
    private BluetoothAdapter.LeScanCallback leScanCallback = new BluetoothAdapter.LeScanCallback() {
        @Override
        public void onLeScan(BluetoothDevice device, int rssi, byte[] scanRecord) {
            mScanCallback.onScan(device, rssi, scanRecord);
        }
    };

    public JellyBeanBleScanner(Context context, SimpleScanCallback callback) {
        mScanCallback = callback;
        BluetoothManager bluetoothMgr = (BluetoothManager) context.getSystemService(Context.BLUETOOTH_SERVICE);
        mBluetooth = bluetoothMgr.getAdapter();
    }

    public void clean() {
        mScanCallback = null;
    }

    @SuppressWarnings(value = {"deprecation"})
    @Override
    public void onStartScan() {
        if (mBluetooth != null) {
            try {
                isScanning = mBluetooth.startLeScan(leScanCallback);
                Log.i(TAG, "mBluetooth.startLeScan() " + isScanning);
            }catch (SecurityException e){
                e.printStackTrace();
            }
        } else {
            mScanCallback.onScanFailed(ScanState.BLUETOOTH_OFF);//bluetooth is off
        }
    }

    @SuppressLint("MissingPermission")
    @SuppressWarnings(value = {"deprecation"})
    @Override
    public void onStopScan() {
        isScanning = false;
        try {
            if (mBluetooth != null) {
                mBluetooth.stopLeScan(leScanCallback);
            }
        }catch (SecurityException e){
            e.printStackTrace();
        }
    }

    @Override
    public void onScanFailed(ScanState scanState) {
        mScanCallback.onScanFailed(scanState);//扫描设备失败~
    }
}
