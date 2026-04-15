//
//  FileTransferImpl.swift
//  protocol_channel
//
//  Created by hc on 2023/8/16.
//

import Foundation

private var _transer: FileTransfer? {
    return SwiftProtocolChannelPlugin.shared.fileTransfer
}

private var _delegate: FileTransferDelegateImpl {
    return FileTransferDelegateImpl.shared
}

@objcMembers
class FileTransferImpl: IDOFileTransferInterface {

    public private(set) var isTransmitting: Bool = false

    public private(set) var transFileType: IDOTransTypeClass?

    func transferFiles(fileItems: [IDOTransBaseModel],
                       cancelPrevTranTask: Bool,
                       transProgress: @escaping BlockFileTransProgress,
                       transStatus: @escaping BlockFileTransStatus,
                       completion: @escaping ([Bool]) -> Void) -> IDOCancellable?
    {
        guard !fileItems.isEmpty && fileItems.first is TransBaseModeConver else {
            transStatus(0, .invalid, 0, 0)
            return nil
        }
        
        if (fileItems.contains(where: { $0 is IDOTransMessageModel })) {
            _logNative("忽略外部调用消息图片传输")
            transStatus(0, .invalid, 0, 0)
            return nil
        }
        
//        if (!cancelPrevTranTask) {
//            _transer?.isTransmitting(completion: { isTransmitting in
//
//            })
//        }
        
        let token = "\(arc4random_uniform(999))_\(Date().milliStamp)"
        // !!!: 存在不能并发调用问题，待解决
        _delegate.callbackFileTrasnStatus = transStatus
        _delegate.callbackFileTransProgress = transProgress
        _runOnMainThread {
            _transer?.transferMultiple(fileItems: fileItems.map { ($0 as! TransBaseModeConver).toBaseFile() },
                                       cancelPrevTranTask: cancelPrevTranTask,
                                       cancelToken: CancelTransferToken(token: token),
                                       completion: completion)
        }
        return TransCancellable(token: token)
    }

    func iwfFileSize(filePath: String, type: Int64, completion: @escaping (Int64) -> Void) {
        _runOnMainThread {
            _transer?.iwfFileSize(filePath: filePath, type: type, completion: completion)
        }
    }
    
    func registerDeviceTranFileToApp(transTask: @escaping BlockDeviceFileToAppTask) {
        _delegate.callbackDeviceFileTransTask = transTask
        _runOnMainThread {
            _transer?.registerDeviceTranFileToApp(completion: { })
        }
    }
    
    func unregisterDeviceTranFileToApp() {
        _runOnMainThread {
            _transer?.unregisterDeviceTranFileToApp(completion: { })
        }
    }
}

/// 文件传输状态
/// - Parameters:
///   - currentIndex: 当前传输文件索引
///   - status: 传输状态
///   - errorCode: c库返回的错误码
///   - finishingTime: 固件预计整理时长， 当errorCode是24、25的时候 才会返回值, 其它情况都是0
///
/// ```
///  errorCode:
///  0 Successful command
///  1 SVC handler is missing
///  2 SoftDevice has not been enabled
///  3 Internal Error
///  4 No Memory for operation
///  5 Not found
///  6 Not supported
///  7 Invalid Parameter
///  8 Invalid state, operation disallowed in this state
///  9 Invalid Length
///  10 Invalid Flags
///  11 Invalid Data
///  12 Invalid Data size
///  13 Operation timed out
///  14 Null Pointer
///  15 Forbidden Operation
///  16 Bad Memory Address
///  17 Busy
///  18 Maximum connection count exceeded.
///  19 Not enough resources for operation
///  20 Bt Bluetooth upgrade error
///  21 Not enough space for operation
///  22 Low Battery
///  23 Invalid File Name/Format
///  24 空间够但需要整理
///  25 空间整理中
///
///  sdk扩展补充:
/// -1 取消
/// -2 失败
/// -3 指令已存在队列中
/// -4 设备断线
/// -5 ota模式
/// ```
public typealias BlockFileTransStatus = (_ currentIndex: Int,
                                         _ status: IDOTransStatus,
                                         _ errorCode: Int,
                                         _ finishingTime: Int) -> Void

