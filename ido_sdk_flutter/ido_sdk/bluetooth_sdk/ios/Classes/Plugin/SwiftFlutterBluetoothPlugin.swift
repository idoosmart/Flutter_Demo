import Flutter
import UIKit

public class SwiftFlutterBluetoothPlugin: NSObject, FlutterPlugin {
    static let instance = SwiftFlutterBluetoothPlugin()
    static var channel: FlutterMethodChannel?
    static var eventChannel: FlutterEventChannel?
    var eventSink: FlutterEventSink?
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        channel = FlutterMethodChannel(name: "flutter_bluetooth_IDO", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: channel!)
        
        eventChannel = FlutterEventChannel.init(name: "bluetoothState", binaryMessenger: registrar.messenger())
        eventChannel?.setStreamHandler(instance)
        
        let manager = BluetoothManager.singleton.manager;
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let method = MethodChannel.init(rawValue: call.method)
        switch method{
        case .getPlatformVersion:
            result("iOS " + UIDevice.current.systemVersion)
        case .startScan:
            writeLog("channel startScan");
            BluetoothManager.singleton.scan()
        case .stopScan:
            writeLog("channel stopScan");
            BluetoothManager.singleton.stopScan()
        case .connect:
            guard let arg = call.arguments as? Dictionary<String, Any>, let device = arg.toModel(Device.self)  else {
                writeLog("connect error format" + String(describing: call.arguments))
                return
            }
            writeLog("channel connect");
            BluetoothManager.singleton.getCharacteristics(dict: arg)
            BluetoothManager.singleton.connect(device)
        case .cancelConnect:
            guard let arg = call.arguments as? Dictionary<String, Any>, let device = arg.toModel(Device.self)  else {
                writeLog("cancelConnect error format " + String(describing: call.arguments))
                return
            }
            writeLog("channel cancelConnect");
            BluetoothManager.singleton.cancelConnect(device)
        case .state:
            let state = ["state" : NSNumber(value: BluetoothManager.singleton.manager.state.rawValue), "scanType" : NSNumber(value: BluetoothManager.singleton.manager.isScanning ? 0 : 1)]
            result(state)
            writeLog("channel state = " + String(describing: state));
        case .getDeviceState:
            guard let arg = call.arguments as? [String: AnyObject], let device = arg.toModel(Device.self)  else {
                writeLog("getDeviceState error format " + String(describing: call.arguments))
                return
            }
            let state = ["state" : NSNumber(value: BluetoothManager.singleton.deviceState(device).rawValue)]
            result(state)
            writeLog("channel getDeviceState =" + String(describing: state));
        case .sendData:
            guard let arg = call.arguments as?  Dictionary<String, Any>  else {
                writeLog("sendData sendData error format " + String(describing: call.arguments))
                return
            }
            let message = WriteMessage.init(dict: arg)
            BluetoothManager.singleton.write(message)
        case .requestMacAddress:
            if let arg = call.arguments as? Dictionary<String,Any>, let uuid = arg["uuid"] as? String , let macAddress = arg["macAddress"] as? String{
                BluetoothManager.singleton.requestMacAddress(uuid: uuid, macAddress: macAddress)
            }
            writeLog("channel requestMacAddress");
        case .startNordicDFU:
            if let arg = call.arguments as? Dictionary<String,Any>, let filePath = arg["filePath"] as? String , let uuid = arg["uuid"] as? String{
                
                IDOUpdateFirmwareManager.singleton.startNordicDFU(manager: BluetoothManager.singleton.manager, target: BluetoothManager.singleton.peripheralDic[uuid] , filePath: filePath)
            }
            writeLog("channel startNordicDFU");
        default:
            writeLog("Undefined method  " + call.method)
        }
    }
    
    //    写日志
    func writeLog(_ detail: String){
        let json: [String : Any] = [
            "platform" : 1, //1 ios  2 android 3 flutter;
            "className" : "SwiftFlutterBluetoothPlugin",
            "method" : "handle",
            "detail" : detail,]
        SwiftFlutterBluetoothPlugin.channel?.invokeMethod(MethodChannel.writeLog.rawValue, arguments: json);
    }
}


extension SwiftFlutterBluetoothPlugin: FlutterStreamHandler{
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
}
