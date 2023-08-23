package com.example.flutter_bluetooth.ble.callback;

import com.example.flutter_bluetooth.dfu.BLEDevice;

/**
 * 扫描手环设备监听回调
 * <br/>
 * The callback for scan device.
 */
public interface ScanCallBack {


    /**
     * 扫描开始
     * </>
     * Scan start.
     */
    void onStart();

    /**
     * 扫到一个手环设备
     * <br/>
     * Find a device.
     */
    void onFindDevice(BLEDevice device);

    /**
     * 扫描结束
     * <br/>
     * Scan finished.
     */
    void onScanFinished();

}