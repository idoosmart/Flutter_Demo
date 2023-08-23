package com.example.flutter_bluetooth.ble.scan

/**
 * 扫描手环设备监听回调
 * <br></br>
 * The callback for scan device.
 */
interface ScanLeCallBack {

    /**
     * 扫描开始
     * >
     * Scan start.
     */
    fun onScanLeStart()

    /**
     * 扫到一个手环设备
     * <br></br>
     * Find a device.
     */
    fun onScanLeResult(scanResult: Map<String, Any?>)

    /**
     * 扫描结束
     * <br></br>
     * Scan finished.
     */
    fun onScanLeFinished()
}