import Flutter
import UIKit

public class NativeChannelPlugin: NSObject, FlutterPlugin {
    
  public static let shared = NativeChannelPlugin()
  override private init() {}
    
  private(set) var tools: ToolsDelegate?
    
  public static func register(with registrar: FlutterPluginRegistrar) {
      shared.tools = ToolsDelegate(binaryMessenger: registrar.messenger())
      ApiGetFileInfoSetup.setUp(binaryMessenger: registrar.messenger(), api: GetFileInfoImpl.shared)
      ApiGetAppInfoSetup.setUp(binaryMessenger: registrar.messenger(), api: GetAppInfoImpl.shared)
      ApiToolsSetup.setUp(binaryMessenger: registrar.messenger(), api: ApiToolsImpl.shared)
      AlexaChannelImpl.sharedInstance().alexaFlutter = ApiAlexaFlutter(binaryMessenger: registrar.messenger())
      ApiAlexaHostSetup(registrar.messenger(), AlexaChannelImpl.sharedInstance());
      IdoSifliPlugin.register(with: registrar)
  }
    
}
