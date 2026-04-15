package com.idosmart.protocol_sdk

interface DeviceInterface {
    /**
     * 设备模式 0：运动模式，1：睡眠模式
     */
    val deviceMode: Int

    /**
     * 电量状态 0:正常, 1:正在充电, 2:充满, 3:电量低
     */
    val battStatus: Int

    /**
     * 电量级别 0～100
     */
    val battLevel: Int

    /**
     * 是否重启 0:未重启 1:重启
     */
    val rebootFlag: Int

    /**
     * 绑定状态 0:未绑定 1:已绑定
     */
    val bindState: Int

    /**
     * 绑定类型 0:默认 1:单击 2:长按 3:屏幕点击 横向确认和取消,确认在左边 4:屏幕点击 横向确认和取消,确认在右边
     * 5:屏幕点击 竖向确认和取消,确认在上边 6:屏幕点击 竖向确认和取消,确认在下边 7:点击(右边一个按键)
     */
    val bindType: Int

    /**
     * 绑定超时 最长为15秒,0表示不超时
     */
    val bindTimeout: Int

    /**
     * 设备平台 0:nordic, 10:realtek 8762x, 20:cypress psoc6, 30:Apollo3, 40:汇顶, 50:nordic+泰凌微,
     * 60:泰凌微+5340+no nand flash, 70:汇顶+富瑞坤, 80:5340
     */
    val platform: Int

    /**
     * 设备形状类型 0：无效；1：圆形；2：方形的； 3：椭圆
     */
    val deviceShapeType: Int

    /**
     * 设备类型 0：无效；1：手环；2：手表
     */
    val deviceType: Int

    /**
     * 自定义表盘主版本 从1开始 0:不支持对应的自定义表盘功能
     */
    val dialMainVersion: Int

    /**
     * 固件绑定时候显示勾ui界面 0:不需要 1:需要
     */
    val showBindChoiceUi: Int

    /**
     * 设备id
     */
    val deviceId: Int

    /**
     * 设备固件主版本号
     */
    val firmwareVersion: Int

    /**
     * 当前设备mac地址 - 无冒号
     */
    val macAddress: String

    /**
     * 当前设备mac地址 - 带冒号
     */
    val macAddressFull: String

    /**
     * 注意：该名称是由调用 libManager.markConnectedDevice(...)传入，sdk不会主去刷新该值
     * 需要获取最新值可以使用 CmdEvtType.getDeviceName 指令
     */
    val deviceName: String

    /**
     * OTA模式
     */
    val otaMode: Boolean

    /**
     * UUID ios专用
     */
    val uuid: String

    /**
     * BT macAddress - 带冒号
     */
    val macAddressBt: String

    /**
     * 设备SN
     */
    val sn: String?

    /**
     * BtName
     */
    val btName: String?

    /**
     * GPS芯片平台 0：无效 1：索尼 sony 2：洛达 Airoh 3：芯与物 icoe
     */
    val gpsPlatform: Int

    /**
     * 固件版本version1
     */
    val fwVersion1: Int

    /**
     * 固件版本version2
     */
    val fwVersion2: Int

    /**
     * 固件版本version3
     */
    val fwVersion3: Int

    /**
     * BT版本生效标志位 0：无效 1：说明固件有对应的BT固件
     */
    val fwBtFlag: Int

    /**
     * BT的版本version1
     */
    val fwBtVersion1: Int

    /**
     * BT的版本version2
     */
    val fwBtVersion2: Int

    /**
     * BT的版本version3
     */
    val fwBtVersion3: Int

    /**
     * BT的所需要匹配的版本version1
     */
    val fwBtMatchVersion1: Int

    /**
     * BT的所需要匹配的版本version2
     */
    val fwBtMatchVersion2: Int

    /**
     * BT的所需要匹配的版本version3
     */
    val fwBtMatchVersion3: Int

    /**
     * 刷新设备信息
      */
    fun refreshDeviceInfo(forced: Boolean, completion: (Boolean) -> Unit)

    /**
     * 刷新设备三级版本
     */
    fun refreshFirmwareVersion(forced: Boolean, completion: (Boolean) -> Unit)
}