package com.idosmart.protocol_sdk

import com.idosmart.enums.IDOSyncDataType
import com.idosmart.enums.IDOSyncStatus


/**
 * 同步整体进度 0-100
 */
typealias BlockDataSyncProgress = (progress: Double) -> Unit

/**
 * 不同类型JSON数据同步回调
 */
typealias BlockDataSyncData = (type: IDOSyncDataType, jsonStr: String, errorCode: Int) -> Unit

/**
 * 所有数据同步完成
 */
typealias BlockDataSyncCompleted = (errorCode: Int) -> Unit

interface SyncDataInterface {

    /**
     * 同步状态
     */
    val status: IDOSyncStatus

    /**
     * 开始同步所有数据
     * @param funcProgress: 同步数据进度回调
     *     - progress: 进度值
     * @param funcData: 同步数据回调
     *     - type: 数据类型
     *     - jsonStr: 健康数据json
     *     - errorCode: 错误码 0为成功，非0不成功
     * @param funcCompleted: 同步完成回调
     *     - errorCode: 错误码 0为成功，非0不成功
     */
    fun startSync(funcProgress: BlockDataSyncProgress,
                  funcData: BlockDataSyncData,
                  funcCompleted: BlockDataSyncCompleted)

    /**
     * 开始同步指定数据（无进度且不支持的类型不会回调）
     * @param types: 同步数据类型
     * @param funcData: 同步数据回调
     *     - type: 数据类型
     *     - jsonStr: 健康数据json
     *     - errorCode: 错误码 0为成功，非0不成功
     * @param funcCompleted: 同步完成回调
     *     - errorCode: 错误码 0为成功，非0不成功
     */
    fun startSync(
        types: List<IDOSyncDataType>?,
        funcData: BlockDataSyncData,
        funcCompleted: BlockDataSyncCompleted)

    /**
     * 获取支持的同步数据类型
     */
    fun getSupportSyncDataTypeList(completion: (types: List<IDOSyncDataType>) -> Unit)

    /**
     * 停止同步所有数据
     */
    fun stopSync()

}