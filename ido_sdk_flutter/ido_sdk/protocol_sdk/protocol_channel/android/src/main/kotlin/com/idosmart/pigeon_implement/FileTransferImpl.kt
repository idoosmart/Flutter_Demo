package com.idosmart.pigeon_implement

import com.idosmart.pigeongen.api_file_transfer.ApiTransType
import com.idosmart.pigeongen.api_file_transfer.BaseFile
import com.idosmart.pigeongen.api_file_transfer.CancelTransferToken
import com.idosmart.pigeongen.api_file_transfer.FileTransfer
import com.idosmart.protocol_channel.plugin
import com.idosmart.protocol_sdk.*
import java.util.Random
import com.idosmart.enums.*
import com.idosmart.protocol_channel.innerRunOnMainThread

/// 普通文件
/// 根据FileTransType区分
///
/// 注：以下类型需使用相应的分类：
/// - 消息图标 - 使用 MessageFileModel类
/// - 音乐 - 使用 MusicFileModel
/// - 运动图标 - 使用 SportFileModel
class IDOTransNormalModel(
    override var fileType: IDOTransType,
    override var filePath: String,
    override var fileName: String,
    override var fileSize: Int?
) : IDOTransBaseModel {
    internal fun toBaseFile(): BaseFile {
        return BaseFile(
            ApiTransType.ofRaw(fileType.raw),
            filePath, fileName, fileSize?.toLong()
        )
    }

}
/// 消息图标
///
/// evtType 事件类型
/// 参考 通消息通知事件号
/// Android 由 APP分配，iOS由固件分配
/// packName 应用包名
@Deprecated("已废弃")
class IDOTransMessageModel(
    override var filePath: String,
    override var fileName: String,
    override var fileSize: Int?,
    var evtType: Int,
    var packName: String
) : IDOTransBaseModel {
    internal  fun toBaseFile(): BaseFile {
        return BaseFile(
            ApiTransType.MSG,
            filePath, fileName, fileSize?.toLong(),
            0, evtType.toLong(), packName
        )
    }

    override var fileType: IDOTransType
        get() = IDOTransType.MSG
        set(value) {}

}

/// 音乐
///
/// musicId: 音乐id
/// singerName: 歌手
/// useSpp: 是否使用SPP传输
class IDOTransMusicModel(
    override var filePath: String,
    override var fileName: String,
    override var fileSize: Int?,
    var musicId: Int,
    var singerName: String?,
    var useSpp: Boolean = false
) : IDOTransBaseModel {

    internal fun toBaseFile(): BaseFile {
        return BaseFile(
            ApiTransType.MP3,
            filePath, fileName, fileSize?.toLong(),
            0, 0, "", musicId.toLong(), singerName, useSpp
        )
    }

    override var fileType: IDOTransType
        get() = IDOTransType.MP3
        set(value) {}
}

/// 运动图标
///
/// sportType : 运动类型
/// iconType : 图标类型 1:单张小运动图片 2:单张大运动图片 3:多运动动画图片 4:单张中运动图片 5:运动最小图标
/// isSports : 动画图标
class IDOTransSportModel(
    override var filePath: String,
    override var fileName: String,
    override var fileSize: Int?,
    var sportType: Int,
    var iconType: Int,
    var isSports: Boolean,
) : IDOTransBaseModel {
     internal fun toBaseFile(): BaseFile {
        return BaseFile(
            (if(isSports) ApiTransType.SPORTS else ApiTransType.SPORT),
            filePath, fileName, fileSize?.toLong(),
            0, 0,
            "", 0, "", false,
            sportType.toLong(), iconType.toLong(), isSports
        )
    }

    override var fileType: IDOTransType
        get() = if(isSports) IDOTransType.SPORTS else IDOTransType.SPORT
        set(value) {}
}


class TransCancellable(token: String?) : IDOCancellable {

    private fun fileTransfer(): FileTransfer? {
        return plugin.fileTransfer()
    }

    override var isCancelled: Boolean = false

    var token: String? = token

    override fun cancel() {
        isCancelled = true
        token?.let {
            innerRunOnMainThread {
                fileTransfer()?.cancelTransfer(CancelTransferToken(token)) {}
            }
        }
    }
}


internal class FileTransferImpl : FileTransferInterface {

    private fun fileTransfer(): FileTransfer? {
        return plugin.fileTransfer()
    }

