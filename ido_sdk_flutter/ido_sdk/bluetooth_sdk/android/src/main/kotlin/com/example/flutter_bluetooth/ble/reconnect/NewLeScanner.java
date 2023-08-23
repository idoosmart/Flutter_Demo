package com.example.flutter_bluetooth.ble.reconnect;


import static android.bluetooth.le.ScanSettings.SCAN_MODE_LOW_LATENCY;

import android.annotation.SuppressLint;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.le.BluetoothLeScanner;
import android.bluetooth.le.ScanCallback;
import android.bluetooth.le.ScanFilter;
import android.bluetooth.le.ScanRecord;
import android.bluetooth.le.ScanResult;
import android.bluetooth.le.ScanSettings;

import com.example.flutter_bluetooth.logger.Logger;

import java.util.ArrayList;
import java.util.List;

@SuppressLint("MissingPermission")
public abstract class NewLeScanner extends BaseLeScanner {

    private ScanCallback scanCallback = new ScanCallback() {
        @Override
        public void onScanResult(int callbackType, ScanResult result) {
            if (callbackType != ScanSettings.CALLBACK_TYPE_ALL_MATCHES) {
                // Should not happen.
                Logger.e("[NewScanner]LE Scan has already started");
                return;
            }
            ScanRecord scanRecord = result.getScanRecord();
            if (scanRecord == null) {
                return;
            }
            callbackOnLeScan(result.getDevice(), result.getRssi(), scanRecord.getBytes());
        }
    };

    @Override
    public void startLeScan() {
        BluetoothLeScanner scanner = BluetoothAdapter.getDefaultAdapter().getBluetoothLeScanner();
        if (scanner == null) {
            Logger.e("[NewScanner]startLeScan: cannot get BluetoothLeScanner");
            return;
        }

        if (!BluetoothAdapter.getDefaultAdapter().isEnabled()) {
            Logger.e("[NewScanner]startLeScan: bluetooth switch closed");
            return;
        }

        ScanSettings settings = new ScanSettings.Builder().setCallbackType(ScanSettings.CALLBACK_TYPE_ALL_MATCHES).setScanMode(SCAN_MODE_LOW_LATENCY).build();

        List<ScanFilter> filters = new ArrayList<>();
//        ScanFilter filter =
//                new ScanFilter.Builder().setServiceUuid(new ParcelUuid(UUIDConfig.RX_SERVICE_UUID))
//                        .build();
//        filters.add(filter);
        Logger.e("[NewScanner]  NORMAL scan");
        scanner.startScan(filters, settings, scanCallback);


    }

    public ScanSettings createScanSetting() {
        ScanSettings.Builder builder = new ScanSettings.Builder()
                //设置高功耗模式
                .setScanMode(SCAN_MODE_LOW_LATENCY);
        //android 6.0添加设置回调类型、匹配模式等
        if (android.os.Build.VERSION.SDK_INT >= 23) {
            //定义回调类型
            builder.setCallbackType(ScanSettings.CALLBACK_TYPE_ALL_MATCHES);
            //设置蓝牙LE扫描滤波器硬件匹配的匹配模式
            builder.setMatchMode(ScanSettings.MATCH_MODE_AGGRESSIVE);
        }
        //芯片组支持批处理芯片上的扫描
        if (BluetoothAdapter.getDefaultAdapter().isOffloadedScanBatchingSupported()) {
            //设置蓝牙LE扫描的报告延迟的时间（以毫秒为单位）
            //设置为0以立即通知结果
            builder.setReportDelay(0L);
        }
        return builder.build();
    }

    @Override
    public void stopLeScan() {
        BluetoothLeScanner scanner = BluetoothAdapter.getDefaultAdapter().getBluetoothLeScanner();
        if (scanner == null) {
            Logger.e("[NewScanner]stopLeScan: cannot get BluetoothLeScanner");
            return;
        }

        if (!BluetoothAdapter.getDefaultAdapter().isEnabled()) {
            Logger.e("[NewScanner]stopLeScan: bluetooth switch closed");
            return;
        }
        scanner.stopScan(scanCallback);
    }

}
