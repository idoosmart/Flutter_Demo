package com.idosmart.protocol_sdk

import com.idosmart.model.*

interface IDOBleDelegate {
    /**
     * 搜索设备结果
     * Search device results
     */
    fun scanResult(list: List<IDOBleDeviceModel>?)

    /**
     * 蓝牙状态
     * Bluetooth status
     */
    fun bluetoothState(state: IDOBluetoothStateModel)

    /**
     * 设备状态状态
     * device status status
     */
    fun deviceState(state: IDODeviceStateModel)

    /**
     * spp状态
     * spp status
     */
    fun stateSPP(state: IDOSppStateModel)

    /**
     * bt状态
     * spp status
     */
    fun stateBT(isPair: Boolean) {}

    /**
     * spp文件写完成
     * spp file writing completed
     */
    fun writeSPPCompleteState(btMacAddress: String)

//    // 发送数据状态
//    fun writeState(state: IDOWriteStateModel)

    // 收到数据
    fun receiveData(data: IDOReceiveData)

}

interface IDODfuDelegate {
    /**
     * 监听dfu完成状态
     * Monitor dfu completion status
     */
    fun dfuComplete()

    /**
     * 监听dfu过程的错误
     * Monitor errors in the dfu process
     */
    fun dfuError(error: String)

    /**
     * 监听升级进度 0-100
     * Monitor upgrade progress 0-100
     */
    fun dfuProgress(progress: Int)
}

interface BleInterface {

    /**
     * 当前蓝牙连接对象
     * Current Bluetooth connection object
     */
    val bleDevice: IDOBleDeviceModel

    /**
     * 添加蓝牙代理
     * Add bluetooth delegate
      */
    fun addBleDelegate(api: IDOBleDelegate?)

    /**
     * 添加DFU升级 (nordic)
     * Add DFU upgrade (nordic)
     */
    fun addDfuDelegate(api: IDODfuDelegate?)

    /**
     * 开始搜索 | Start search
     * @param macAddress (Android):根据Mac地址搜索 | (Android):Search by MacAddress
     * @return 返回指定搜索的设备,如未指定返回null | Returns the specified search device, or null if not specified.
     */
    fun startScan(macAddress: String = "", completion: (List<IDOBleDeviceModel>?) -> Unit)

    /**
     * 搜索筛选条件
     * @param deviceName 只搜索deviceName的设备 | Only search for devices with deviceName
     * @param deviceID 只搜索deviceID的设备 | Search only devices with deviceID
     * @param macAddress 只搜索macAddress的设备 | Search only devices with macAddress
     * @param uuid 只搜索uuid的设备 | Only search devices with uuid
     */
    fun scanFilter(
        deviceName: List<String>?,
        deviceID: List<Long>?,
        macAddress: List<String>?,
        uuid: List<String>?
    )

    /**
     * 停止搜索 | Stop scan
     */
    fun stopScan()

    /**
     * 连接 | Connect
     * @param device Mac地址必传,最好使用搜索返回的对象 | The Mac address must be passed, it is best to use the object returned by the search
     */
    fun connect(device: IDOBleDeviceModel?)

    /**
     * 使用这个重连设备 | Use this to reconnect the device
     */
    fun autoConnect(device: IDOBleDeviceModel?)

    /**
     * 取消连接 | Cancel connect
     */
    fun cancelConnect(macAddress: String?, completion: (Boolean) -> Unit)

    /**
     * 获取蓝牙状态 | Get bluetooth status
     */
    fun getBluetoothState(completion: (IDOBluetoothStateModel) -> Unit)

    /**
     * 获取设备连接状态 | Get device connection status
     */
    fun getDeviceState(device: IDOBleDeviceModel?, completion: (IDODeviceStateModel) -> Unit)

    /**
     * bt配对 | Bt pairing
     */
    fun setBtPair(device: IDOBleDeviceModel)

    /**
     * 取消配对 | Unpair
     */
    fun cancelPair(device: IDOBleDeviceModel?)

    /**
     * 连接SPP | Connect SPP
     */
    fun connectSPP(btMacAddress: String)

    /**
     * 断开SPP | Disconnect SPP
     */
    fun disconnectSPP(btMacAddress: String)

    /**
     * 发起dfu升级 | Start dfu upgrade
     */
    fun startNordicDFU(config: IDODfuConfig)

    /**
     * 导出ble日志,返回压缩后日志zip文件绝对路径
     * Export the ble log and return the absolute path of the compressed log zip file
     */
    fun exportLog(completion: (String?) -> Unit)

    /**
     * 发送数据
     * send data
     */
    fun writeData(
        data: ByteArray,
        device: IDOBleDeviceModel,
        type: Int,
        platform: Int,
        completion: (IDOWriteStateModel) -> Unit
    )
}