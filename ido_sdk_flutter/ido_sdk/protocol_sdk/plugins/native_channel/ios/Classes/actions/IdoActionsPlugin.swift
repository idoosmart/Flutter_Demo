import Flutter
import UIKit

fileprivate var _apiActionsFlutter: ApiActionsFlutter?

public class IdoActionsPlugin: NSObject, FlutterPlugin, ApiActionsHost, IDOActionsOTAManagerDelegate {

    public static func register(with registrar: FlutterPluginRegistrar) {
        let messenger: FlutterBinaryMessenger = registrar.messenger()
        let api: ApiActionsHost & IDOActionsOTAManagerDelegate & NSObjectProtocol = IdoActionsPlugin.init()
        ApiActionsHostSetup(messenger, api)
        _apiActionsFlutter = ApiActionsFlutter(binaryMessenger: messenger)
        IDOActionsOTAManager.share.delegate = api
    }

    // MARK: - ApiActionsHost

    /// 开始 Actions OTA 升级 | Start Actions OTA upgrade
    public func startOTADeviceIdentifier(_ deviceIdentifier: String, filePath: String, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        _log("startOTA deviceIdentifier: \(deviceIdentifier), filePath: \(filePath)")
        _safeOnMainThread {
            _apiActionsFlutter?.onOTAStateChangedState(.prepare, errorMessage: "", completion: { _ in })
        }
        IDOActionsOTAManager.share.startOTA(withTargetDeviceIdentifier: deviceIdentifier, filePath: filePath)
    }

    /// 停止 Actions OTA 升级 | Stop Actions OTA upgrade
    public func stopOTAWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        _log("stopOTA")
        // Manager.stop 在 busy 时会 notifyFail(-2006)，由 delegate 映射为 cancelled
        IDOActionsOTAManager.share.stop()
    }

    // MARK: - IDOActionsOTAManagerDelegate

    public func actionsOTADidComplete() {
        _log("actionsOTADidComplete")
        _safeOnMainThread {
            _apiActionsFlutter?.onOTAStateChangedState(.completed, errorMessage: "", completion: { _ in })
        }
    }

    public func actionsOTADidFailWithError(_ error: Error) {
        let nsError = error as NSError
        // -2006: Manager 主动终止（用户 stop）→ cancelled；其余为 failed
        let isUserStop = nsError.code == -2006
        let state: ActionsOTAState = isUserStop ? .cancelled : .failed
        _log("actionsOTADidFail code=\(nsError.code): \(error.localizedDescription)")
        _safeOnMainThread {
            _apiActionsFlutter?.onOTAStateChangedState(state, errorMessage: isUserStop ? "" : error.localizedDescription, completion: { _ in })
        }
    }

    public func actionsOTAProgressDidChange(_ progress: Float) {
        // Manager 回调为 0~1，Flutter 约定 0~100
        _safeOnMainThread {
            _apiActionsFlutter?.onOTAProgressProgress(NSNumber(value: Double(progress) * 100.0), message: "", completion: { _ in })
        }
    }

    public func actionsOTADidLog(_ message: String) {
        _log(message)
    }
}

// MARK: - Helpers

extension IdoActionsPlugin {

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
            _apiActionsFlutter?.logLogMsg("[Actions OTA] \(msg)", completion: { _ in })
        }
    }
}
