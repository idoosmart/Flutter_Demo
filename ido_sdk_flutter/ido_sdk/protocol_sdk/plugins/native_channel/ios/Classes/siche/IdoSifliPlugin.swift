import Flutter
import UIKit

fileprivate var _apiSifliFlutter: ApiSifliFlutter?

public class IdoSifliPlugin: NSObject, FlutterPlugin, ApiSifliHost, IDOUpdateSFManagerDelegate {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let messenger: FlutterBinaryMessenger = registrar.messenger()
        let api: ApiSifliHost & IDOUpdateSFManagerDelegate & NSObjectProtocol = IdoSifliPlugin.init()
        IDOUpdateSFManager().configDelegate = true;
        ApiSifliHostSetup(messenger, api);
        _apiSifliFlutter = ApiSifliFlutter(binaryMessenger: messenger);
        IDOUpdateSFManager.shareInstance().delegate = api;
    }
    
    
    // MARK: ApiSifliHost
    public func startOTAFiles(_ files: [Any], deviceUUID: String, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        _log("OC startOTAFiles 99")
        IDOUpdateSFManager.shareInstance().startOTA(withFiles: files, deviceUUID: deviceUUID);
    }
    
    public func sifliEBin(fromPngPngDatas pngDatas: FlutterStandardTypedData, eColor: String, type: NSNumber, binType: NSNumber, boardType: IDOSFBoardType, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> FlutterStandardTypedData? {
        let sfData = IDOUpdateSFManager.siFliEBin(fromPngSequence: [pngDatas.data], eColor: eColor, eType: type.uint8Value, binType: binType.uint8Value, boardType: boardType);
        
        if (sfData == nil){
            return nil;
        }
        return  FlutterStandardTypedData(bytes: sfData!);
    }
    
    // MARK: IDOUpdateSFManagerDelegate
    public func updateManage(_ state: OTAUpdateState, updateDesc desc: String)  {
        _safeOnMainThread {
            _apiSifliFlutter?.updateManageStateState(state, desc: desc, completion: { num, error in })
        }
    }
    
    public func updateManagerProgress(_ progress: Float, message: String?) {
        _safeOnMainThread {
            _apiSifliFlutter?.updateManagerProgressProgress(NSNumber(value: progress), message: message ?? "message 为空", completion: { num, error in })
        }
    }
    
    public func logMessage(_ logMsg: String) {
        _log(logMsg)
    }
    
    public func startOTANorFiles(_ files: [Any], deviceUUID: String, platform: NSNumber, isIndfu: NSNumber, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        if (platform.intValue == 99) {
            startOTAFiles(files, deviceUUID: deviceUUID, error: error)
            return
        }
        _log("OC startOTANorFiles 98 \(files) \(deviceUUID)")
        IDOUpdateSFManager.shareInstance().startOTAANorV2(withFiles: files, deviceUUID: deviceUUID)
    }
    
    public func stopWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        _log("IdoSifliPlugin stop()")
        IDOUpdateSFManager.shareInstance().stop()
    }
}

// MARK: - log

extension IdoSifliPlugin {
    
   private func _safeOnMainThread(_ closure: @escaping () -> Void) {
        if Thread.isMainThread {
            closure()
        } else {
            DispatchQueue.main.async {
                closure()
            }
        }
    }
    
    private func _log(_ msg: String) {
        _safeOnMainThread {
            _apiSifliFlutter?.logLogMsg("\(msg)", completion: { _ in })
        }
    }
    
}