    private var _isTransmitting: Boolean = false

    override val isTransmitting: Boolean
        get() = _isTransmitting
    override val transFileType: IDOTransType?
        get() = FileTransferDelegateImpl.instance().transFileType

    override fun <T : IDOTransBaseModel> transferFiles(
        fileItems: List<T>,
        cancelPrevTranTask: Boolean,
        transProgress: BlockFileTransProgress,
        transStatus: BlockFileTransStatus,
        completion: (List<Boolean>) -> Unit
    ): IDOCancellable? {
        if (fileItems.any { it is IDOTransMessageModel }) {
            transStatus.let { it(0, IDOTransStatus.INVALID, 0, 0) }
            return null
        }
        _isTransmitting = true
        FileTransferDelegateImpl.instance().callbackFileTransProgress = transProgress
        FileTransferDelegateImpl.instance().callbackFileTrasnStatus = transStatus
        val random = Random()
        val token = "${random.nextInt(999)}_${System.currentTimeMillis()}"
        val cancelToken = CancelTransferToken(token)
        val mappedList: MutableList<BaseFile> = mutableListOf()
        fileItems.forEach { item ->
            when (item) {
                is IDOTransNormalModel -> mappedList.add(item.toBaseFile())
                is IDOTransMessageModel -> mappedList.add(item.toBaseFile())
                is IDOTransMusicModel -> mappedList.add(item.toBaseFile())
                is IDOTransSportModel -> mappedList.add(item.toBaseFile())
                else -> {}
            }
        }
        innerRunOnMainThread {
            fileTransfer()?.transferMultiple(
                mappedList,
                cancelPrevTranTask,
                cancelToken,
                completion
            )
        }
        return TransCancellable(token)
    }


    override fun iwfFileSize(filePath: String, type: Int, completion: (Int) -> Unit) {
        innerRunOnMainThread {
            fileTransfer()?.iwfFileSize(filePath, type.toLong()) {
                completion(it.toInt())
            }
        }
    }

    override fun registerDeviceTranFileToApp(transTask: BlockDeviceFileToAppTask) {
        FileTransferDelegateImpl.instance().callbackDeviceFileTransTask = transTask
        innerRunOnMainThread {
            fileTransfer()?.registerDeviceTranFileToApp {

            }
        }
    }

    override fun unregisterDeviceTranFileToApp() {
        innerRunOnMainThread {
            fileTransfer()?.registerDeviceTranFileToApp { }
        }
    }


}

// 设备传文件到app
class IDODeviceFileToAppTask(var deviceTransItem: IDODeviceTransItem) {

    // A delegate to handle callbacks
    private val delegate = FileTransferDelegateImpl.instance()

    // A transfer object to handle the file transfer logic
    private fun fileTransfer(): FileTransfer? {
        return plugin.fileTransfer()
    }
    // 允许接收文件
    // - Parameters:
    //   - onProgress: 传输进度 0 ~ 1.0
    //   - onComplete: 传输结果， isCompleted，receiveFilePath 接收后的文件（isCompleted为true时有效）
    fun acceptReceiveFile(onProgress: (Double) -> Unit, onComplete: (Boolean, String?) -> Unit) {
        delegate.callbackDeviceFileTransProgress = onProgress
        delegate.callbackDeviceFileTransComplete = onComplete
        innerRunOnMainThread {
            fileTransfer()?.acceptReceiveFile {

            }
        }
    }
    // 拒绝接收文件
    fun rejectReceiveFile(completion: (Boolean) -> Unit) {
        innerRunOnMainThread {
            fileTransfer()?.rejectReceiveFile(completion)
        }
    }

    // APP主动停止设备传输文件到APP
    fun stopReceiveFile(completion: (Boolean) -> Unit) {
        innerRunOnMainThread {
            fileTransfer()?.stopReceiveFile(completion)
        }
    }



}

// 设备传输文件项
open class IDODeviceTransItem(
    val fileType: IDODeviceTransType,
    val fileSize: Int,
    val fileCompressionType: Int,
    val fileName: String,
    val filePath: String?
)

// 设备传输文件类型
enum class IDODeviceTransType(val type: Int) {
    // 语音备忘录文件
    VOICE_MEMO(0x13),
    // acc算法日志文件
    ACC_LOG(0x15),
    // gps算法日志文件
    GPS_LOG(0x16)
}