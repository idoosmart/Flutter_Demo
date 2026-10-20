package com.idosmart.native_channel.actions.ibluz.device.scan.ble;

import android.content.Context;
import android.os.Build;

import com.idosmart.native_channel.actions.ibluz.device.scan.BaseScanner;
import com.idosmart.native_channel.actions.ibluz.device.scan.SimpleScanCallback;


public class BleScanner {
    private final static String TAG = BleScanner.class.getName();
    public BaseScanner bleScanner;

    public BleScanner(Context context, final SimpleScanCallback callback) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            bleScanner = new LollipopBleScanner(callback);
        } else {
            bleScanner = new JellyBeanBleScanner(context, callback);
        }
    }

    public boolean isScanning() {
        return bleScanner.isScanning;
    }

    public void startBleScan() {
        bleScanner.onStartScan();
    }

    public void stopBleScan() {
        if (bleScanner != null) {
            bleScanner.onStopScan();
            bleScanner.clean();
            bleScanner = null;
        }
    }
}
