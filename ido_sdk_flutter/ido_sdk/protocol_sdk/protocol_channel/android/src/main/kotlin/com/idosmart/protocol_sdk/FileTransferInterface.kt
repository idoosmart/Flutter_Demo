package com.idosmart.protocol_sdk

import com.idosmart.enums.IDOTransStatus
import com.idosmart.enums.IDOTransType
import com.idosmart.pigeon_implement.IDODeviceFileToAppTask

/*internal interface TransBaseModeConver {
    fun toBaseFile(): BaseFile
}*/

interface IDOTransBaseModel {

    /**
     * 文件类型
     */
    var fileType: IDOTransType

    /**
     * 文件绝对地址
     */
    var filePath: String

    /**
     * 文件名
     */
    var fileName: String

    /**
     * 文件大小
     */
    var fileSize: Int?

}


/**
 * 文件传输状态
 *
 * @param currentIndex 当前传输文件索引
 * @param status 传输状态
 * @param errorCode 错误码:
 * ```
 * 0 Successful command
 * 1 SVC handler is missing
 * 2 SoftDevice has not been enabled
 * 3 Internal Error
 * 4 No Memory for operation
 * 5 Not found
 * 6 Not supported
 * 7 Invalid Parameter
 * 8 Invalid state, operation disallowed in this state
 * 9 Invalid Length
 * 10 Invalid Flags
 * 11 Invalid Data
 * 12 Invalid Data size
 * 13 Operation timed out
 * 14 Null Pointer
 * 15 Forbidden Operation
 * 16 Bad Memory Address
 * 17 Busy
 * 18 Maximum connection count exceeded.
 * 19 Not enough resources for operation
 * 20 Bt Bluetooth upgrade error
 * 21 Not enough space for operation
 * 22 Low Battery
 * 23 Invalid File Name/Format
 * 24 空间够但需要整理
 * 25 空间整理中
 * -1 取消
 * -2 失败
 * -3 指令已存在队列中
 * -4 执行快速配置中，指令忽略
 * -5 设备处于ota模式
 * -6 未连接设备
 * -7 执行中的指令被中断
 * ```
 * @param finishingTime 固件预计整理时长, 当errorCode是24、25的时候 才会返回值, 其它情况都是0
 */
typealias BlockFileTransStatus = (currentIndex: Int, status: IDOTransStatus, errorCode: Int?, finishingTime: Int?) -> Unit

/**
 * 文件传输进度
 *
 * @param currentIndex 当前传输文件索引
 * @param totalCount 总文件数
 * @param currentProgress 当前文件传输进度 0 ~ 1.0
 * @param totalProgress 总进度0 ~ 1.0
 */
typealias BlockFileTransProgress = (currentIndex: Int, totalCount: Int, currentProgress: Float, totalProgress: Float) -> Unit
 typealias BlockDeviceFileToAppTask = (task: IDODeviceFileToAppTask) -> Unit

interface FileTransferInterface {

    /**
     * 是否在执行传输
     */
    val isTransmitting: Boolean

    /**
     * 当前传输中的文件类型
     */
    val transFileType: IDOTransType?

    /**
     * 执行文件传输
     *
     * @param fileItems 待传文件
     * @param cancelPrevTranTask 是否取消执行中的传输任务(如果有)
     * @param transProgress 文件传输进度
     * @param transStatus 文件传输状态
     * @param completion 传输结果,形如:[true, true, ...] 和传入的 fileItems 一一对应
     */
    fun <T : IDOTransBaseModel> transferFiles(
        fileItems: List<T>,
        cancelPrevTranTask: Boolean,
        transProgress: BlockFileTransProgress,
        transStatus: BlockFileTransStatus,
        completion: (List<Boolean>) -> Unit
    ): IDOCancellable?

    /**
     * 获取压缩前.iwf文件大小
     *
     * @param filePath 表盘文件绝对路径
     * @param type 表盘类型 1 云表盘 ,2 壁纸表盘
     * @param completion 文件大小(单位 字节)
     */
    fun iwfFileSize(filePath: String, type: Int, completion: (Int) -> Unit)
    /// 注册 设备文件->app传输 (全局注册一次）
    ///
    /// transTask 接收到的文件任务
    fun registerDeviceTranFileToApp(transTask: BlockDeviceFileToAppTask)

    /// 取消注册 设备文件 -> app传输
    fun unregisterDeviceTranFileToApp()
}