/// 文件传输进度
/// - Parameters:
///   - currentIndex: 当前传输文件索引
///   - totalCount: 总文件数
///   - currentProgress: 当前文件传输进度 0 ~ 1.0
///   - totalProgress: 总进度0 ~ 1.0
public typealias BlockFileTransProgress = (_ currentIndex: Int,
                                           _ totalCount: Int,
                                           _ currentProgress: Float,
                                           _ totalProgress: Float) -> Void


public typealias BlockDeviceFileToAppTask = (_ task: IDODeviceFileToAppTask) -> Void

/// 传输文件类型
@objc
public enum IDOTransType: Int {
    /// 固件升级
    case fw = 0
    /// 图片资源升级
    case fzbin = 1
    /// 字库、ota等bin文件升级
    case bin = 2
    /// 语言包升级
    case lang = 3
    /// BT升级
    case bt = 4
    /// 表盘
    case iwfLz = 5
    /// 表盘 思澈
    case watch = 6
    /// 壁纸表盘
    case wallpaperZ = 7
    /// 通讯录文件
    case ml = 8
    /// agps 在线
    case onlineUbx = 9
    /// agps 线下
    case offlineUbx = 10
    /// 音乐（请使用 IDOTransMusicModel）
    case mp3 = 11
    /// 消息图标 （请使用 IDOTransMessageModel）
    @available(*, deprecated, message: "已弃用")
    case msg = 12
    /// 运动图标 - 单个（请使用IDOTransSportModel）
    case sport = 13
    /// 运动图标 - 动画（请使用IDOTransSportModel）
    case sports = 14
    /// epo升级
    case epo = 15
    /// gps
    case gps = 16
    case bpbin = 17
    /// alexa 语音
    case voice = 18
    /// 提示音
    case ton = 19
    /// 小程序
    case app = 20
    /// 其它类型：不限后缀，不对文件二次加工，直接上传到设备
    /// ```
    /// hid: 检测引导程序hid更新(android专用)
    /// xx: xxxxx
    /// ```
    case other = 21
}

@objc
public enum IDOTransStatus: Int {
    case none = 0
    /// 无效类型
    case invalid = 1
    /// 文件不存在
    case notExists = 2
    /// 存在传输任务
    case busy = 3
    /// 配置
    case config = 4
    /// 传输前操作
    case beforeOpt = 5
    /// 传输中
    case trans = 6
    /// 传输完成
    case finished = 7
    /// 快速配置中，不支持文件传输
    case onFastSynchronizing = 8
    /// 传输失败
    case error = 9
}

protocol TransBaseModeConver {
    func toBaseFile() -> BaseFile
}

@objcMembers
public class IDOTransBaseModel: NSObject {
    /// 文件类型
    public let fileType: IDOTransType

    /// 文件绝对地址
    public let filePath: String

    /// 文件名
    public let  fileName: String

    /// 文件大小
    public var fileSize: Int = 0
    
    public init(fileType: IDOTransType, filePath: String, fileName: String, fileSize: Int = 0) {
        self.fileType = fileType
        self.filePath = filePath
        self.fileName = fileName
        self.fileSize = fileSize
    }
}

/// 普通文件
/// 根据FileTransType区分
///
/// 注：以下类型需使用相应的分类：
/// - 消息图标 - 使用 IDOTransMessageModel类
/// - 音乐 - 使用 IDOTransMusicModel
/// - 运动图标 - 使用 IDOTransSportModel
@objcMembers
public class IDOTransNormalModel: IDOTransBaseModel, TransBaseModeConver {
    
    public override init(fileType: IDOTransType, filePath: String, fileName: String, fileSize: Int = 0) {
        super.init(fileType: fileType, filePath: filePath, fileName: fileName, fileSize: fileSize)
    }
    
    func toBaseFile() -> BaseFile {
        return BaseFile(fileType: ApiTransType(rawValue: fileType.rawValue)!,
                        filePath: filePath,
                        fileName: fileName,
                        fileSize: fileSize.int64)
    }
}

