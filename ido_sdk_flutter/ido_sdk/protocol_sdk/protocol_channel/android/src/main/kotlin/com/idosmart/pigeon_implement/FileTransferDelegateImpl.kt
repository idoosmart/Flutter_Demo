package com.idosmart.pigeon_implement

import com.idosmart.pigeongen.api_file_transfer.ApiTransStatus
import com.idosmart.pigeongen.api_file_transfer.ApiTransType
import com.idosmart.pigeongen.api_file_transfer.FileTransferDelegate
import com.idosmart.protocol_sdk.BlockFileTransProgress
import com.idosmart.protocol_sdk.BlockFileTransStatus
import com.idosmart.enums.*
import com.idosmart.pigeongen.api_file_transfer.ApiDeviceTransItem
import com.idosmart.protocol_channel.innerRunOnMainThread
import com.idosmart.protocol_sdk.BlockDeviceFileToAppTask

internal class FileTransferDelegateImpl: FileTransferDelegate {

    companion object {
        @Volatile
        private var instance: FileTransferDelegateImpl? = null
        fun instance(): FileTransferDelegateImpl {
            return instance ?: synchronized(this) {
                instance ?: FileTransferDelegateImpl().also { instance = it }
            }
        }
    }

    var callbackFileTrasnStatus: BlockFileTransStatus? = null
    var callbackFileTransProgress: BlockFileTransProgress? = null
    private var lastTransStatus: ApiTransStatus? = null
    var transFileType: IDOTransType? = null

    // Callback for device file transfer task
    var callbackDeviceFileTransTask: BlockDeviceFileToAppTask? = null

    // Callback for transfer progress updates
    var callbackDeviceFileTransProgress: ((Double) -> Unit)? = null

    // Callback for when the transfer completes
    var callbackDeviceFileTransComplete: ((Boolean, String?) -> Unit)? = null

    // Instance of the device file transfer task
    var deviceFileToAppTask: IDODeviceFileToAppTask? = null
    override fun listenTransFileTypeChanged(fileType: ApiTransType?) {
        transFileType = null
        fileType?.let {
            transFileType = IDOTransType.ofRaw(fileType.raw)
        }
    }

    override fun fileTransStatusMultiple(index: Long, status: ApiTransStatus) {
          lastTransStatus = status
//        callbackFileTrasnStatus?.let {
//            it(index.toInt(),IDOTransStatus.ofRaw(status.raw) ?: IDOTransStatus.NONE,0,0)
//        }
    }

    override fun fileTransProgressMultiple(
        currentIndex: Long,
        totalCount: Long,
        currentProgress: Double,
        totalProgress: Double
    ) {
       callbackFileTransProgress?.let {
           it(currentIndex.toInt(),totalProgress.toInt(),currentProgress.toFloat(),totalProgress.toFloat())
       }
    }

    override fun fileTransErrorCode(
        index: Long,
        errorCode: Long,
        errorCodeFromDevice: Long,
        finishingTime: Long
    ) {
        callbackFileTrasnStatus?.let {
            val errCode = errorCode.toInt()
            val time = if (errCode == 24 || errCode == 25)  finishingTime.toInt() else null
            val status = if (lastTransStatus != null) IDOTransStatus.ofRaw(lastTransStatus!!.raw) else null
            it(index.toInt(),status?:IDOTransStatus.NONE,errorCode.toInt(),time)
        }
    }

    override fun deviceToAppTransItem(deviceTransItem: ApiDeviceTransItem) {
        var fileType: IDODeviceTransType = IDODeviceTransType.ACC_LOG // Default to accLog

        // Get the file type from the deviceTransItem
        deviceTransItem.fileType?.let { type ->
            IDODeviceTransType.values().find { it.type == type.toInt() }?.let {
                fileType = it
            } ?: run {
                innerRunOnMainThread {
                    logNative("异常：设备返回不支持的文件类型：${deviceTransItem.fileType ?: 0}")
                }
            }
        }

        // Create IDODeviceTransItem
        val item = IDODeviceTransItem(
            fileType = fileType,
            fileSize = deviceTransItem.fileSize?.toInt() ?: 0,
            fileCompressionType = deviceTransItem.fileCompressionType?.toInt() ?: 0,
            fileName = deviceTransItem.fileName ?: "unknown",
            filePath = deviceTransItem.filePath
        )

        // Create IDODeviceFileToAppTask
        val task = IDODeviceFileToAppTask(deviceTransItem = item)
        deviceFileToAppTask = task

        // Invoke the callback
        callbackDeviceFileTransTask?.invoke(task)
    }

    override fun deviceToAppTransProgress(progress: Double) {
        // Invoke the progress callback
        callbackDeviceFileTransProgress?.invoke(progress)
    }

    override fun deviceToAppTransStatus(isCompleted: Boolean, receiveFilePath: String?) {
        // Invoke the completion callback
        callbackDeviceFileTransComplete?.invoke(isCompleted, receiveFilePath)
    }

}