package com.idosmart.bluetooth.ble.device

import com.idosmart.bluetooth.ble.reconnect.AutoConnectBleDevice
import com.idosmart.bluetooth.dfu.BleDFUConfig
import com.idosmart.bluetooth.dfu.BleDFUState
import com.idosmart.bluetooth.dfu.IDfu
import com.idosmart.bluetooth.dfu.nodic.NodicDFUManager

/**
 * @author tianwei
 * @date 2022/12/27
 * @time 9:59
 * 用途: 抽象BLE设备，隔离多设备
 */
class IDOBleDevice(deviceAddress: String) : AutoConnectBleDevice(deviceAddress) {

}