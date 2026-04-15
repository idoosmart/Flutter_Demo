import Flutter

public let sdk: IDOSdkInterface = IDOSDK.shared

@objcMembers
public class SwiftProtocolChannelPlugin: NSObject, FlutterPlugin {
    public static let shared = SwiftProtocolChannelPlugin()
    override private init() {}
    
    private(set) var alexa: Alexa?
    private(set) var tools: Tool?
    private(set) var bridge: Bridge?
    private(set) var bind: Bind?
    private(set) var cache: Cache?
    private(set) var cmd: Cmd?
    private(set) var syncData: SyncData?
    private(set) var device: Device?
    private(set) var deviceLog: DeviceLog?
    private(set) var fileTransfer: FileTransfer?
    private(set) var funcTable: FuncTable?
    private(set) var messageIcon: MessageIcon?
    private(set) var ble: Bluetooth?
    private(set) var exchangeData: ApiExchangeData?
    private(set) var epo: ApiEPOManager?
    private(set) var measure: Measure?
    
    private(set) var verInfo: VersionInfo?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let messenger = registrar.messenger()
        
        shared.alexa = Alexa(binaryMessenger: messenger)
        shared.tools = Tool(binaryMessenger: messenger)
        shared.bridge = Bridge(binaryMessenger: messenger)
        shared.bind = Bind(binaryMessenger: messenger)
        shared.cache = Cache(binaryMessenger: messenger)
        shared.cmd = Cmd(binaryMessenger: messenger)
        shared.syncData = SyncData(binaryMessenger: messenger)
        shared.device = Device(binaryMessenger: messenger)
        shared.deviceLog = DeviceLog(binaryMessenger: messenger)
        shared.fileTransfer = FileTransfer(binaryMessenger: messenger)
        shared.funcTable = FuncTable(binaryMessenger: messenger)
        shared.messageIcon = MessageIcon(binaryMessenger: messenger)
        shared.ble = Bluetooth(binaryMessenger: messenger)
        shared.exchangeData = ApiExchangeData(binaryMessenger: messenger)
        shared.epo = ApiEPOManager(binaryMessenger: messenger)
        shared.measure = Measure(binaryMessenger: messenger)
        
        BluetoothDelegateSetup.setUp(binaryMessenger: messenger, api: BluetoothDelegateImpl.shared)
        AlexaAuthDelegateSetup.setUp(binaryMessenger: messenger, api: AlexaAuthDelegateImpl.shared)
        BridgeDelegateSetup.setUp(binaryMessenger: messenger, api: BridgeDelegateImpl.shared)
        FileTransferDelegateSetup.setUp(binaryMessenger: messenger, api: FileTransferDelegateImpl.shared)
        SyncDataDelegateSetup.setUp(binaryMessenger: messenger, api: SyncDataDelegateImpl.shared)
        DeviceDelegateSetup.setUp(binaryMessenger: messenger, api: DeviceDelegateImpl.shared)
        FuncTableDelegateSetup.setUp(binaryMessenger: messenger, api: FuncTableDelegateImpl.shared)
        MessageIconDelegateSetup.setUp(binaryMessenger: messenger, api: MessageIconDelegateImpl.shared)
        DeviceLogDelegateSetup.setUp(binaryMessenger: messenger, api: DeviceLogDelegateImpl.shared)
        ApiExchangeDataDelegateSetup.setUp(binaryMessenger: messenger, api: ExchangeDataOCDelegateImpl.shared)
        ApiEpoManagerDelegateSetup.setUp(binaryMessenger: messenger, api: EpoManagerDelegateImpl.shared)
        MeasureDelegateSetup.setUp(binaryMessenger: messenger, api: MeasureDelegateImpl.shared)
        
        shared.tools?.getSDKVersionInfo(completion: { verInfo in
            shared.verInfo = verInfo
        })
    }
}
