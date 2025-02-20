// Autogenerated from Pigeon (v11.0.1), do not edit directly.
// See also: https://pub.dev/packages/pigeon

import Foundation
#if os(iOS)
import Flutter
#elseif os(macOS)
import FlutterMacOS
#else
#error("Unsupported platform.")
#endif

private func isNullish(_ value: Any?) -> Bool {
  return value is NSNull || value == nil
}

private func wrapResult(_ result: Any?) -> [Any?] {
  return [result]
}

private func wrapError(_ error: Any) -> [Any?] {
  if let flutterError = error as? FlutterError {
    return [
      flutterError.code,
      flutterError.message,
      flutterError.details
    ]
  }
  return [
    "\(error)",
    "\(type(of: error))",
    "Stacktrace: \(Thread.callStackSymbols)"
  ]
}

private func nilOrValue<T>(_ value: Any?) -> T? {
  if value is NSNull { return nil }
  return value as! T?
}
/// Generated protocol from Pigeon that represents a handler of messages from Flutter.
protocol ApiTools {
  /// 获取appName， 返回形如："VeryFit"
  func getAppName() throws -> String
  /// 获取当前时区， 返回形如："Asia/Shanghai"
  func getCurrentTimeZone() throws -> String
  /// 获取Document目录路径, 返回形如：/xx/.../
  func getDocumentPath() throws -> String?
  /// 获取平台设备信息, 返回：
  /// ```dart
  /// {
  ///   "model": "String",          手机型号
  ///   "systemVersion": "String",  系统版本
  ///   "isJailbroken": false       是否越狱
  /// }
  /// ```
  func getPlatformDeviceInfo() throws -> [AnyHashable: Any?]?
}

/// Generated setup class from Pigeon to handle messages through the `binaryMessenger`.
class ApiToolsSetup {
  /// The codec used by ApiTools.
  /// Sets up an instance of `ApiTools` to handle messages through the `binaryMessenger`.
  static func setUp(binaryMessenger: FlutterBinaryMessenger, api: ApiTools?) {
    /// 获取appName， 返回形如："VeryFit"
    let getAppNameChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.native_channel.ApiTools.getAppName", binaryMessenger: binaryMessenger)
    if let api = api {
      getAppNameChannel.setMessageHandler { _, reply in
        do {
          let result = try api.getAppName()
          reply(wrapResult(result))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      getAppNameChannel.setMessageHandler(nil)
    }
    /// 获取当前时区， 返回形如："Asia/Shanghai"
    let getCurrentTimeZoneChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.native_channel.ApiTools.getCurrentTimeZone", binaryMessenger: binaryMessenger)
    if let api = api {
      getCurrentTimeZoneChannel.setMessageHandler { _, reply in
        do {
          let result = try api.getCurrentTimeZone()
          reply(wrapResult(result))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      getCurrentTimeZoneChannel.setMessageHandler(nil)
    }
    /// 获取Document目录路径, 返回形如：/xx/.../
    let getDocumentPathChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.native_channel.ApiTools.getDocumentPath", binaryMessenger: binaryMessenger)
    if let api = api {
      getDocumentPathChannel.setMessageHandler { _, reply in
        do {
          let result = try api.getDocumentPath()
          reply(wrapResult(result))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      getDocumentPathChannel.setMessageHandler(nil)
    }
    /// 获取平台设备信息, 返回：
    /// ```dart
    /// {
    ///   "model": "String",          手机型号
    ///   "systemVersion": "String",  系统版本
    ///   "isJailbroken": false       是否越狱
    /// }
    /// ```
    let getPlatformDeviceInfoChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.native_channel.ApiTools.getPlatformDeviceInfo", binaryMessenger: binaryMessenger)
    if let api = api {
      getPlatformDeviceInfoChannel.setMessageHandler { _, reply in
        do {
          let result = try api.getPlatformDeviceInfo()
          reply(wrapResult(result))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      getPlatformDeviceInfoChannel.setMessageHandler(nil)
    }
  }
}
/// Generated class from Pigeon that represents Flutter messages that can be called from Swift.
class ToolsDelegate {
  private let binaryMessenger: FlutterBinaryMessenger
  init(binaryMessenger: FlutterBinaryMessenger){
    self.binaryMessenger = binaryMessenger
  }
  /// 获取Native日志， 返回形如："2021-06-01 10:00:00.000000000 +0800"
  func getNativeLog(msg msgArg: String, completion: @escaping () -> Void) {
    let channel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.native_channel.ToolsDelegate.getNativeLog", binaryMessenger: binaryMessenger)
    channel.sendMessage([msgArg] as [Any?]) { _ in
      completion()
    }
  }
}
