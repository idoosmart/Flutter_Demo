part of '../ido_bluetooth_manager.dart';

class _IDOBluetoothManager
    with
        IDOBluetoothStateMixin,
        IDOBluetoothCommendMixin,
        IDOBluetoothTimeoutMixin
    implements IDOBluetoothManager {
  _IDOBluetoothManager._privateConstructor();
  static final _IDOBluetoothManager _instance =
      _IDOBluetoothManager._privateConstructor();
  factory _IDOBluetoothManager() => _instance;

  final _channel = IDOBluetoothChannel();
  final _heartPing = IDOBluetoothHeartPing();

  //最后一次连接设备
  @override
  IDOBluetoothDeviceModel? currentDevice;

  //是否需要连接
  bool _isNeedConnect = false;

  //绑定状态，外部同步过来,如果标记为绑定状态会启用重连设备流程
  // bool isBind = false;

  //发送错误次数
  int _sendErrorCount = 0;

  //绑定状态，外部同步过来,如果标记为绑定状态会启用重连设备流程
  bool isAutoConnect = false;

  ///写数据状态
  IDOBluetoothWriteType _writeType = IDOBluetoothWriteType.error;

  /// 监听当前设备
  final _deviceSubject = PublishSubject<IDOBluetoothDeviceModel>();

  /// 搜索筛选条件
  List<String>? _deviceNames;
  List<int>? _deviceIDs;
  List<String>? _macAddresss;
  List<String>? _uuids;

  //注册,程序开始运行调用
  //heartPingSecond:心跳包间隔(ios)
  //outputToConsole：输出日志
  @override
  register({int heartPingSecond = 25, bool outputToConsole = false}) async{
    //日志
    await _registerLog();
    //通道
    _channel.callHandle();
    _channel.bluetoothState();
    if (Platform.isIOS) {
      _heartPing.startHeartPing(heartPingSecond: heartPingSecond);
    }
    getBluetoothState();
    //监听状态
    bluetoothState().listen((event) => _listenBlueState(event));
    _channel.deviceStateSubject.listen((event) => _listenDeviceState(event));
    receiveData().listen((event) => _listenReceiveData(event));
    _scanResult().listen((event) => _listenScanResult(event));
    addLog('bluetoothSDK register version = ${getSdkVersion()}', method: 'register');
  }

  _registerLog({bool outputToConsole = false}) async{
    await IDOBluetoothLogger().register(outputToConsole: outputToConsole);
    _channel.logStateSubject
        .listen((value) => IDOBluetoothLogger().writeLog(value));
  }

  ///监听搜索
  _listenScanResult(List<IDOBluetoothDeviceModel> event) {
    if (_isNeedConnect) {
      for (var element in event) {
        if ((element.uuid == currentDevice?.uuid && Platform.isIOS) ||
            IDOBluetoothTool.nearMacAddressCompare(element.macAddress)) {
          // print('_isNeedConnect find ${element.macAddress}');
          element.isNeedGetMacAddress =
              currentDevice?.isNeedGetMacAddress ?? true;
          addLog(
              '_isNeedConnect macAddress = ${element.macAddress},name = '
              '${element.name}',
              method: '_listenScanResult');
          currentDevice = element;
          _channel.connect(element);
          _channel.stopScan();
          _isNeedConnect = false;
          cancelAllTimeout();
          addConnectTimeout();
          break;
        }
      }
    }
  }

  //监听收数据
  _listenReceiveData(IDOBluetoothReceiveData dataModel) {
    var data = dataModel.data ??= Uint8List.fromList([]);
    //心跳包
    _heartPing.pauseHeartPing(data);

    // print("ReceiveData = $data");
    if (Platform.isAndroid) {
      return;
    }

    _analysisMacAddress(data);
  }

  //监听蓝牙状态
  _listenBlueState(IDOBluetoothStateModel event) {
    addLog(
        'listen bluetoothState = ${event.state} ， isConnected = $isConnected , '
        'isAutoConnect = $isAutoConnect',
        method: '_listenBlueState');
    // currentDevice?.isBind = true;
    if (event.state == IDOBluetoothStateType.poweredOn &&
        !isConnected &&
        isAutoConnect) {
      needReconnect(isDueToPhoneBluetoothSwitch: true);
    } else if (event.state == IDOBluetoothStateType.poweredOff) {
      stopScan();
      currentDevice?.state = IDOBluetoothDeviceStateType.disconnected;
    }
    _deviceSubject.add(currentDevice ?? IDOBluetoothDeviceModel());
  }

  //监听设备状态
  _listenDeviceState(IDOBluetoothDeviceStateModel event) {
    addLog(
        '_listenDeviceState，macAddress = ${event.macAddress},currentDevice?.macAddress = ${currentDevice?.macAddress}'
        'errorState = '
        '${event.errorState.toString()} isOTA = $isOTA , isAutoConnect = $isAutoConnect, '
        'isNeedGetMacAddress = '
        '${currentDevice?.isNeedGetMacAddress},state = ${event.state}',
        method: '_listenDeviceState');
    if (event.macAddress != currentDevice?.macAddress) {
      return;
    }
    currentDevice?.state = event.state;
    if (event.state == IDOBluetoothDeviceStateType.connected ||
        event.state == IDOBluetoothDeviceStateType.disconnected) {
      cancelConnectTimeout();
    }

    //获取MAC地址
    if (event.state == IDOBluetoothDeviceStateType.connected) {
      // currentDevice?.isConnect = true;
      //连接成功复位写入数据次数
      _sendErrorCount = 0;
    } else if (event.state == IDOBluetoothDeviceStateType.disconnected) {
      // currentDevice?.isConnect = false;
      //重连
      needReconnect();
    }

    ///ios获取Mac地址
    if (event.state == IDOBluetoothDeviceStateType.connected &&
        isOTA == false &&
        isAutoConnect == false &&
        Platform.isIOS &&
        currentDevice != null &&
        currentDevice!.isNeedGetMacAddress) {
      _getMacAddress();
    }
  }

  _analysisMacAddress(Uint8List data) {
    //首次连接解析Mac地址
    if ((currentDevice != null && currentDevice!.isNeedGetMacAddress) ||
        ((isOpenPairCommend(data) || isGetPairCommend(data)) &&
            _channel.isPairList.isNotEmpty)) {
      //解析
      getCommendHandler().handleRequest(data);
      if (isGetPairCommend(data) && _channel.isPairList.isNotEmpty) {
        //完成获取配对状态completer
        cancelOpenPairTimeOut();
        _channel.isPairList.forEach((element) => element.complete(
            currentDevice!.isPair
                ? IDOBluetoothPairType.succeed
                : IDOBluetoothPairType.cancel));
        _channel.isPairList.clear();
      }
      _deviceSubject.add(currentDevice ?? IDOBluetoothDeviceModel());
    }
  }

  //获取Mac地址
  _getMacAddress() {
    getCommendHandler().handleRequest(getMacAddressCommend);
    addCommendTimeout();
  }

  //重连
  needReconnect({bool isDueToPhoneBluetoothSwitch = false}) async {
    final powerState = await poweredOn;
    addLog(
        'NeedReconnect isAutoConnect = $isAutoConnect,isConnected = $isConnected,'
        'powerState = $powerState',
        method: '_needReconnect');
    //只要绑定就重连
    if (isAutoConnect && !isConnected && powerState && currentDevice != null) {
      addLog('startReconnect macAddress = ${currentDevice!.macAddress}',
          method: '_needReconnect');
      cancelAllTimeout();
      if (Platform.isIOS) {
        _isNeedConnect = true;
        stopScan();
        await _addScanInterval();
      } else {
        autoConnectAndroid(
            device: currentDevice,
            isDueToPhoneBluetoothSwitch: isDueToPhoneBluetoothSwitch);
      }
    }
  }

  //开始搜索
  //macAddress（Android）:根据Mac地址搜索
  //返回指定搜索的设备，如未指定返回null
  static int rescanCount = 0;
  @override
  Future<List<IDOBluetoothDeviceModel>?> startScan([String? macAddress]) async {
    final state = await getBluetoothState();
    if (await poweredOn) {
      stopScan();
      _channel.deviceMap.clear();
      _channel.startScan(macAddress);
      addLog('--- startScan $macAddress', method: 'startScan');
      rescanCount = 0;
    } else if (!await authorized || state == IDOBluetoothStateType.unknown) {
      if (rescanCount > 3) {
        return null;
      }
      addLog('startScan unauthorized', method: 'startScan');
      Future.delayed(const Duration(seconds: 1), () {
        startScan(macAddress);
        rescanCount++;
      });
    } else {
      rescanCount = 0;
      addLog('startScan waitting,BluetoothState = $state', method: 'startScan');
    }
    if (macAddress == null) {
      return null;
    }
    final device = _channel.scanSubject.firstWhere((event) {
      final result = event.where((element) => element.macAddress == macAddress);
      return result.isNotEmpty;
    }).timeout(const Duration(seconds: 60));
    return device;
  }

  _addScanInterval() async {
    addScanIntervalTimeOut(() {
      _addScanInterval();
    });
    final type = await _getScanState();
    if (type == IDOBluetoothScanType.scanning) {
      addLog('_addScanInterval stopScan', method: '_addScanInterval');
      _channel.stopScan();
    } else if (type == IDOBluetoothScanType.stop) {
      addLog('_addScanInterval startScan', method: '_addScanInterval');
      _channel.startScan();
    } else {
      addLog('_addScanInterval cancelAllTimeout', method: '_addScanInterval');
      cancelAllTimeout();
    }
  }

  //停止搜索
  @override
  stopScan() {
    cancelScanIntervalTimeOut();
    // _channel.deviceMap.clear();
    _channel.stopScan();
    addLog('stopScan', method: 'stopScan');
  }

  //连接
  @override
  connect(IDOBluetoothDeviceModel? device) async {
    if (device == null) {
      addLog('connect null device', method: 'connect');
      return;
    }
    cancelAllTimeout();
    addConnectTimeout();
    addLog('开始连接start connect ${device.macAddress} name = ${device.name},',
        method: 'connect');
    //先断链上个设备
    IDOBluetoothDeviceModel? lastDevice = currentDevice;
    IDOBluetoothDeviceStateType lastState = await getDeviceState(lastDevice);
    if (lastDevice != null &&
        lastDevice.macAddress != device.macAddress &&
        (lastState == IDOBluetoothDeviceStateType.connected ||
            lastState == IDOBluetoothDeviceStateType.connecting)) {
      addLog('先断链上个设备  ${lastDevice.macAddress}', method: 'connect');
      cancelConnect(macAddress: lastDevice.macAddress);
      //等待上个设备断链
      await deviceState()
          .where((event) =>
              event.state == IDOBluetoothDeviceStateType.disconnected &&
              (event.macAddress == lastDevice.macAddress ||
                  (event.uuid == lastDevice.uuid && Platform.isIOS)))
          .first;
    }
    stopScan();
    currentDevice = device;
    _deviceSubject.add(currentDevice!);
    final key = device.toMap()[deviceMapKey];
    final findDevice = _channel.allDeviceMap[key];
    if (Platform.isIOS) {
      if (findDevice != null) {
        currentDevice = findDevice;
        _channel.connect(device);
      } else {
        _isNeedConnect = true;
        startScan(device.macAddress);
      }
    } else {
      _channel.connect(device);
    }
    addLog(
        'start connect ${device.macAddress} name = ${device.name},'
        'findDevice = ${findDevice?.name},key = $key',
        method: 'connect');
  }

  //取消连接
  @override
  Future<bool> cancelConnect({String? macAddress}) async {
    macAddress ??= currentDevice?.macAddress;
    addLog('cancelConnect = ${macAddress}', method: 'cancelConnect');
    if (macAddress == null) {
      return true;
    } else {
      _channel.cancelConnect(macAddress);
      if (currentDevice?.macAddress == macAddress) {
        currentDevice = null;
      }
      cancelAllTimeout();
    }
    return deviceState()
        .map((event) =>
            event.state == IDOBluetoothDeviceStateType.disconnected &&
            event.errorState ==
                IDOBluetoothDeviceConnectErrorType.connectCancel)
        .firstWhere((disconnected) => disconnected, orElse: () => true)
        .timeout(const Duration(seconds: 5), onTimeout: () => true);
  }

  //设备上报到keychain存储（ios）
  @override
  requestMacAddress(IDOBluetoothDeviceModel? device) {
    if (device != null && Platform.isIOS) {
      _channel.requestMacAddress(device);
      addLog('requestMacAddress', method: 'requestMacAddress');
    }
  }

  //获取蓝牙状态
  @override
  Future<IDOBluetoothStateType> getBluetoothState() async {
    final value = await _channel.state();
    final json = value ?? {};
    final stateValue = IDOBluetoothStateModel.fromMap(json);
    // addLog('getBluetoothState = ${stateValue.state}',
    //     method: 'getBluetoothState');
    return stateValue.state;
  }

  //获取扫描状态
  Future<IDOBluetoothScanType> _getScanState() async {
    final value = await _channel.state();
    final json = value ?? {};
    final stateValue = IDOBluetoothStateModel.fromMap(json);
    addLog('_getScanState = ${stateValue.scanType}', method: '_getScanState');
    return stateValue.scanType;
  }

  //获取设备连接状态
  @override
  Future<IDOBluetoothDeviceStateType> getDeviceState(
      [IDOBluetoothDeviceModel? device]) async {
    device ??= currentDevice;
    if (device == null) {
      return IDOBluetoothDeviceStateType.disconnected;
    }
    final value = await _channel.deviceState(device);
    final json = value as Map;
    int state = json["state"];
    final stateValue = IDOBluetoothDeviceStateType.values[state];
    device.state = stateValue;
    addLog('getDeviceState = ${stateValue.name}', method: 'getDeviceState');
    return stateValue;
  }

  //发送数据
  //writeType：
  // 有响应
  // 无响应
  //commandType：
  // 命令服务特征
  // 健康服务特征
  /// type:
  /// 0 BLE数据, 1 SPP数据
  @override
  Future<IDOBluetoothWriteType> writeData(Uint8List data,
      {IDOBluetoothDeviceModel? device, int type = 0}) async {
    // if (!isConnected) {
    //   print('writeData not connect');
    //   return IDOBluetoothWriteType.error;
    // }
    device ??= currentDevice;
    // print('writeData----1');
    if (device == null) {
      addLog("null device send data", method: 'writeData');
      return IDOBluetoothWriteType.error;
    }
    if (data.length < 2) {
      addLog("null send data", method: 'writeData');
      return IDOBluetoothWriteType.error;
    }
    final data0 = data[0];
    final data1 = data[1];
    bool isTrans = ((data0 == 0xD1 || data0 == 0x13) && data1 == 0x02) ||
        (data.sublist(0, 2).compare(heartPingCommend));
    int writeType = isTrans ? 1 : 0;

    bool isHealthData = (data0 == 0x08 || data0 == 0x09);
    int commandType = isHealthData ? 1 : 0;

    _heartPing.pauseHeartPing(data);
    _writeType = isTrans
        ? IDOBluetoothWriteType.withoutResponse
        : IDOBluetoothWriteType.withResponse;
    final dataMap = {
      "data": data,
      "uuid": device.uuid,
      "macAddress": device.macAddress,
      'btMacAddress': device.btMacAddress,
      "writeType": writeType,
      "commandType": commandType,
      'type': type,
    };
    // print('writeData---2 = $dataMap');
    _channel.writeData(dataMap);
    // addLog('writeData - ${isTrans
    //     ? IDOBluetoothWriteType.withoutResponse
    //     : IDOBluetoothWriteType.withResponse}', method: 'writeData');
    return isTrans
        ? IDOBluetoothWriteType.withoutResponse
        : IDOBluetoothWriteType.withResponse;
  }

  //发送数据状态
  @override
  Stream<IDOBluetoothWriteState> writeState({IDOBluetoothDeviceModel? device}) {
    device ??= currentDevice;
    return _channel.sendStateSubject.map((event) {
      final state = event.state ?? false;
      state ? (_sendErrorCount = 0) : (_sendErrorCount++);
      if (_sendErrorCount > 3 && event.macAddress != null) {
        _sendErrorCount = 0;
        _isNeedConnect = true;
        _channel.cancelConnect(event.macAddress!);
        startScan(event.macAddress);
      }
      event.type = _writeType;
      // addLog('writeState  ${event.type},state = $state', method: 'writeState');
      return event;
    });
  }

  //收到数据
  @override
  Stream<IDOBluetoothReceiveData> receiveData(
      {IDOBluetoothDeviceModel? device}) {
    return _channel.receiveDataSubject
        .skipWhile((element) =>
            (device != null && element.macAddress != device.macAddress))
        .map((event) {
      var data = event.data ??= Uint8List.fromList([]);
      if (data.isNotEmpty && data.length < 20 && data[0] != 0x33) {
        final dataList = data.toList();
        List.generate(20 - data.length, (index) => dataList.add(0x00));
        data = Uint8List.fromList(dataList);
        event.data = data;
      }
      return event;
    });
  }

  //搜索结果
  Stream<List<IDOBluetoothDeviceModel>> _scanResult() {
    return _channel.scanSubject
        .throttleTime(const Duration(seconds: 1),
            trailing: true, leading: false)
        .map((event) {
      //排序和过滤
      if (Platform.isAndroid) {
        final filter = event.where((element) => (element.rssi < 0)).toList();
        filter.sort((a, b) => b.rssi.compareTo(a.rssi));
        return filter;
      }
      final filter = event
          .where((element) => (element.rssi < 80 && element.rssi > 0))
          .toList();
      filter.sort((a, b) => a.rssi.compareTo(b.rssi));
      return filter;
    });
  }

  //过滤搜索结果
  @override
  Stream<List<IDOBluetoothDeviceModel>> scanResult(
      {List<String>? deviceName,
      List<int>? deviceID,
      List<String>? macAddress,
      List<String>? uuid}) {
    return _scanResult().map((event) {
      if (deviceID != null && deviceID.isNotEmpty) {
        event.retainWhere((element) => deviceID.contains(element.deviceId));
      }
      if (deviceName != null && deviceName.isNotEmpty) {
        event.retainWhere((element) => deviceName.contains(element.name));
      }
      if (macAddress != null && macAddress.isNotEmpty) {
        event.retainWhere((element) => macAddress.contains(element.macAddress));
      }
      if (uuid != null && uuid.isNotEmpty) {
        event.retainWhere((element) => uuid.contains(element.uuid));
      }
      return event;
    });
  }

  @override
  Stream<List<IDOBluetoothDeviceModel>> scanResultNative() {
    return _scanResult().map((event) {
      if (_deviceIDs != null) {
        if (_deviceIDs!.isNotEmpty) {
          event.retainWhere((element) => _deviceIDs!.contains(element.deviceId));
        }
      }
      if (_deviceNames != null) {
        if (_deviceNames!.isNotEmpty) {
          event.retainWhere((element) => _deviceNames!.contains(element.name));
        }
      }
      if (_macAddresss != null) {
        if (_macAddresss!.isNotEmpty) {
          event.retainWhere((element) => _macAddresss!.contains(element.macAddress));
        }
      }
      if (_uuids != null) {
        if (_uuids!.isNotEmpty) {
          event.retainWhere((element) => _uuids!.contains(element.uuid));
        }
      }
      return event;
    });
  }

  //添加扫描过滤
  @override
  scanFilter({List<String>? deviceNames, List<int>? deviceIDs, List<String>? macAddresss, List<String>? uuids}) {
    _deviceNames = deviceNames;
    _deviceIDs = deviceIDs;
    _macAddresss = macAddresss;
    _uuids = uuids;
  }

  //蓝牙状态
  @override
  Stream<IDOBluetoothStateModel> bluetoothState() {
    return _channel.stateSubject;
  }



  //设备状态状态
  @override
  Stream<IDOBluetoothDeviceStateModel> deviceState() {
    return _channel.deviceStateSubject.where((event) {
      if (event.state == IDOBluetoothDeviceStateType.connected &&
          isOTA == false &&
          isAutoConnect == false &&
          Platform.isIOS &&
          currentDevice != null &&
          currentDevice!.isNeedGetMacAddress) {
        //首次绑定需要获取Mac地址，这里挡住，保证后续链接已经有Mac地址
        return false;
      }else {
        _deviceSubject.add(currentDevice ?? IDOBluetoothDeviceModel());
      }
      return true;
    });
  }


  @override
  Stream<IDOBluetoothDeviceModel> listenCurrentDevice() {
     return _deviceSubject;
  }

  ///内部调用
  @override
  addDeviceState(IDOBluetoothDeviceStateModel model) {
    addLog('addDeviceState = ${model.state}', method: 'addDeviceState');
    _channel.deviceStateSubject.add(model);
  }

  //设置配对
  /* 打开pair流程（ios）：打开ANCS-》重复发送pair指令-》收到pair指令，停止发送pair指令-》发送获取pair指令-》收到获取pair
      指令-》结束 */
  @override
  Future<IDOBluetoothPairType> openPair(
      {IDOBluetoothDeviceModel? device}) async {
    device ??= currentDevice;
    if (device == null) {
      return IDOBluetoothPairType.errorOrTimeOut;
    }
    addLog("openPair", method: 'openPair');
    if (Platform.isAndroid) {
      return IDOBluetoothPairType.errorOrTimeOut;
    } else if (_channel.isPairList.isEmpty) {
      _openPairTimeOut();
    }
    Completer<IDOBluetoothPairType> completer = Completer();
    _channel.isPairList.add(completer);
    return completer.future.timeout(const Duration(seconds: 30), onTimeout: () {
      addLog("pair timeout", method: 'openPair');
      cancelOpenPairTimeOut();
      _channel.isPairList.clear();
      return IDOBluetoothPairType.errorOrTimeOut;
    });
  }

  ///bt配对（android）
  @override
  setBtPair(IDOBluetoothDeviceModel device) {
    if (Platform.isIOS) {
      return;
    }
    //过滤非法btMac地址
    if (device.btMacAddress == '00:00:00:00:00:00') {
      addLog('过滤非法btMac地址 unlawful btMacAddress = ${device.btMacAddress}',
          method: 'setBtPair');
      return;
    }
    addLog('bt配对 btMacAddress = ${device.btMacAddress}', method: 'setBtPair');
    //安卓直接发起BT配对
    _channel.setPair(device);
  }

  _openPairTimeOut() {
    if (currentDevice == null || !isConnected) {
      cancelOpenPairTimeOut();
      _channel.isPairList.forEach((element) {
        element.complete(IDOBluetoothPairType.errorOrTimeOut);
      });
      _channel.isPairList.clear();
      return;
    }
    getCommendHandler().handleRequest(openPairCommend);
    addOpenPairTimeOut(() {
      Future.delayed(const Duration(seconds: 3), () {
        _openPairTimeOut();
      });
    });
  }

  ///取消配对（android）
  @override
  cancelPair({IDOBluetoothDeviceModel? device}) {
    if (Platform.isIOS) {
      return;
    }
    device ??= currentDevice;
    if (device == null) {
      return false;
    }
    _channel.cancelPair(device);
    addLog("cancelPair", method: 'cancelPair');
  }

  ///自动重连（android）
  autoConnectAndroid(
      {IDOBluetoothDeviceModel? device,
      bool isDueToPhoneBluetoothSwitch = false}) async{
    addLog(
        "autoConnect,device = ${device?.macAddress},name = ${device?.name} - "
        "${currentDevice?.name}"
        "isDueToPhoneBluetoothSwitch = $isDueToPhoneBluetoothSwitch",
        method: 'autoConnect');
    if (Platform.isIOS) {
      return;
    }
    //先断链上个设备
    IDOBluetoothDeviceModel? lastDevice = currentDevice;
    IDOBluetoothDeviceStateType lastState = await getDeviceState(lastDevice);
    if (lastDevice != null &&
        lastDevice.macAddress != device?.macAddress &&
        (lastState == IDOBluetoothDeviceStateType.connected ||
            lastState == IDOBluetoothDeviceStateType.connecting)) {
      addLog('先断链上个设备  ${lastDevice.macAddress}', method: 'connect');
      cancelConnect(macAddress: lastDevice.macAddress);
      //等待上个设备断链
      await deviceState()
          .where((event) =>
      event.state == IDOBluetoothDeviceStateType.disconnected &&
          (event.macAddress == lastDevice.macAddress ||
              (event.uuid == lastDevice.uuid && Platform.isIOS)))
          .first;
    }
    if (device != null) {
      currentDevice = device;
    } else {
      device ??= currentDevice;
    }
    _channel.autoConnect(device!,
        isDueToPhoneBluetoothSwitch: isDueToPhoneBluetoothSwitch);
  }

  ///连接SPP
  @override
  connectSPP(String btMacAddress) {
    _channel.connectSPP(btMacAddress);
  }

  ///断开SPP
  @override
  disconnectSPP(String btMacAddress) {
    _channel.disconnectSPP(btMacAddress);
  }

  ///发起dfu升级
  @override
  startNordicDFU(IDOBluetoothDfuConfig config) {
    _channel.startNordicDFU(config);
  }

  //spp状态
  @override
  Stream<IDOBluetoothSPPStateType> stateSPP() {
    return _channel.sppStateSubject;
  }

  //spp文件写完成
  @override
  Stream<String> writeSPPCompleteState() {
    return _channel.writeSPPCompleteSubject;
  }

  ///写日志，外部调用
  @override
  Stream<Map> writeLog() {
    return _channel.logStateSubject;
  }

  @override
  needAutoConnect(bool autoConnect) {
    addLog('isAutoConnect = $autoConnect', method: 'updateBind');
    isAutoConnect = autoConnect;
  }

  ///监听dfu状态，外部调用
  ///占时去掉
  @override
  Stream<IDOBluetoothDfuState> dfuState() {
    return _channel.dfuStateSubject;
  }

  ///监听dfu进度，外部调用
  @override
  Stream<Map> dfuProgress() {
    return _channel.dfuProgressSubject;
  }

  ///内部使用
  @override
  addLog(
    String detail, {
    String className = 'IDOBluetoothManager',
    required String method,
  }) {
    // print('$method - $detail');
    final json = {
      'platform': 3, //1 ios  2 android 3 flutter;
      'className': className,
      'method': method,
      'detail': detail, //日志内容
    };
    _channel.logStateSubject.add(json);
  }

  ///内部使用
  @override
  channelCancelConnect(String? macAddress) {
    macAddress ??= currentDevice?.macAddress;
    addLog('channelCancelConnect = ${macAddress}',
        method: 'channelCancelConnect');
    if (macAddress == null) {
      return;
    }
    _channel.cancelConnect(macAddress);
  }

  @override
  autoConnect({IDOBluetoothDeviceModel? device}) {
    if (Platform.isAndroid) {
      autoConnectAndroid(device: device);
    } else {
      connect(device);
    }
  }

  @override
  Future<String?> logPath() {
    return IDOBluetoothLogger.exportDbPath();
  }

  @override
  String getSdkVersion() {
    return "4.0.0";
  }
}