/// 消息图标
@available(*, deprecated, message: "已弃用")
@objcMembers
public class IDOTransMessageModel: IDOTransBaseModel, TransBaseModeConver {
    /// 事件类型
    /// 参考 通消息通知
    /// ```
    /// 0x01：短信
    /// 0x02：邮件
    /// 0x03：微信
    /// 0x04：QQ
    /// 0x05：新浪微博
    /// 0x06：facebook
    /// 0x07：twitter
    /// 0x08：WhatsApp
    /// 0x09：Messenger
    /// 0x0A：Instagram
    /// 0x0B：Linked in
    /// 0x0C：日历
    /// 0x0D：skype；
    /// 0x0E：闹钟
    /// 0x0F：pokeman
    /// 0x10：VKontakte
    /// 0x11：Line
    /// 0x12：Viber
    /// 0x13：KakaoTalk
    /// 0x14：Gmail
    /// 0x15：Outlook,
    /// 0x16：Snapchat
    /// 0x17：TELEGRAM
    /// 0x18：other
    /// 0x20：chatwork
    /// 0x21：slack
    /// 0x22：Yahoo Mail
    /// 0x23：Tumblr,
    /// 0x24：Youtube
    /// 0x25：Yahoo Pinterest
    /// 0x26：TikTok
    /// 0x27：Redbus
    /// 0x28：Dailyhunt
    /// 0x29：Hotstar
    /// 0x2A：Inshorts
    /// 0x2B：Paytm
    /// 0x2C：Amazon
    /// 0x2D：Flipkart
    /// 0x2E：Prime
    /// 0x2F：Netflix
    /// 0x30：Gpay
    /// 0x31：Phonpe
    /// 0x32：Swiggy
    /// 0x33：Zomato
    /// 0x34：Make My trip
    /// 0x35：Jio Tv
    /// 0x36：keep
    /// 0x37：Microsoft
    /// 0x38：WhatsApp Business
    /// 0x39：niosefit
    /// 0x3A：missed_calls未接来电
    /// 0x3B：Gpap
    /// 0x3C：YTmusic
    /// 0x3D：Uber
    /// 0x3E：Ola
    /// 0x3F：事项提醒
    /// 0x40：Google meet
    /// ```
    public let evtType: Int

    /// 应用包名
    public let packName: String
    
    public init(filePath: String, fileName: String, fileSize: Int = 0, evtType: Int, packName: String) {
        self.evtType = evtType
        self.packName = packName
        super.init(fileType: .msg, filePath: filePath, fileName: fileName, fileSize: fileSize)
    }
    
    func toBaseFile() -> BaseFile {
        return BaseFile(fileType: ApiTransType(rawValue: fileType.rawValue)!,
                        filePath: filePath,
                        fileName: fileName,
                        fileSize: fileSize.int64,
                        evtType: evtType.int64,
                        packName: packName)
    }
}

/// 音乐
@objcMembers
public class IDOTransMusicModel: IDOTransBaseModel, TransBaseModeConver {
    /// 音乐id
    public let musicId: Int

    /// 歌手名
    public let singerName: String?

    /// 使用SPP传输
    public let useSpp: Bool = false

    public init(filePath: String!, fileName: String, fileSize: Int = 0, musicId: Int, singerName: String? = nil) {
        self.musicId = musicId
        self.singerName = singerName
        super.init(fileType: .mp3, filePath: filePath, fileName: fileName, fileSize: fileSize)
    }
    
    func toBaseFile() -> BaseFile {
        return BaseFile(fileType: ApiTransType(rawValue: fileType.rawValue)!,
                        filePath: filePath,
                        fileName: fileName,
                        fileSize: fileSize.int64,
                        musicId: musicId.int64,
                        singerName: singerName,
                        useSpp: useSpp)
    }
}

