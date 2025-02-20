part of '../ido_bluetooth_manager.dart';

class _IDOBluetoothManager
    with
        IDOBluetoothStateMixin,
        IDOBluetoothCommendMixin,
        IDOBluetoothTimeoutMixin,
        WidgetsBindingObserver
    implements IDOBluetoothManager {
  _IDOBluetoothManager._privateConstructor();
  static final _IDOBluetoothManager _instance =
      _IDOBluetoothManager._privateConstructor();
  factory _IDOBluetoothManager() => _instance;

  final _channel = IDOBluetoothChannel();
  final _heartPing = IDOBluetoothHeartPing();
  Completer<bool>? _completerGetBtAddress;

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

  // 0 爱都, 1 恒玄, 2 VC
  int? _currentPlatform = 0;

  ///写数据状态
  IDOBluetoothWriteType _writeType = IDOBluetoothWriteType.error;

  /// 监听当前设备
  final _deviceSubject = PublishSubject<IDOBluetoothDeviceModel>();

  /// 搜索筛选条件
  List<String>? _deviceNames;
  List<int>? _deviceIDs;
  List<String>? _macAddresss;
  List<String>? _uuids;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
      super.didChangeAppLifecycleState(state);
      if (state == AppLifecycleState.detached) {
        addLog('bluetoothSDK AppLifecycleState.detached',
            method: 'didChangeAppLifecycleState');
        closeNotify(null);
      }
  }

  closeNotify(IDOBluetoothDeviceModel? device) {
    if (!Platform.isIOS) {
      return;
    }
    device ??= currentDevice;
    if (device == null) {
      addLog('关闭通知 - device is null', method: 'closeNotify');
      return;
    }
    _channel.closeNotify(device);
  }

  //注册,程序开始运行调用
  //heartPingSecond:心跳包间隔(ios)
  //outputToConsole：输出日志
  @override
  register({int heartPingSecond = 20, bool outputToConsole = false}) async {
    //日志
    await _registerLog();
    //通道
    _channel.register();
    if (Platform.isIOS) {
      _heartPing.startHeartPing(heartPingSecond: heartPingSecond);
    }
    getBluetoothState();
    //监听状态
    bluetoothState().listen((event) => _listenBlueState(event));
    _channel.deviceStateSubject.listen((event) => _listenDeviceState(event));
    receiveData().listen((event) => _listenReceiveData(event));
    _scanResult().listen((event) => _listenScanResult(event));
    addLog('bluetoothSDK register version = ${getSdkVersion()}',
        method: 'register');
  }

  _registerLog({bool outputToConsole = false}) async {
    // 获取DocumentPath（sdk内部实现，不再引用path_provider，减少三方库依赖）
    final path = await _channel.getDocumentPath();
    await IDOBluetoothLogger().register(outputToConsole: outputToConsole, logDir: path);
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
              '${element.name}, platform = ${element.platform}:${currentDevice?.platform}',
              method: '_listenScanResult');
          final deviceId = currentDevice?.deviceId;
          final platform = currentDevice?.platform;

          currentDevice = element;

          if ((element.deviceId ?? 0) <= 0) {
            element.deviceId = deviceId;
          }
          if (element.platform <= 0) {
            element.platform = platform ?? -1;
          }
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
    } else if (event.state == IDOBluetoothStateType.poweredOff ||
        event.state == IDOBluetoothStateType.resetting) {
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
        'NeedReconnect isAutoConnect = $isAutoConnect,isConnected = $isConnected, platform = ${currentDevice?.platform}'
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
        _autoConnectAndroid(
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
      Future.delayed(Duration(milliseconds: macAddress == null? 0: 10),(){
        stopScan();
        _channel.deviceMap.clear();
        _channel.startScan(macAddress);
        addLog('--- startScan $macAddress', method: 'startScan');
        rescanCount = 0;
      });
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
    addLog("开始扫描指定设备 $macAddress", method: 'startScan');
    final device = await _channel.scanSubject.firstWhere((event) {
      final result = event.where((element) => element.macAddress == macAddress);
      return result.isNotEmpty;
    }).timeout(const Duration(seconds: 60), onTimeout: () {
      addLog("未扫描到指定设备", method: 'startScan');
      return [];
    });
    _channel.stopScan();
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
      final macAddress = currentDevice?.macAddress;
      _channel.startScan(macAddress);
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
  connect(IDOBluetoothDeviceModel? device, {Duration? delayDuration = Duration.zero}) async {
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

    if (delayDuration != null) {
      // 注：目前思澈平台ota后，设备重启有时无法连接到蓝牙服务，此处添加延时
      addLog("delay connect ${delayDuration.inMilliseconds} ms", method: 'connect');
      await Future.delayed(delayDuration, () { });
    }

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
        'start connect ${device.macAddress} name = ${device.name}, platform = ${device.platform}'
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
      final state = await getBluetoothState();
      if (state == IDOBluetoothStateType.poweredOff && Platform.isIOS) {
        //  安卓这种情况系统直接发出断链通知，iOS同步逻辑直接发送断链通知。
        Future.delayed(const Duration(seconds: 1)).then((value) =>
            bluetoothManager.addDeviceState(IDOBluetoothDeviceStateModel(
                macAddress: macAddress,
                state: IDOBluetoothDeviceStateType.disconnected,
                errorState: IDOBluetoothDeviceConnectErrorType.cancelByUser,
                platform: 0
            )));
      }
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
    addLog('getBluetoothState = ${stateValue.state}',
        method: 'getBluetoothState');
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
    } else if (_channel.isConnecting &&
        device.macAddress == currentDevice?.macAddress) {
      addLog("getDeviceState _channel.isConnecting = ${_channel.isConnecting}",
          method: "getDeviceState");
      return IDOBluetoothDeviceStateType.connecting;
    }
    final value = await _channel.deviceState(device);
    final json = value as Map;
    int state = json["state"];
    final stateValue = IDOBluetoothDeviceStateType.values[state];
    device.state = stateValue;
    addLog('getDeviceState = ${stateValue.name}', method: 'getDeviceState');
    return stateValue;
  }

  var flag = false;
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
      {IDOBluetoothDeviceModel? device, int type = 0, int platform = 0}) async {
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

    if (device.platform == 98 && device.isOta) {
      addLog("device.platform == 98 & ota, ignore cmd", method: 'writeData');
        return IDOBluetoothWriteType.withoutResponse;
    }
    // addLog("heng xuan device.platform ${device.platform}, deviceId: ${device.deviceId}  platform: $platform data.length : ${data.length}", method: "writeData");
    if (device.deviceId == 7828 && platform == 0) {
      //恒玄设备，爱都指令
      if (data.length == 18 && (data[0] == 0x03 && data[1] == 0x23)) {
        bool allZero = true;
        for (int i = 4; i < data.length; i++) {
          if (data[i] != 0) {
            allZero = false;
            break;
          }
        }
        addLog("heng xuan 03 23 user_id ${allZero ? "all 0" : "not all 0"}", method: "writeData");
        if (allZero) {
          data = data.sublist(0, 4);
        }
      }
    }

    //恒玄不判断长度
    if (platform != 1 && data.length < 2) {
      addLog("null send data", method: 'writeData');
      return IDOBluetoothWriteType.error;
    }
    bool isTrans =false;
    bool isHealthData = false;
    if (data.length >= 2) {
      final data0 = data[0];
      final data1 = data[1];
      isTrans = ((data0 == 0xD1 || data0 == 0x13) && data1 == 0x02) ||
          (data.sublist(0, 2).compare(heartPingCommend));


      isHealthData = (data0 == 0x08 || data0 == 0x09);
    }
    int writeType = isTrans ? 1 : 0;
    int commandType = platform != 1 && isHealthData ? 1 : 0;
    _heartPing.pauseHeartPing(data);
    /// IDO 文件传输 和 恒玄 文件传输 走无响应发送
    _writeType = (isTrans || platform == 1)
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
      'platform': platform
    };
    //debugPrint('writeData---2 _writeType = $_writeType');
    if (type == 1) {//SPP数据，目前只有安卓支持
      _channel.writeSppData(dataMap);
    } else {
      _channel.writeData(dataMap);
    }
    // addLog('writeData - ${isTrans
    //     ? IDOBluetoothWriteType.withoutResponse
    //     : IDOBluetoothWriteType.withResponse}', method: 'writeData');
    if ((isTrans || platform == 1) && Platform.isIOS) {
      final isIphone11OrLower = await _channel.isIphone11OrLower();
      // debugPrint("isIphone11OrLower:$isIphone11OrLower, platform == $platform isTrans：$isTrans");
      // 针对恒玄平台，文件传输，在iPhone 11 以下添加延时10ms, 其他手机不延时
      if (platform == 1 && isIphone11OrLower) {
        await Future.delayed(const Duration(milliseconds: 10));
        if (!flag) {
          addLog('writeData delay 10 ms, isIphone11OrLower:$isIphone11OrLower, platform == $platform', method: 'writeData');
          flag = true;
        }
      }
    }
    return _writeType;
  }

  //发送数据状态
  @override
  Stream<IDOBluetoothWriteState> writeState({IDOBluetoothDeviceModel? device}) {
    device ??= currentDevice;
    final stateStream = _channel.sendStateSubject.map((event) {
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
    if (Platform.isIOS && _writeType == IDOBluetoothWriteType.withoutResponse) {
      debugPrint("ios writeState withoutResponse 延迟10毫秒");
      return stateStream.delay(const Duration(milliseconds: 10));
    }
    return stateStream;
  }

  //收到数据
  @override
  Stream<IDOBluetoothReceiveData> receiveData(
      {IDOBluetoothDeviceModel? device}) {
    return _channel.receiveDataSubject
        .skipWhile((element) =>
            (device != null && element.macAddress != device.macAddress))
        .map((event) {
         if(event.platform == 1){//恒玄数据，指令不需要拼接，直接回调出去
           return event;
         }
      var data = event.data ??= Uint8List.fromList([]);
      if (data.isNotEmpty && data.length < 20 && data[0] != 0x33) {
        final dataList = data.toList();
        List.generate(20 - data.length, (index) => dataList.add(0x00));
        data = Uint8List.fromList(dataList);
        event.data = data;
      }

         // 针对获取macAddress指令特殊处理， 处理btAddress
         if(Platform.isAndroid && (data.sublist(0, 2).compare(getMacAddressCommend))
             && _completerGetBtAddress != null
             && !_completerGetBtAddress!.isCompleted) {
           _parseMacAddress(data);
           _completerGetBtAddress?.complete(true);
           _completerGetBtAddress = null;
         }

         if (data.length > 2 && data.sublist(0, 2).compare(getBasicInfoCommand)) {
           _parseBasicInfo(data);
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
          event
              .retainWhere((element) => _deviceIDs!.contains(element.deviceId));
        }
      }
      if (_deviceNames != null) {
        if (_deviceNames!.isNotEmpty) {
          event.retainWhere((element) => _deviceNames!.contains(element.name));
        }
      }
      if (_macAddresss != null) {
        if (_macAddresss!.isNotEmpty) {
          event.retainWhere(
              (element) => _macAddresss!.contains(element.macAddress));
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
  scanFilter(
      {List<String>? deviceNames,
      List<int>? deviceIDs,
      List<String>? macAddresss,
      List<String>? uuids}) {
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
      _currentPlatform = event.platform;
      if (event.state == IDOBluetoothDeviceStateType.connected &&
          isOTA == false &&
          isAutoConnect == false &&
          Platform.isIOS &&
          currentDevice != null &&
          currentDevice!.isNeedGetMacAddress) {
        //首次绑定需要获取Mac地址，这里挡住，保证后续链接已经有Mac地址
        return false;
      } else {
        _deviceSubject.add(currentDevice ?? IDOBluetoothDeviceModel());
      }
      if (currentDevice?.macAddress == event.macAddress) {
        _channel.isConnecting = false;
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
    addLog('addDeviceState = ${model.state} platform == $_currentPlatform', method: 'addDeviceState');
    model.platform = _currentPlatform;
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

    if (currentDevice == null) {
      return;
    }

    // 不相同的macAddress
    if(currentDevice!.macAddress != device.macAddress) {
      addLog('传入device macAddress：${device.macAddress} 和 当前设备 ${currentDevice!.macAddress!} 不同',
          method: 'setBtPair');
      return;
    }

    addLog('bt配对 btMacAddress = ${currentDevice!.btMacAddress}', method: 'setBtPair');
    //安卓直接发起BT配对
    _channel.setPair(currentDevice!);

    //
    // // btMacAddress为空时，此处理获取
    // if (device.btMacAddress == null || device.btMacAddress!.isEmpty) {
    //   _requestBtAddress().then((value) {
    //     addLog('bt配对 btMacAddress = ${device.btMacAddress}', method: 'setBtPair');
    //     //安卓直接发起BT配对
    //     _channel.setPair(device);
    //   }).timeout(const Duration(seconds: 10), onTimeout: (){
    //     if (_completerGetBtAddress != null && !_completerGetBtAddress!.isCompleted) {
    //       _completerGetBtAddress!.completeError(UnsupportedError("获取btMacAddress超时"));
    //       _completerGetBtAddress = null;
    //     }
    //   });
    // }else {
    //   addLog('bt配对 btMacAddress = ${device.btMacAddress}', method: 'setBtPair');
    //   //安卓直接发起BT配对
    //   _channel.setPair(device);
    // }
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
    addLog("cancelPair - ${device.macAddress} btMacAddress: ${device.macAddress}", method: 'cancelPair');
  }

  @override
  Stream<bool> stateBt() {
    return _channel.btStateSubject;
  }

  ///自动重连（android）
  _autoConnectAndroid(
      {IDOBluetoothDeviceModel? device,
      bool isDueToPhoneBluetoothSwitch = false}) async {
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
    needAutoConnect(true);
    if (Platform.isAndroid) {
      _autoConnectAndroid(device: device);
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
    return IDOBluetoothUpdateLog().getSdkVersion();
  }

  @override
  heartPingSwitch(bool isOn) {
    _heartPing.openBully = isOn;
  }

  @override
  Future<IDOBluetoothMediaState> getMediaAudioState(String btMac) async {
    return await _channel.getMediaState(btMac);
  }

  @override
  Future<bool> getSppState({String btMac = ""}) async {
    if (btMac.isEmpty) btMac = currentDevice?.btMacAddress ?? "";
    if(btMac.isEmpty)return false;
    return await _channel.getSppState(btMac);
  }

  @override
  Stream<IDOBluetoothMediaState> mediaAudioState() {
    return _channel.mediaStateSubject;
  }

}

extension _IDOBluetoothManagerExt on _IDOBluetoothManager {

  /// 请求btMacAddress
  Future<bool> _requestBtAddress() {
    if (_completerGetBtAddress != null && !_completerGetBtAddress!.isCompleted) {
      _completerGetBtAddress?.completeError(UnsupportedError("取消前次请求"));
      _completerGetBtAddress = null;
    }
    _completerGetBtAddress = Completer<bool>();
    addLog('bt配对 请求 btMacAddress', method: '_requestBtAddress');
    bluetoothManager.writeData(getMacAddressCommend);
    return _completerGetBtAddress!.future;
  }

  void _parseMacAddress(Uint8List data) {
    final device = bluetoothManager.currentDevice;
    device?.macAddress = IDOBluetoothTool.addColon(
        IDOBluetoothTool.uint8ToHex(data.sublist(2, 8)));
    device?.btMacAddress = IDOBluetoothTool.addColon(
        IDOBluetoothTool.uint8ToHex(data.sublist(8, 14)));
    bluetoothManager.currentDevice?.isNeedGetMacAddress = false;
    if (device != null) {
      //deviceBtAddChangedSubject.add(device);
    }
    bluetoothManager.addLog(
        "getMacAddressCommend ${bluetoothManager.currentDevice?.macAddress}"
            " , btmac = ${device?.btMacAddress}",
        className: 'AnalyticMacAdd'
            'ressCommendHandler',
        method: 'handleRequest');
  }

  void _parseBasicInfo(Uint8List data) {
    try {
      print("_parseBasicInfo");
      if (data.length >= 4) {
        final device = bluetoothManager.currentDevice;
        ByteData bytes = ByteData.sublistView(data, 2, 4);
        device?.deviceId = bytes.getUint16(0, Endian.little);
        print("_parseBasicInfo: ${device?.deviceId}");
      }
    } catch (e) {
      bluetoothManager.addLog("_parseBasicInfo failed", method: "_parseBasicInfo");
    }

    try {
      if (data.length >= 13) {
        final device = bluetoothManager.currentDevice;
        ByteData bytes = ByteData.sublistView(data, 12, 13);
        device?.platform = bytes.getUint8(0);
        bluetoothManager.addLog("_parseBasicInfo platform = ${device?.platform}", method: "_parseBasicInfo");
      }
    } catch (e) {
      bluetoothManager.addLog("_parseBasicInfo platform failed", method: "_parseBasicInfo");
    }


  }
}