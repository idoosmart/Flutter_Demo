//
//  SFOTAError.swift
//  SifliOTAManagerSDK
//
//  Created by 秦晟哲 on 2023/2/14.
//

import UIKit


///SFOTAErrorType
@objc public enum SFOTAErrorType:Int {
    
    // 与QError保持一致
    case Unknown = 0
    case ConnectTimeout
    case ConnectionCanceled
    case Disconnected
    case FailedToConnect
    
    
    /// SFOTAError特有
    case General
    ///蓝牙设备搜索超时
    case SearchTimeout
    ///任务请求超时
    case RequestTimeout
    ///Nand加载资源失败
    case LoadResourceZipFailed
    ///加载控制文件失败
    case LoadControlFileFailed
    ///加载Image文件失败
    case LoadImageFileFailed
    ///设备返回错误码
    ///OTA_UI_NOT_SUPPORT= 65
    ///OTA_VERSION_INVALID= 66
    ///OTA_FAT_OUT_OF_FREE_SPACE= 67
    ///OTA_TOTAL_SIZE_NOT_ALIGNED= 68
    ///OTA_FILE_SIZE_NOT_ALIGNED =69
    ///OTA_MKDIR_ERR =70
    ///OTA_SWITCH_DIR_ERR =71
    ///OTA_FILE_OPEN_ERR=72
    ///OTA_FILE_CLOSE_ERR=73
    ///OTA_FILE_SIZE_ERR=74
    ///OTA_FILE_CRC_ERR=75
    ///OTA_FILE_WRITE_ERR=76
    ///OTA_FILE_RECV_NUM_ERR=77
    ///OTA_USER_REFUSE=78
    ///OTA_LOW_BATTERY=79
    ///OTA_RENAME_ERROR=80
    ///OTA_IMG_INSTALL_ERROR=81
    case ErrorCodeFromDevice
    ///解析响应数据长度不足
    case InsufficientBytes
    ///蓝牙不可用
    case UnavailableBleStatus
    ///输入参数无效
    case InvalidParams
    ///在切片数量之外尝试无响应发送
    case SendNoRspPacketOutSliceRange
    ///发送的固件文件超过了协议设计范围
    case FileTooLarge
}

@objc public class SFOTAError: NSObject {
    
    @objc public let errorType:SFOTAErrorType
    
    @objc public let errorDes:String
    
    init(qError:QError) {
        switch qError.errType {
        case .Unknown:
            self.errorType = .Unknown
        case .Timeout:
            self.errorType = .ConnectTimeout
        case .Canceled:
            self.errorType = .ConnectionCanceled
        case .Disconnected:
            self.errorType = .Disconnected
        case .FailedToConnect:
            self.errorType = .FailedToConnect
        }
        self.errorDes = qError.errInfo
        super.init()
    }
    
    init(errorType:SFOTAErrorType, errorDes:String) {
        self.errorType = errorType
        self.errorDes = errorDes
        super.init()
    }
    
    static func InsufficientBytes(expectCount:Int, actualCount:Int) -> SFOTAError {
        let error = SFOTAError.init(errorType: .InsufficientBytes, errorDes: "Expect '\(expectCount)' bytes, but get '\(actualCount)'")
        return error
    }
    
    static func DevErrorCode(errorCode:Int) -> SFOTAError {
        let error = SFOTAError.init(errorType: .ErrorCodeFromDevice, errorDes: "Device Reponse Error Code:\(errorCode)")
        return error
    }
    
    public override var debugDescription: String {
        return "errorType=\(errorType), errorDes=\(errorDes)"
    }
}
