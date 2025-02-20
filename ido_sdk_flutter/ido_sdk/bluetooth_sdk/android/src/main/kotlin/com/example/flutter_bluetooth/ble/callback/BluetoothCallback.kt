package com.example.flutter_bluetooth.ble.callback

import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCharacteristic

/**
 * @author tianwei
 * @date 2022/12/27
 * @time 10:51
 * 用途:
 */
interface BluetoothCallback {

    fun callOnConnectStart()

    fun callOnConnecting()

    fun callOnConnectTimeOut()

    fun callOnConnectBreakByGATT(status: Int, newState: Int,platform: Int)

    fun callOnConnectFailedByGATT(status: Int, newState: Int,platform: Int)

    fun callOnConnectFailedByErrorMacAddress()

    fun callOnConnectFailedByBluetoothSwitchClosed()

    fun callOnConnectFailedByEncryptedFailed()

    fun callOnDiscoverServiceFailed()

    fun callOnInDfuMode()

    /**
     * @param platform 手表平台
     */
    fun callOnConnectedAndReady(platform:Int)

    fun callOnEnableNormalNotifyFailed()

    fun callOnEnableHealthNotifyFailed()

    fun callOnGattErrorAndNeedRebootBluetooth()

    fun callOnConnectClosed()

    fun callOnCharacteristicWrite(gatt: BluetoothGatt?, characteristic: BluetoothGattCharacteristic?, status: Int)

    fun callOnCharacteristicChanged(gatt: BluetoothGatt?, characteristic: BluetoothGattCharacteristic?)

    fun callOnServices(services:List<String>)
}