package com.example.flutter_bluetooth.ble.callback

import com.example.flutter_bluetooth.ble.scan.ScanLeCallBack

abstract class BaseLeScanner {
    abstract fun startLeScan(data: Map<String, Any?>?, scanLeCallback: ScanLeCallBack?)
    abstract fun stopLeScan()
    abstract fun callbackOnLeScan(scanResult: Map<String, Any?>)
}