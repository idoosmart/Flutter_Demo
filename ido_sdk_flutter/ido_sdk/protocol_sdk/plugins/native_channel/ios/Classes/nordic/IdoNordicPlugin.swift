import Flutter
import UIKit

fileprivate var _apiNordicFlutter: ApiNordicFlutter?

public class IdoNordicPlugin: NSObject, FlutterPlugin, ApiNordicHost, IDONordicDFUManagerDelegate {

    public static func register(with registrar: FlutterPluginRegistrar) {
        let messenger: FlutterBinaryMessenger = registrar.messenger()
        let api: ApiNordicHost & IDONordicDFUManagerDelegate & NSObjectProtocol = IdoNordicPlugin.init()
        ApiNordicHostSetup(messenger, api)
        _apiNordicFlutter = ApiNordicFlutter(binaryMessenger: messenger)
        IDONordicDFUManager.share.delegate = api
    }

    // MARK: - ApiNordicHost

    /// 开始 Nordic DFU 升级 | Start Nordic DFU upgrade
    public func startDFUDeviceIdentifier(_ deviceIdentifier: String, filePath: String, mtu: NSNumber, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        _log("startDFU deviceIdentifier: \(deviceIdentifier), filePath: \(filePath), mtu:\(mtu)")
        let url = URL(fileURLWithPath: filePath)
        IDONordicDFUManager.share.startDFU(targetIdentifier: deviceIdentifier, from: url, mtu: mtu.intValue)
    }

    /// 停止 Nordic DFU 升级 | Stop Nordic DFU upgrade
    public func stopDFUWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        _log("stopDFU")
        IDONordicDFUManager.share.stopDFU()
    }

    // MARK: - IDONordicDFUManagerDelegate

    public func upgradeDidStart() {
        _log("upgradeDidStart")
        _safeOnMainThread {
            _apiNordicFlutter?.onDFUStateChangedState(.prepare, errorMessage: "", completion: { _ in })
        }
    }

    public func upgradeDidComplete() {
        _log("upgradeDidComplete")
        _safeOnMainThread {
            _apiNordicFlutter?.onDFUStateChangedState(.completed, errorMessage: "", completion: { _ in })
        }
    }

    public func upgradeDidFail(error: Error) {
        _log("upgradeDidFail: \(error.localizedDescription)")
        _safeOnMainThread {
            _apiNordicFlutter?.onDFUStateChangedState(.failed, errorMessage: error.localizedDescription, completion: { _ in })
        }
    }

    public func upgradeDidCancel() {
        _log("upgradeDidCancel")
        _safeOnMainThread {
            _apiNordicFlutter?.onDFUStateChangedState(.cancelled, errorMessage: "", completion: { _ in })
        }
    }

    public func uploadProgressDidChange(speed: String, progress: Float, bytesSent: Int, imageSize: Int, timestamp: Date) {
        _safeOnMainThread {
            _apiNordicFlutter?.onDFUProgressProgress(NSNumber(value: Double(progress) * 100), speed: speed, completion: { _ in })
        }
    }
    
    public func nativeLog(logMsg: String) {
        _log(logMsg)
    }
}

// MARK: - Helpers

extension IdoNordicPlugin {

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
            _apiNordicFlutter?.logLogMsg("[Nordic DFU] \(msg)", completion: { _ in })
        }
    }
}
