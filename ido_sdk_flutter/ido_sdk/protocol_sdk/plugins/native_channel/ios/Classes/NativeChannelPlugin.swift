import Flutter
import UIKit

public class NativeChannelPlugin: NSObject, FlutterPlugin {
    
  public static func register(with registrar: FlutterPluginRegistrar) {
      ApiGetFileInfoSetup.setUp(binaryMessenger: registrar.messenger(), api: GetFileInfoImpl.shared)
      ApiGetAppInfoSetup.setUp(binaryMessenger: registrar.messenger(), api: GetAppInfoImpl.shared)
  }

}
