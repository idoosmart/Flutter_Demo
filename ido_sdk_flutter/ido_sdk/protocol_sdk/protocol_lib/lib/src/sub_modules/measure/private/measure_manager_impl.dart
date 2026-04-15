part of '../measure_manager.dart';

class _IDOMeasureManager implements IDOMeasureManager {
  static final _instance = _IDOMeasureManager._internal();
  factory _IDOMeasureManager() => _instance;

  _IDOMeasureManager._internal() {
    // 监听连接状态
    libManager.listenConnectStatusChanged((isConnected) {
      if (!isConnected && _isMeasuring) {
        logger?.d("[Measure] 蓝牙断连，结束测量状态");
        _stopPolling(IDOMeasureStatus.disconnected);
      }
    });

    // 监听设备通知
    libManager.listenDeviceNotification((model) {
      if (!_isMeasuring) return;
      
      final dataType = model.dataType;
      if (dataType == 72) {
        // 未佩戴
        logger?.d("[Measure] 设备通知：未佩戴 (72)");
        _stopPolling(IDOMeasureStatus.unworn);
      } else if (dataType == 89) {
        // 测量失败
        logger?.d("[Measure] 设备通知：测量失败 (89)");
        _stopPolling(IDOMeasureStatus.failed);
      } else if (dataType == 90) {
        // 测量成功
        logger?.d("[Measure] 设备通知：测量成功 (90)");
        _handleMeasureSuccess();
      }
    });
  }

  bool _isMeasuring = false;
  Timer? _pollingTimer;
  final _controller = StreamController<IDOMeasureResult>.broadcast();
  IDOMeasureType? _currentType;
  DateTime? _startTime;
  
  // 最大测量时长 40秒
  static const int _maxMeasureSeconds = 40;
  // 轮询间隔 2秒
  static const int _pollingIntervalSeconds = 2;

  @override
  bool get isMeasuring => _isMeasuring;

  @override
  IDOMeasureType? get currentType => _currentType;

  @override
  Stream<IDOMeasureResult> listenProcessMeasureData() => _controller.stream;

  @override
  Future<bool> startMeasure(IDOMeasureType type) async {
    if (_isMeasuring) {
      if (_currentType == type) {
        logger?.d("[Measure] 已经在进行该类型的测量 ($type)，忽略重复调用");
        return true;
      } else {
        logger?.e("[Measure] 正在进行 $_currentType 测量，拒绝新测量请求: $type");
        return false;
      }
    }

    logger?.d("[Measure] 开始测量: $type");
    final jsonData = _getJsonData(type, 0x01); // 0x01: 开始测量
    final rs = await libManager.send(evt: CmdEvtType.setBpMeasurement, json: jsonEncode(jsonData)).first;

    if (!rs.isOK || rs.json == null) {
      logger?.e("[Measure] 开始测量指令下发失败: $type");
      return false;
    }

    final result = IDOMeasureResult.fromJson(jsonDecode(rs.json!));
    _controller.add(result);
    logger?.d("[Measure] 开始测量回复状态: ${result.status}");

    if (result.status == IDOMeasureStatus.measuring) {
      _isMeasuring = true;
      _currentType = type;
      _startTime = DateTime.now();

      // 只有心率、血氧且功能表开启时才开启轮询
      final isPollType = type == IDOMeasureType.heartRate || type == IDOMeasureType.spo2;
      if (isPollType && libManager.funTable.supportDevReturnMeasuringValue) {
        logger?.d("[Measure] 开启轮询定时器: $type");
        _startPolling();
      }
      return true;
    } else if (result.status == IDOMeasureStatus.success || result.status == IDOMeasureStatus.failed) {
      // 如果直接返回了最终结果，不进入测量中状态
      return true;
    }

    return rs.isOK;
  }

  @override
  Future<bool> stopMeasure(IDOMeasureType type) async {
    // 即使当前不在测量状态，也可以尝试下发停止指令（容错）
    logger?.d("[Measure] 停止测量: $type");
    final jsonData = _getJsonData(type, 0x02); // 0x02: 停止测量
    final rs = await libManager.send(evt: CmdEvtType.setBpMeasurement, json: jsonEncode(jsonData)).first;
    
    if (_isMeasuring && _currentType == type) {
      _stopPolling(IDOMeasureStatus.stopped);
    }
    return rs.isOK;
  }

  @override
  Future<IDOMeasureResult> getMeasureData(IDOMeasureType type) async {
    final jsonData = _getJsonData(type, 0x03); // 0x03: 获取数据
    final rs = await libManager.send(evt: CmdEvtType.setBpMeasurement, json: jsonEncode(jsonData)).first;
    if (rs.isOK && rs.json != null) {
      return IDOMeasureResult.fromJson(jsonDecode(rs.json!));
    }
    return IDOMeasureResult(status: IDOMeasureStatus.failed);
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: _pollingIntervalSeconds), (timer) {
      if (!_isMeasuring || _currentType == null || _startTime == null) {
        timer.cancel();
        return;
      }

      // 检查是否超时
      final duration = DateTime.now().difference(_startTime!);
      if (duration.inSeconds >= _maxMeasureSeconds) {
        logger?.d("[Measure] 测量超时 (40s)，准备结束");
        _stopPolling(IDOMeasureStatus.timeout);
        return;
      }

      _pollData();
    });
  }

  Future<void> _pollData() async {
    if (!_isMeasuring || _currentType == null) return;

    final result = await getMeasureData(_currentType!);
    _controller.add(result);
    logger?.v("[Measure] 轮询过程数据: ${result.status}, value: ${result.value}");

    if (result.status == IDOMeasureStatus.success || 
        result.status == IDOMeasureStatus.failed ||
        result.status == IDOMeasureStatus.notSupport) {
      logger?.d("[Measure] 轮询获得最终状态: ${result.status}");
      _stopPolling(result.status);
    }
  }

  Future<void> _handleMeasureSuccess() async {
    if (!_isMeasuring || _currentType == null) return;
    
    logger?.d("[Measure] 收到成功通知，正在获取最终数据...");
    final result = await getMeasureData(_currentType!);
    _controller.add(result);
    _stopPolling(result.status);
  }

  void _stopPolling(IDOMeasureStatus finalStatus) {
    if (!_isMeasuring) return;

    logger?.d("[Measure] 结束测量状态: $finalStatus");
    _isMeasuring = false;
    _pollingTimer?.cancel();
    _pollingTimer = null;
    
    // 发送结束状态模型
    _controller.add(IDOMeasureResult(status: finalStatus));
    
    _currentType = null;
    _startTime = null;
  }

  Map<String, dynamic> _getJsonData(IDOMeasureType type, int flag) {
    switch (type) {
      case IDOMeasureType.bloodPressure:
        return {'flag': flag};
      case IDOMeasureType.heartRate:
        return {'hr_flag': flag};
      case IDOMeasureType.spo2:
        return {'spo2_flag': flag};
      case IDOMeasureType.stress:
        return {'stress_flag': flag};
      case IDOMeasureType.oneClick:
        return {'one_click_measure_flag': flag};
      case IDOMeasureType.temperature:
        return {'temperature_flag': flag};
      case IDOMeasureType.bodyComposition:
        return {'body_composition_flag': flag};
    }
  }
}
