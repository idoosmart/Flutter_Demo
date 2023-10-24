// Autogenerated from Pigeon (v10.1.6), do not edit directly.
// See also: https://pub.dev/packages/pigeon

import Foundation
#if os(iOS)
import Flutter
#elseif os(macOS)
import FlutterMacOS
#else
#error("Unsupported platform.")
#endif

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
protocol ApiGetFileInfo {
  /// 读取文件信息
  func readFileInfo(path: String, completion: @escaping (Result<[AnyHashable: Any?]?, Error>) -> Void)
}

/// Generated setup class from Pigeon to handle messages through the `binaryMessenger`.
class ApiGetFileInfoSetup {
  /// The codec used by ApiGetFileInfo.
  /// Sets up an instance of `ApiGetFileInfo` to handle messages through the `binaryMessenger`.
  static func setUp(binaryMessenger: FlutterBinaryMessenger, api: ApiGetFileInfo?) {
    /// 读取文件信息
    let readFileInfoChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.native_channel.ApiGetFileInfo.readFileInfo", binaryMessenger: binaryMessenger)
    if let api = api {
      readFileInfoChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let pathArg = args[0] as! String
        api.readFileInfo(path: pathArg) { result in
          switch result {
            case .success(let res):
              reply(wrapResult(res))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      readFileInfoChannel.setMessageHandler(nil)
    }
  }
}