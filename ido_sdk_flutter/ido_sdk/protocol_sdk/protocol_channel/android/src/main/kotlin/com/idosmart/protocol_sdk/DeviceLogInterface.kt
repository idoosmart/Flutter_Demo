package com.idosmart.protocol_sdk

import com.idosmart.enums.IDODeviceLogType

/// 日志整体进度 0-100
typealias BlockLogProgress = (progress: Double) -> Unit

interface DeviceLogInterface {

    /**
     * 是否正在获取日志中
     */
    val getLogIng: Boolean

    /**
     * 获取所有日志目录地址
     * 返回：/xx/../ido_sdk/devices/{macAddress}/device_logs
     * lash 日志目录 Flash
     * 电池日志目录 Battery
     * 过热日志目录 Heat
     * 旧的重启日志目录 Reboot
     */
    val logDirPath: String

    /**
     * 开始获取日志
     * @param types 日志类型集合
     * @param timeOut 获取日志超时
     * @param progress 日志获取进度 (0-100)
     * @param completion 日志获取完成回调
     *     - result: Boolean
     */
    fun startGet(
        types: List<IDODeviceLogType>,
        timeOut: Int,
        progress: BlockLogProgress,
        completion: (result: Boolean) -> Unit
    )

    /**
     * 取消获取日志
     */
    fun cancel(completion: () -> Unit)
}