package com.idosmart.pigeon_implement

import com.idosmart.pigeongen.api_data_sync.SyncData
import com.idosmart.protocol_channel.plugin
import com.idosmart.protocol_sdk.*
import com.idosmart.enums.*
import com.idosmart.protocol_channel.innerRunOnMainThread

internal class SyncDataImpl: SyncDataInterface {

    private fun syncData(): SyncData? {
        return plugin.syncData()
    }

    override val status: IDOSyncStatus
        get() = SyncDataDelegateImpl.instance().syncStatus

    override fun startSync(
        funcProgress: BlockDataSyncProgress,
        funcData: BlockDataSyncData,
        funcCompleted: BlockDataSyncCompleted
    ) {
        SyncDataDelegateImpl.instance().callbackProgress = funcProgress
        SyncDataDelegateImpl.instance().callbackSyncData = funcData
        SyncDataDelegateImpl.instance().callbackSyncCompleted = funcCompleted
        innerRunOnMainThread {
            syncData()?.startSync {}
        }
    }

    override fun startSync(
        types: List<IDOSyncDataType>?,
        funcData: BlockDataSyncData,
        funcCompleted: BlockDataSyncCompleted
    ) {
        SyncDataDelegateImpl.instance().callbackProgress = null
        SyncDataDelegateImpl.instance().callbackSyncData = funcData
        SyncDataDelegateImpl.instance().callbackSyncCompleted = funcCompleted
        innerRunOnMainThread {
            if (types.isNullOrEmpty()) {
                syncData()?.startSync {}
            } else {
                val list = types.map { it.raw.toLong() }
                syncData()?.startSyncWithTypes(list) {}
            }
        }
    }

    override fun getSupportSyncDataTypeList(completion: (types: List<IDOSyncDataType>) -> Unit) {
        innerRunOnMainThread {
            syncData()?.getSupportSyncDataTypeList { it1 ->
                val list = it1.map { it2 ->
                    IDOSyncDataType.ofRaw(it2.toInt()) ?: IDOSyncDataType.NULLTYPE
                }
                completion(list)
            }
        }
    }

    override fun stopSync() {
        innerRunOnMainThread {
            syncData()?.stopSync { }
        }
    }

}