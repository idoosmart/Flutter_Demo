package com.idosmart.pigeon_implement

import com.idosmart.pigeongen.api_data_sync.ApiSyncDataType
import com.idosmart.pigeongen.api_data_sync.SyncDataDelegate
import com.idosmart.protocol_sdk.BlockDataSyncCompleted
import com.idosmart.protocol_sdk.BlockDataSyncData
import com.idosmart.protocol_sdk.BlockDataSyncProgress
import com.idosmart.enums.*
import com.idosmart.pigeongen.api_data_sync.ApiSyncStatus

internal class SyncDataDelegateImpl: SyncDataDelegate {

    companion object {
        @Volatile
        private var instance: SyncDataDelegateImpl? = null
        fun instance(): SyncDataDelegateImpl {
            return instance ?: synchronized(this) {
                instance ?: SyncDataDelegateImpl().also { instance = it }
            }
        }
    }

    var callbackProgress: BlockDataSyncProgress? = null
    var callbackSyncData: BlockDataSyncData? = null
    var callbackSyncCompleted: BlockDataSyncCompleted? = null
    var syncStatus : IDOSyncStatus = IDOSyncStatus.INITSTATUS

    override fun callbackSyncProgress(progress: Double) {
        callbackProgress?.let { it(progress) }
    }

    override fun callbackSyncData(type: ApiSyncDataType, jsonStr: String, errorCode: Long) {
        val  dataType = IDOSyncDataType.ofRaw(type.raw) ?: IDOSyncDataType.NULLTYPE
       callbackSyncData?.let { callback-> callback(dataType,jsonStr,errorCode.toInt()) }
    }

    override fun callbackSyncCompleted(errorCode: Long) {
        // 由于状态是异步从flutter传过来的,可能会有延迟，此处手动赋值
        syncStatus = IDOSyncStatus.FINISHED
       callbackSyncCompleted?.let { it(errorCode.toInt()) }
    }

    override fun listenSyncStatus(status: ApiSyncStatus) {
        syncStatus = IDOSyncStatus.ofRaw(status.raw) ?: IDOSyncStatus.INITSTATUS
    }


}