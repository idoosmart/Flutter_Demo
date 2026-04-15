class BluetoothDelegateImpl: BluetoothDelegate {
    
    var callbackDeviceBleModel: ((DeviceModel) -> Void)?
    private var _deviceBleModel: DeviceModel?
    private var _lastDeviceStateModel: IDODeviceStateModel?
    private var _lastBluetoothStateModel: IDOBluetoothStateModel?
    static let shared = BluetoothDelegateImpl()
    
    weak var delegate: IDOBleDelegate?
    weak var delegateDfu: IDODfuDelegate?
    
    private init() {}
    func onCurrentDeviceAttrValChange(device: DeviceModel) throws {
        _deviceBleModel = device
        callbackDeviceBleModel?(_deviceBleModel!)
    }
    
    func changeCurrentDevice(device: DeviceModel) throws {
        _deviceBleModel = device
        callbackDeviceBleModel?(_deviceBleModel!)
    }
    
    func writeState(state: WriteStateModel) throws {
        //delegate?.writeState(state: state.toWriteStateModel())
    }
    
    func receiveData(data: ReceiveData) throws {
        delegate?.receiveData(data: data.toReceiveData())
    }
    
    func scanResult(list: [DeviceModel]?) throws {
        guard let items = list else {
            delegate?.scanResult(list: nil)
            return
        }
        let rsList = items.map { $0.toIDODeviceModel() }
        delegate?.scanResult(list: rsList)
    }
    
    func bluetoothState(state: BluetoothStateModel) throws {
        _lastBluetoothStateModel = state.toIDOBluetoothStateModel()
        delegate?.bluetoothState(state: _lastBluetoothStateModel!)
        if (_lastDeviceStateModel != nil && state.type == .poweredOff) {
            _lastDeviceStateModel?.state = .disconnected
            _lastDeviceStateModel?.errorState = .bluetoothOff
            delegate?.deviceState(state: _lastDeviceStateModel!)
        }
    }
    
    func deviceState(state: DeviceStateModel) throws {
        //_logNative("调用到 swift deviceState: \(state.state) delegate:\(delegate)")
        if (_lastDeviceStateModel == nil) {
            _lastDeviceStateModel = state.toDeviceStateModel()
        }
        _lastDeviceStateModel?.uuid = state.uuid
        _lastDeviceStateModel?.macAddress = state.macAddress
        _lastDeviceStateModel?.state = IDODeviceStateType(rawValue: state.state!.rawValue)!
        if (_lastBluetoothStateModel?.type != .poweredOff) {
            _lastDeviceStateModel?.errorState = IDOConnectErrorType(rawValue: state.errorState!.rawValue)!
        }
        delegate?.deviceState(state: _lastDeviceStateModel!)
    }
    
    func stateSPP(state: SPPStateModel) throws { }
    
    func writeSPPCompleteState(btMacAddress: String) throws { }
    
    func dfuComplete() throws {
        delegateDfu?.dfuComplete()
    }
    
    func dfuError(error: String) throws {
        delegateDfu?.dfuError(error: error)
    }
    
    func dfuProgress(progress: Int64) throws {
        delegateDfu?.dfuProgress(progress: Int(progress))
    }

    // ios使用不到
    func stateBt(isPair: Bool) throws { }
}


// MARK: -

extension IDODfuConfig {
    func toDfuConfig() -> DfuConfig {
        return DfuConfig(
            filePath: filePath,
            uuid: uuid,
            macAddress: macAddress,
            deviceId: deviceId,
            platform: platform.int64,
            isDeviceSupportPairedWithPhoneSystem: isDeviceSupportPairedWithPhoneSystem,
            prn: prn.int64,
            isNeedReOpenBluetoothSwitchIfFailed: isNeedReOpenBluetoothSwitchIfFailed,
            maxRetryTime: maxRetryTime.int64,
            isNeedAuth: isNeedAuth,
            otaWorkMode: otaWorkMode.int64
        )
    }
}

extension SPPStateModel {
    func toSPPStateModel() -> IDOSppStateModel {
        let _type = IDOSppStateType(rawValue: type!.rawValue)!
        return IDOSppStateModel(type: _type)
    }
}

extension DeviceStateModel {
    func toDeviceStateModel() -> IDODeviceStateModel {
        let errorState = IDOConnectErrorType(rawValue: errorState!.rawValue)!
        let _state = IDODeviceStateType(rawValue: state!.rawValue)!
        return IDODeviceStateModel(uuid: uuid, macAddress: macAddress, state: _state, errorState: errorState)
    }
}

extension BluetoothStateModel {
    func toIDOBluetoothStateModel() -> IDOBluetoothStateModel {
        var _type: IDOBluetoothStateType = .unknown
        if (type != nil) {
            _type = IDOBluetoothStateType(rawValue: type!.rawValue)!
        }
        var _scanType: IDOBluetoothScanType = .stop
        if (scanType != nil) {
            _scanType = IDOBluetoothScanType(rawValue: scanType!.rawValue)!
        }
        return IDOBluetoothStateModel(type: _type, scanType: _scanType)
    }
}

// extension IDOBluetoothStateModel {
//    func toBluetoothStateModel() -> BluetoothStateModel {
//        let type = BluetoothStateType(rawValue: type!.rawValue)
//        return BluetoothStateModel(type: type)
//    }
// }

extension ReceiveData {
    func toReceiveData() -> IDOReceiveData {
        return IDOReceiveData(data: data?.data, uuid: uuid, macAddress: macAddress, spp: spp ?? false, platform: platform?.int ?? 0)
    }
}

extension WriteStateModel {
    func toWriteStateModel() -> IDOWriteStateModel {
        let _type = IDOWriteType(rawValue: type!.rawValue)!
        return IDOWriteStateModel(state: state ?? false, uuid: uuid, macAddress: macAddress, type: _type)
    }
}

extension DeviceModel {
    func toIDODeviceModel() -> IDODeviceModel {
        let _state = IDODeviceStateType(rawValue: state!.rawValue)!
        return IDODeviceModel(rssi: rssi?.int ?? 0,
                              name: name,
                              state: _state,
                              uuid: uuid,
                              macAddress: macAddress,
                              otaMacAddress: otaMacAddress,
                              btMacAddress: btMacAddress,
                              deviceId: deviceId?.int ?? 0,
                              deviceType: deviceType?.int ?? 0,
                              isOta: isOta ?? false,
                              isTlwOta: isTlwOta ?? false,
                              bltVersion: bltVersion?.int ?? 0,
                              isPair: isPair ?? false,
                              platform: platform?.int ?? 0)
    }
}

extension IDODeviceModel {
    func toDeviceModel() -> DeviceModel {
        let _state = DeviceStateType(rawValue: state.rawValue)
        return DeviceModel(rssi: rssi.int64,
                           name: name,
                           state: _state,
                           uuid: uuid,
                           macAddress: macAddress,
                           otaMacAddress: otaMacAddress,
                           btMacAddress: btMacAddress,
                           deviceId: deviceId.int64,
                           deviceType: deviceType.int64,
                           isOta: isOta,
                           isTlwOta: isTlwOta,
                           bltVersion: bltVersion.int64,
                           isPair: isPair,
                           platform: platform.int64)
    }
}