/// 运动图标
@objcMembers
public class IDOTransSportModel: IDOTransBaseModel, TransBaseModeConver {
    /// 运动模式
    /// ```
    /// | 代码 | 运动类型               |
    /// | ---- | ---------------------- |
    /// | 0x00 | 无                     |
    /// | 0x01 | 走路                   |
    /// | 0x02 | 跑步                   |
    /// | 0x03 | 骑行                   |
    /// | 0x04 | 徒步                   |
    /// | 0x05 | 游泳                   |
    /// | 0x06 | 爬山                   |
    /// | 0x07 | 羽毛球                 |
    /// | 0x08 | 其他(other)            |
    /// | 0x09 | 健身                   |
    /// | 0x0A | 动感单车               |
    /// | 0x0B | 椭圆球                 |
    /// | 0x0C | 跑步机                 |
    /// | 0x0D | 仰卧起坐               |
    /// | 0x0E | 俯卧撑                 |
    /// | 0x0F | 哑铃                   |
    /// | 0x10 | 举重                   |
    /// | 0x11 | 健身操                 |
    /// | 0x12 | 瑜伽                   |
    /// | 0x13 | 跳绳                   |
    /// | 0x14 | 乒乓球                 |
    /// | 0x15 | 篮球                   |
    /// | 0x16 | 足球                   |
    /// | 0x17 | 排球                   |
    /// | 0x18 | 网球                   |
    /// | 0x19 | 高尔夫                 |
    /// | 0x1A | 棒球                   |
    /// | 0x1B | 滑冰                   |
    /// | 0x1C | 轮滑                   |
    /// | 0x1D | 跳舞                   |
    /// | 0x1F | 滚轮训练机             |
    /// | 0x20 | 普拉提                 |
    /// | 0x21 | 交叉训练               |
    /// | 0x22 | 有氧运动               |
    /// | 0x23 | 尊巴舞                 |
    /// | 0x24 | 广场舞                 |
    /// | 0x25 | 平板支撑               |
    /// | 0x26 | 健身房                 |
    /// | 0x27 | 有氧健身操             |
    /// | 0x30 | 户外跑步               |
    /// | 0x31 | 室内跑步               |
    /// | 0x32 | 户外骑行               |
    /// | 0x33 | 室内骑行               |
    /// | 0x34 | 户外走路               |
    /// | 0x35 | 室内走路               |
    /// | 0x36 | 室内游泳(泳池游泳)     |
    /// | 0x37 | 室外游泳(开放水域游泳) |
    /// | 0x38 | 椭圆机                 |
    /// | 0x39 | 划船机                 |
    /// | 0x3A | 高强度间歇训练法       |
    /// | 0x4B | 板球运动               |
    /// | 0x64 | 自由训练               |
    /// | 0x65 | 功能性力量训练         |
    /// | 0x66 | 核心训练               |
    /// | 0x67 | 踏步机                 |
    /// | 0x68 | 整理放松               |
    /// | 0x6E | 传统力量训练           |
    /// | 0x70 | 引体向上               |
    /// | 0x72 | 开合跳                 |
    /// | 0x73 | 深蹲                   |
    /// | 0x74 | 高抬腿                 |
    /// | 0x75 | 拳击                   |
    /// | 0x76 | 杠铃                   |
    /// | 0x77 | 武术                   |
    /// | 0x78 | 太极                   |
    /// | 0x79 | 跆拳道                 |
    /// | 0x7A | 空手道                 |
    /// | 0x7B | 自由搏击               |
    /// | 0x7C | 击剑                   |
    /// | 0x7D | 射箭                   |
    /// | 0x7E | 体操                   |
    /// | 0x7F | 单杠                   |
    /// | 0x80 | 双杠                   |
    /// | 0x81 | 漫步机                 |
    /// | 0x82 | 登山机                 |
    /// | 0x83 | 保龄球                 |
    /// | 0x84 | 台球                   |
    /// | 0x85 | 曲棍球                 |
    /// | 0x86 | 橄榄球                 |
    /// | 0x87 | 壁球                   |
    /// | 0x88 | 垒球                   |
    /// | 0x89 | 手球                   |
    /// | 0x8A | 毽球                   |
    /// | 0x8B | 沙滩足球               |
    /// | 0x8C | 藤球                   |
    /// | 0x8D | 躲避球                 |
    /// | 0x98 | 街舞                   |
    /// | 0x99 | 芭蕾                   |
    /// | 0x9A | 社交舞                 |
    /// | 0x9B | 飞盘                   |
    /// | 0x9C | 飞镖                   |
    /// | 0x9D | 骑马                   |
    /// | 0x9E | 爬楼                   |
    /// | 0x9F | 放风筝                 |
    /// | 0xA0 | 钓鱼                   |
    /// | 0xA1 | 雪橇                   |
    /// | 0xA2 | 雪车                   |
    /// | 0xA3 | 单板滑雪               |
    /// | 0xA4 | 雪上运动               |
    /// | 0xA5 | 高山滑雪               |
    /// | 0xA6 | 越野滑雪               |
    /// | 0xA7 | 冰壶                   |
    /// | 0xA8 | 冰球                   |
    /// | 0xA9 | 冬季两项               |
    /// | 0xAA | 冲浪                   |
    /// | 0xAB | 帆船                   |
    /// | 0xAC | 帆板                   |
    /// | 0xAD | 皮艇                   |
    /// | 0xAE | 摩托艇                 |
    /// | 0xAF | 划艇                   |
    /// | 0xB0 | 赛艇                   |
    /// | 0xB1 | 龙舟                   |
    /// | 0xB2 | 水球                   |
    /// | 0xB3 | 漂流                   |
    /// | 0xB4 | 滑板                   |
    /// | 0xB5 | 攀岩                   |
    /// | 0xB6 | 蹦极                   |
    /// | 0xB7 | 跑酷                   |
    /// | 0xB8 | BMX                    |
    /// | 0xBB | 足排球                 |
    /// | 0xBC | 站立滑水               |
    /// | 0xBD | 越野跑                 |
    /// | 0xBE | 卷腹                   |
    /// | 0xBF | 波比跳                 |
    /// | 0xC0 | 卡巴迪                 |
    /// | 0xC1 | 户外玩耍(KR01)         |
    /// | 0xC2 | 其他运动(KR01)         |
    /// | 0xC3 | 蹦床                   |
    /// | 0xC4 | 呼啦圈                 |
    /// | 0xC5 | 赛车                   |
    /// | 0xC6 | 战绳                   |
    /// | 0xC7 | 跳伞                   |
    /// | 0xC8 | 定向越野               |
    /// | 0xC9 | 山地骑行               |
    /// | 0xCA | 沙滩网球               |
    /// | 0xCB | 智能跳绳               |
    /// | 0xCC | 匹克球                 |
    /// | 0xCD | 轮椅运动               |
    /// | 0xCE | 体能训练               |
    /// | 0xCF | 壶铃训练               |
    /// | 0xD0 | 团体操                 |
    /// | 0xD1 | Cross fit              |
    /// | 0xD2 | 障碍赛                 |
    /// | 0xD3 | 滑板车                 |
    /// | 0xD4 | 滑翔车                 |
    /// | 0xD5 | 滑雪                   |
    /// | 0xD6 | 雪板滑雪               |
    /// | 0xD7 | 搏击操                 |
    /// | 0xD8 | 剑道                   |
    /// | 0xD9 | 太极拳                 |
    /// | 0xDA | 综合格斗               |
    /// | 0xDB | 角力                   |
    /// | 0xDC | 肚皮舞                 |
    /// | 0xDD | 爵士舞                 |
    /// | 0xDE | 拉丁舞                 |
    /// | 0xDF | 踢踏舞                 |
    /// | 0xE0 | 其他舞蹈               |
    /// | 0xE1 | 沙滩排球               |
    /// | 0xE2 | 门球                   |
    /// | 0xE3 | 马球                   |
    /// | 0xE4 | 袋棍球                 |
    /// | 0xE5 | 皮划艇                 |
    /// | 0xE6 | 桨板冲浪               |
    /// | 0xE7 | 对战游戏               |
    /// | 0xE8 | 拔河                   |
    /// | 0xE9 | 秋千                   |
    /// | 0xEA | 马术运动               |
    /// | 0xEB | 田径                   |
    /// | 0xEC | 爬楼机                 |
    /// | 0xED | 柔韧训练               |
    /// | 0xEE | 国际象棋               |
    /// | 0xEF | 国际跳棋               |
    /// | 0xF0 | 围棋                   |
    /// | 0xF1 | 桥牌                   |
    /// | 0xF2 | 桌游                   |
    /// | 0xF3 | 民族舞                 |
    /// | 0xF4 | 嘻哈舞                 |
    /// | 0xF5 | 钢管舞                 |
    /// | 0xF6 | 霹雳舞                 |
    /// | 0xF7 | 现代舞                 |
    /// | 0xF8 | 泰拳                   |
    /// | 0xF9 | 柔道                   |
    /// | 0xFA | 柔术                   |
    /// | 0xFB | 回力球                 |
    /// | 0xFC | 雪地摩托               |
    /// | 0xFD | 滑翔伞                 |
    /// | 0xFE | 长曲棍球               |
    /// | 0xFF | 美式橄榄球             |
    ///  ```
    public let sportType: Int

