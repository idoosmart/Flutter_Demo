part of '../phone_calendar_manager.dart';

class _IDOPhoneCalendarManager implements IDOPhoneCalendarManager {
  static final _instance = _IDOPhoneCalendarManager._internal();
  factory _IDOPhoneCalendarManager() => _instance;

  _IDOPhoneCalendarManager._internal() {
    libManager.listenConnectStatusChanged((isConnected) {
      if (!isConnected) {
        stopSync();
      }
    });
  }

  bool _isSyncing = false;
  StreamSubscription<bool>? _transferSub;
  final _coreMgr = IDOProtocolCoreManager();

  @override
  bool get isSupported => libManager.funTable.supportPhoneCalendarReminder;

  @override
  bool get isSyncing => _isSyncing;

  @override
  void stopSync() {
    _transferSub?.cancel();
    _transferSub = null;
    _isSyncing = false;
  }

  void _logAppJson(String action, String json) {
    logger?.d('[PhoneCalendar] $action json:$json');
  }

  @override
  Future<PhoneCalendarSyncResult> syncPhoneCalendar({
    required List<PhoneCalendarEvent> events,
    PhoneCalendarCropStrategy? strategy,
    void Function(double progress)? onTransferProgress,
    void Function(FileTransStatus status)? onTransferStatus,
  }) async {
    if (!isSupported) {
      return const PhoneCalendarSyncResult(
        errCode: PhoneCalendarSyncErrCode.notSupportedOrMetaFailed,
      );
    }
    if (!libManager.isConnected) {
      return const PhoneCalendarSyncResult(
        errCode: PhoneCalendarSyncErrCode.deviceNotConnected,
      );
    }
    if (_isSyncing) {
      logger?.w('[PhoneCalendar] sync already in progress');
      return const PhoneCalendarSyncResult(
        errCode: PhoneCalendarSyncErrCode.packOrTransferFailed,
      );
    }
    if (events.isEmpty) {
      return const PhoneCalendarSyncResult(
        errCode: PhoneCalendarSyncErrCode.invalidParam,
      );
    }

    final resolvedStrategy = PhoneCalendarCropStrategyRegistry.resolve(strategy);
    final validateErr = PhoneCalendarCropStrategyRegistry.validate(resolvedStrategy);
    if (validateErr != null) {
      logger?.e('[PhoneCalendar] strategy invalid: $validateErr');
      return const PhoneCalendarSyncResult(
        errCode: PhoneCalendarSyncErrCode.invalidParam,
      );
    }

    _isSyncing = true;
    try {
      final meta = await _queryCalMeta();
      if (meta == null) {
        return const PhoneCalendarSyncResult(
          errCode: PhoneCalendarSyncErrCode.notSupportedOrMetaFailed,
        );
      }
      PhoneCalendarUpdateTime updateTime = PhoneCalendarUpdateTime.fromDateTime(DateTime.now());
      final syncJson = <String, dynamic>{
        ...resolvedStrategy.toJson(),
        ...updateTime.toJson(),
        'max_file_size': meta['support_max_size'],
        'items': events.map((e) => e.toJson()).toList(),
      };

      final syncPayload = jsonEncode(syncJson);
      _logAppJson('syncPhoneCalendarCal request', syncPayload);

      final packJson = _coreMgr.syncPhoneCalendarCal(jsonData: syncPayload);
      if (packJson == null || packJson.isEmpty) {
        return const PhoneCalendarSyncResult(
          errCode: PhoneCalendarSyncErrCode.packOrTransferFailed,
        );
      }

      final packResult = jsonDecode(packJson) as Map<String, dynamic>;
      final errCode = packResult['err_code'] as int? ?? PhoneCalendarSyncErrCode.packOrTransferFailed;
      final packedItemCount = packResult['packed_item_count'] as int?;
      if (errCode != PhoneCalendarSyncErrCode.success) {
        return PhoneCalendarSyncResult(
          errCode: errCode,
          packedItemCount: packedItemCount,
        );
      }

      final calPath = packResult['path'] as String? ?? '';
      if (calPath.isEmpty) {
        return PhoneCalendarSyncResult(
          errCode: PhoneCalendarSyncErrCode.packOrTransferFailed,
          packedItemCount: packedItemCount,
        );
      }

      final transferOk = await _transferCalFile(
        calPath: calPath,
        onTransferProgress: onTransferProgress,
        onTransferStatus: onTransferStatus,
      );
      if (!transferOk) {
        return PhoneCalendarSyncResult(
          errCode: PhoneCalendarSyncErrCode.packOrTransferFailed,
          packedItemCount: packedItemCount,
        );
      }

      return PhoneCalendarSyncResult(
        errCode: PhoneCalendarSyncErrCode.success,
        packedItemCount: packedItemCount,
      );
    } catch (e, st) {
      logger?.e('[PhoneCalendar] sync failed: $e\n$st');
      return const PhoneCalendarSyncResult(
        errCode: PhoneCalendarSyncErrCode.packOrTransferFailed,
      );
    } finally {
      _isSyncing = false;
      _transferSub = null;
    }
  }

  Future<Map<String, dynamic>?> _queryCalMeta() async {
    const requestJson = '{"operate":1}';
    _logAppJson('operate=1 request', requestJson);
    final rs = await libManager
        .send(
          evt: CmdEvtType.phoneCalendarReminder,
          json: requestJson,
        )
        .first;
    if (!rs.isOK || rs.json == null || rs.json!.isEmpty) {
      logger?.e('[PhoneCalendar] operate=1 failed: ${rs.code}');
      return null;
    }
    _logAppJson('operate=1 reply', rs.json!);
    final json = jsonDecode(rs.json!) as Map<String, dynamic>;
    if ((json['err_code'] as int? ?? 1) != 0) {
      logger?.e('[PhoneCalendar] operate=1 err_code=${json['err_code']}');
      return null;
    }
    final maxSize = json['support_max_size'] as int? ?? 0;
    if (maxSize <= 0) {
      logger?.e('[PhoneCalendar] operate=1 support_max_size invalid');
      return null;
    }
    return json;
  }

  Future<bool> _transferCalFile({
    required String calPath,
    void Function(double progress)? onTransferProgress,
    void Function(FileTransStatus status)? onTransferStatus,
  }) {
    final completer = Completer<bool>();
    final fileItem = NormalFileModel(
      fileType: FileTransType.cal,
      filePath: calPath,
      fileName: 'phone_calendar.cal',
    );

    _transferSub = libManager.transFile
        .transferSingle(
          fileItem: fileItem,
          funcStatus: onTransferStatus ?? (_) {},
          funcProgress: onTransferProgress ?? (_) {},
          cancelPrevTranTask: true,
        )
        .listen((value) {
      completer.complete(value);
    });

    return completer.future;
  }
}
