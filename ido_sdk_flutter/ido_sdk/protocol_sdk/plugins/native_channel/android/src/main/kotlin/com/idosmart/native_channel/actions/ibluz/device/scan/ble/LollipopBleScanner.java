package com.idosmart.native_channel.actions.ibluz.device.scan.ble;

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.le.BluetoothLeScanner;
import android.bluetooth.le.ScanCallback;
import android.bluetooth.le.ScanResult;
import android.util.Log;


import com.idosmart.native_channel.actions.ibluz.device.scan.BaseScanner;
import com.idosmart.native_channel.actions.ibluz.device.scan.ScanState;
import com.idosmart.native_channel.actions.ibluz.device.scan.SimpleScanCallback;

import java.util.List;

public class LollipopBleScanner extends BaseScanner {
    private String TAG = "LollipopBleScanner";

    private BluetoothLeScanner mBluetoothScanner = null;
    private BluetoothAdapter mBluetoothAdapter = null;
    private SimpleScanCallback mScanCallback = null;
    private ScanCallback scanCallback = new ScanCallback() {
        @Override
        public void onScanResult(int callbackType, ScanResult result) {
            super.onScanResult(callbackType, result);
            if (result.getScanRecord() != null && mScanCallback != null) {
                mScanCallback.onScan(result.getDevice(), result.getRssi(), result.getScanRecord().getBytes());
            }
        }

        @Override
        public void onBatchScanResults(List<ScanResult> results) {
            super.onBatchScanResults(results);
            Log.i(TAG, "onBatchScanResults()");
        }

        @Override
        public void onScanFailed(int errorCode) {
            //error code 3 or 1 todo
            if (errorCode != 3 && errorCode != 1) {
                Log.i(TAG, "onScanFailed: " + errorCode);
                mScanCallback.onScanFailed(ScanState.newInstance(errorCode));
            }
        }
    };

    public LollipopBleScanner(SimpleScanCallback callback) {
        mScanCallback = callback;
        mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
        if (mBluetoothAdapter != null) {
            mBluetoothScanner = mBluetoothAdapter.getBluetoothLeScanner();
        }
    }

    public void clean() {
        mScanCallback = null;
    }

    @SuppressWarnings(value = {"deprecation"})
    @Override
    public void onStartScan() {
        if (mBluetoothScanner != null && mBluetoothAdapter != null && mBluetoothAdapter.isEnabled()) {
            try {
                mBluetoothScanner.startScan(scanCallback);
                isScanning = true;
            } catch (SecurityException e){
                isScanning = false;
                mScanCallback.onScanFailed(ScanState.BLUETOOTH_OFF);
                Log.e(TAG, e.toString());
            } catch (Exception e) {
                isScanning = false;
                mScanCallback.onScanFailed(ScanState.BLUETOOTH_OFF);
                Log.e(TAG, e.toString());
            }
        } else {
            mScanCallback.onScanFailed(ScanState.BLUETOOTH_OFF);
        }
        Log.i(TAG, "mBluetoothScanner.startScan()");
    }

    @SuppressWarnings(value = {"deprecation"})
    @Override
    public void onStopScan() {
        isScanning = false;
        if (mBluetoothScanner != null && mBluetoothAdapter != null && mBluetoothAdapter.isEnabled()) {
            try {
                mBluetoothScanner.stopScan(scanCallback);
            } catch (SecurityException e){
                Log.e(TAG, e.toString());
            } catch (Exception e) {
                Log.e(TAG, e.toString());
            }
        }
    }

    @Override
    public void onScanFailed(ScanState scanState) {
        mScanCallback.onScanFailed(scanState);
    }
}