    /// 图标类型 1:单张小运动图片 2:单张大运动图片 3:多运动动画图片 4:单张中运动图片 5:运动最小图标
    public let iconType: Int

    /// 运动图标 - 动画
    public let isSports: Bool
    
    public init(filePath: String, fileName: String, fileSize: Int = 0, sportType: Int, iconType: Int, isSports: Bool) {
        self.sportType = sportType
        self.iconType = iconType
        self.isSports = isSports
        super.init(fileType: isSports ? .sports : .sport, filePath: filePath, fileName: fileName, fileSize: fileSize)
    }
    
    func toBaseFile() -> BaseFile {
        return BaseFile(fileType: ApiTransType(rawValue: fileType.rawValue)!,
                        filePath: filePath,
                        fileName: fileName,
                        fileSize: fileSize.int64,
                        sportType: sportType.int64,
                        iconType: iconType.int64,
                        isSports: isSports)
    }
}

/// 设备文件->app传输任务
@objcMembers
public class IDODeviceFileToAppTask: NSObject {
    
//    var callbackOnProgress: ((_ progress :Double) -> Void)?
//    var callbackOnComplete: ((_ isCompleted: Bool, _ receiveFilePath: String?) -> Void)?
    
    /// 文件项实体
    public let deviceTransItem: IDODeviceTransItem
    
