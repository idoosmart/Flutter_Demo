package com.example.flutter_bluetooth.ble.device

import com.example.flutter_bluetooth.ble.reconnect.AutoConnectBleDevice
import com.example.flutter_bluetooth.dfu.BleDFUConfig
import com.example.flutter_bluetooth.dfu.BleDFUState
import com.example.flutter_bluetooth.dfu.IDfu
import com.example.flutter_bluetooth.dfu.nodic.NodicDFUManager

/**
 * @author tianwei
 * @date 2022/12/27
 * @time 9:59
 * 用途: 抽象BLE设备，隔离多设备
 */
class IDOBleDevice(deviceAddress: String) : AutoConnectBleDevice(deviceAddress) {

}