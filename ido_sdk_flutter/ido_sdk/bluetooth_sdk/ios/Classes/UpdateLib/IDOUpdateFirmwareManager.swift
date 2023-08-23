//
//  IDOUpdateFirmwareManager.swift
//  flutter_bluetooth
//
//  Created by Warp on 2023/2/20.
//

import Foundation
import CoreBluetooth

class IDOUpdateFirmwareManager: NSObject {
    static let singleton = IDOUpdateFirmwareManager();
    var controller:DFUServiceController? = nil;
    let channel = SwiftFlutterBluetoothPlugin.channel

    public func startNordicDFU(manager: CBCentralManager, target: CBPeripheral?, filePath: String?) {
        guard let target = target, let filePath = filePath else{
            print("参数异常");
            return
        }

        if (!FileManager.default.fileExists(atPath: filePath)){
            print("文件不存在");
            return;
        }
        let url = URL(fileURLWithPath: filePath)

        var service = DFUServiceInitiator(centralManager: BluetoothManager.singleton.manager, target: target)
        service.forceDfu = true
        service.packetReceiptNotificationParameter = 10
        service.enableUnsafeExperimentalButtonlessServiceInSecureDfu = true
        service.logger = self
        service.delegate = self
        service.progressDelegate = self
        
        let firmware = DFUFirmware(urlToZipFile: url, type: .application)
        service = service.with(firmware: firmware!)
        self.controller = service.start()
        
    }
}

extension IDOUpdateFirmwareManager: LoggerDelegate{
    func logWith(_ level: LogLevel, message: String) {
        // print("logWith: \(level) message: \(message)")
    }
}

extension IDOUpdateFirmwareManager: DFUServiceDelegate{
    func dfuStateDidChange(to state: DFUState) {
        print("dfuStateDidChange: \(state.description())")
        switch state {
            //        case .starting:
            
            //        case .uploading:
            
        case .completed:
            self.controller = nil
            break
        default:
            break
        }
        channel?.invokeMethod(MethodChannel.dfuProgress.rawValue, arguments: ["state" : state.description()])
    }
    
    func dfuError(_ error: DFUError, didOccurWithMessage message: String) {
        print("dfuError: \(error) \(message)")
        channel?.invokeMethod(MethodChannel.dfuProgress.rawValue, arguments: ["error" : getChinessNordicDfuErrorStatus(error)])

    }
    
    func getChinessNordicDfuErrorStatus(_ error: DFUError) -> String {
        switch error {
        case .remoteLegacyDFUSuccess:
            return "远程旧版本DFU运行成功";
        case .remoteLegacyDFUInvalidState:
            return "远程旧版本DFU运行无效";
        case .remoteLegacyDFUNotSupported:
            return "远程旧版本DFU运行不被支持";
        case .remoteLegacyDFUDataExceedsLimit:
            return "远程旧版本DFU数据包超过了限额";
        case .remoteLegacyDFUCrcError:
            return "远程旧版本DFU校验错误";
        case .remoteLegacyDFUOperationFailed:
            return "远程旧版本DFU操作失败";
        case .remoteSecureDFUSuccess:
            return "远程稳定版本DFU运行成功";
        case .remoteSecureDFUOpCodeNotSupported:
            return "远程稳定版本DFU操作命令不被支持";
        case .remoteSecureDFUInvalidParameter:
            return "远程稳定版本DFU无效参数";
        case .remoteSecureDFUInsufficientResources:
            return "远程稳定版本DFU缺少资源";
        case .remoteSecureDFUInvalidObject:
            return "远程稳定版本DFU无效对象";
        case .remoteSecureDFUSignatureMismatch:
            return "远程稳定版本DFU签名不匹配";
        case .remoteSecureDFUUnsupportedType:
            return "远程稳定版本DFU不支持的类型";
        case .remoteSecureDFUOperationNotpermitted:
            return "远程稳定版本DFU操作不允许";
        case .remoteSecureDFUOperationFailed:
            return "远程稳定版本DFU操作失败";
        case .fileNotSpecified:
            return "文件没有详细说明";
        case .fileInvalid:
            return "文件无效的";
        case .extendedInitPacketRequired:
            return "必须扩展初始化固件包";
        case .failedToConnect:
            return "连接失败";
        case .deviceDisconnected:
            return "手环设备断开";
        case .bluetoothDisabled:
            return "关闭系统蓝牙";
        case .serviceDiscoveryFailed:
            return "发现服务失败";
        case .deviceNotSupported:
            return "设备不支持DFU功能";
        case .readingVersionFailed:
            return "固件包读取版本号失败";
        case .enablingControlPointFailed:
            return "授权控制点失败";
        case .writingCharacteristicFailed:
            return "正在写特征失败";
        case .receivingNotificationFailed:
            return "接受通知失败";
        case .unsupportedResponse:
            return "不支持无效响应";
        case .bytesLost:
            return "丢失字节";
        case .crcError:
            return "校验失败";
        default:
            return "DFU升级失败";
        }
    }

    
}

extension IDOUpdateFirmwareManager: DFUProgressDelegate{
    func dfuProgressDidChange(for part: Int, outOf totalParts: Int, to progress: Int, currentSpeedBytesPerSecond: Double, avgSpeedBytesPerSecond: Double) {
//        print("dfuProgressDidChange part: \(part)\n totalParts: \(totalParts)\n progress: \(progress)\n currentSpeedBytesPerSecond: \(currentSpeedBytesPerSecond)\n avgSpeedBytesPerSecond: \(avgSpeedBytesPerSecond) ");
        
        channel?.invokeMethod(MethodChannel.dfuProgress.rawValue, arguments: ["progress" : progress])
    }
    

    
    
}