    init(deviceTransItem: IDODeviceTransItem) {
        self.deviceTransItem = deviceTransItem
    }
    
    /// 允许接收文件
    ///- Parameters:
    /// - onProgress: 传输进度 0 ~ 1.0
    /// - onComplete 传输结果， isCompleted，receiveFilePath 接收后的文件（isCompleted为true时有效）
    public func acceptReceiveFile(onProgress: @escaping(_ progress :Double) -> Void ,
                           onComplete: @escaping(_ isCompleted: Bool, _ receiveFilePath: String?) -> Void) {
        _delegate.callbackDeviceFileTransProgress = onProgress
        _delegate.callbackDeviceFileTransComplete = onComplete
        _runOnMainThread {
            _transer?.acceptReceiveFile(completion: { _ in })
        }
    }
    
    /// 拒绝接收文件
    public func rejectReceiveFile(completion: @escaping (Bool) -> Void) {
        _runOnMainThread {
            _transer?.rejectReceiveFile(completion: completion)
        }
    }
    
    /// APP主动停止设备传输文件到APP
    public func stopReceiveFile(completion: @escaping (Bool) -> Void) {
        _runOnMainThread {
            _transer?.stopReceiveFile(completion: completion)
        }
    }
    
}

@objcMembers
public class IDODeviceTransItem {
    
    /// 文件类型
    public let fileType: IDODeviceTransType
    
    
    /// 文件大小 单位 字节
    public let fileSize: Int
    
    
    public let fileCompressionType: Int
    
    
    /// 文件名称
    public let fileName: String
    
    /// 接收成功后的文件路径
    public let filePath: String?
    
    public init(fileType: IDODeviceTransType, fileSize: Int, fileCompressionType: Int, fileName: String, filePath: String?) {
        self.fileType = fileType
        self.fileSize = fileSize
        self.fileCompressionType = fileCompressionType
        self.fileName = fileName
        self.filePath = filePath
    }
}

/// 设备传输文件类型
@objc
public enum IDODeviceTransType: Int {
    /// 语音备忘录文件
    case voiceMemo = 0x13
    /// acc算法日志文件
    case accLog = 0x15
    /// gps算法日志文件
    case gpsLog = 0x16
}

// MARK: - Private

class TransCancellable: IDOCancellable {
    var isCancelled = false
    let token: String?
    
    init(token: String? = nil) {
        self.token = token
    }
    
    func cancel() {
        isCancelled = true
        guard token != nil else {
            return
        }
        _runOnMainThread {
            _transer?.cancelTransfer(cancelToken: CancelTransferToken(token: self.token)) {}
        }
    }
}
