part of '../ido_message_icon.dart';



class _IDOMessageIcon implements IDOMessageIcon {
  static final _instance = _IDOMessageIcon._internal();

  _IDOMessageIcon._internal();

  factory _IDOMessageIcon() => _instance;
  late final _coreMgr = IDOProtocolCoreManager();
  late final _libMgr = IDOProtocolLibManager();
  late final _funTable = _libMgr.funTable;
  late final _streamState = StreamController<bool>.broadcast();
  late final _streamPath = StreamController<String>.broadcast();
  late final _defaultAppInfoList = <IDOAppIconItemModel>[];

  /// 思澈消息图标代理对象
  SeCheMessageIconDelegate? _scDelegate;

  /// Android 已更新图标应用id缓存集合
  late final _androidEventTypes = <int>[];

  /// Android 事件类型缓存集合
  late final _cacheEventTypes = <int>[];

  /// 当前获取累加个数
  int _packNum = 0;

  /// 获取最后一个应用id
  int _lastId = 0;

  /// 是否在更新中
  bool _isUpdate = false;

  int _iconWidth = 60;

  String _macAddress = "";

  /// 实现set方法
  set isUpdate(bool value) {
    _isUpdate = value;
    logger?.d('message icon isUpdate state == $value');
    _streamState.add(_isUpdate);
  }

  /// 第一次获取包名数据
  bool _isFirst = false;

  /// 是否注册监听
  bool _isRegister = false;

  /// app图标信息模型
  IDOAppIconInfoModel? _currentModel;

  @override
  void registerListenUpdate() async {
    if (_isRegister) {
      logger?.v("registerListenUpdate _isRegister: true, ignore");
      return;
    }
    _isRegister = true;
    ToolsImpl().listenNativeLog().listen((event) {
      logger?.d(event);
    });
    final rs = await GetAndroidAppInfo().copyAppIcon();
    _listenUpdate();
    _listenFastSyncComplete();
    final path = await getIconDirPath();
    _streamPath.add(path);
    if (Platform.isIOS && !rs) {
      _isRegister = false;
      logger?.v("registerListenUpdate reset _isRegister = false");
    }

  }

  @override
  String? ios_countryCode;

  @override
  String? ios_baseUrlPath;

  @override
  String? ios_appKey;

  @override
  int? ios_languageUnit;

  @override
  Future<bool> get updating async {
    if (!libManager.isConnected) {
      return false;
    }
    if (Platform.isAndroid) {
      /// Android 不判断更新状态
      return false;
    }
    final model = await getCacheAppInfoModel();
    final items = model.items ?? [];
    if (items.isNotEmpty) {
      return false;
    } else {
      return _isUpdate;
    }
  }

  /// 设置默认app信息集合(支持的设备需要)
  @override
  void setDefaultAppInfoList(List<IDOAppIconItemModel> models) async {
    if (Platform.isAndroid) {
      logger?.d(
          'android does not need to perform setDefaultAppInfoList method');
      return;
    }

    if (!_libMgr.isConnected) {
      logger?.d('not connected, please call connect device first');
      return;
    }

    if (_currentModel?.iconWidth != null) {
      _iconWidth = _currentModel?.iconWidth ?? 60;
      logger?.d("set default app icons icon width 1 == $_iconWidth");
    } else {
      logger?.d(
          'setDefaultAppInfoList country_code: $ios_countryCode, models.length: ${models
              .length}');
      var iconWidth = 60;
      final map_objc = {"operat_flag": 0, "last_id": 0};
      final response = await _libMgr
          .send(evt: CmdEvtType.getPackName, json: jsonEncode(map_objc))
          .first;
      if (_isSuccessCallback(response)) {
        final map = jsonDecode(response.json!) as Map<String, dynamic>;
        map.putIfAbsent('country_code', () => ios_countryCode ?? 'US');
        final model = IDOAppIconInfoModel.fromJson(map);
        iconWidth = model.iconWidth ?? 60;
      }
      _iconWidth = iconWidth == 0 ? 60 : iconWidth;
      logger?.d("set default app icons icon width 2 == $_iconWidth");
    }

    final userSetDefaultAppInfoList = <IDOAppIconItemModel>[];
    userSetDefaultAppInfoList.addAll(models);
    final dirPath = await getIconDirPath();
    try {
      for (var e in userSetDefaultAppInfoList) {
        final file = File(e.iconLocalPath);
        if (file.existsSync()) {
          final filePath1 = "$dirPath/${e.packName}${'_100'}.png";
          final rs = await copyFileChecksum(e.iconLocalPath, filePath1);
          if (rs == 2) {
            // 大图变更，删除小图
            var smallIconPath = "$dirPath/${e.packName}_46.png";
            final smallFile = File(smallIconPath);
            if (smallFile.existsSync()) {
              smallFile.deleteSync();
            }
          }
          e.iconLocalPath = "";
          e.iconLocalPathBig = filePath1;
          final smallFilePath = await IconHelp.cropPicture(
              filePath1, e.packName, _iconWidth, _iconWidth);
          if (smallFilePath != null) {
            e.iconLocalPath = smallFilePath.path;
          }
        } else {
          logger?.e("_IDOMessageIcon file not exists: ${e.iconLocalPathBig}");
        }
      }
      // 持久化
      final obj = IDOAppIconInfoModel(version: 0,
          iconWidth: _iconWidth,
          iconHeight: _iconWidth,
          items: userSetDefaultAppInfoList);
      await storage?.saveUserDefaultMsgIconToDisk(obj);
    }catch(e) {
      logger?.e("setDefaultAppInfoList error == $e");
    }
  }

  @override
  Future<List<IDOAppIconItemModel>> getDefaultAppInfo() async {
    if (_defaultAppInfoList.isNotEmpty) {
      return _defaultAppInfoList;
    }
    _defaultAppInfoList.clear();
    final items = await GetAndroidAppInfo().getDefaultAppInfoList();
    var iconWidth = 60;
    var iconHeight = 60;
    if (_currentModel == null) {
      logger?.d('getDefaultAppInfo country_code: $ios_countryCode, items.length: ${items.length}');
      final map_objc = {"operat_flag": 0, "last_id": 0};
      final response = await _libMgr
          .send(evt: CmdEvtType.getPackName, json: jsonEncode(map_objc))
          .first;
      if (_defaultAppInfoList.isNotEmpty) {
        /// 上面指令可能执行多次，如果有数据，直接返回数据
         return _defaultAppInfoList;
      }
      if (_isSuccessCallback(response)) {
        final map = jsonDecode(response.json!) as Map<String, dynamic>;
        map.putIfAbsent('country_code', () => ios_countryCode ?? 'US');
        final model = IDOAppIconInfoModel.fromJson(map);
        iconWidth = model.iconWidth ?? 60;
        iconHeight = model.iconHeight ?? 60;
      }
    } else {
      iconWidth = _currentModel?.iconWidth ?? 60;
      iconHeight = _currentModel?.iconHeight ?? 60;
    }
    _iconWidth = iconWidth == 0 ? 60 : iconWidth;
    logger?.d("get default app icons icon width == $_iconWidth, items: ${items.length}");
    for (var element in items) {
      final eventType = (element?["type"] as int?) ?? 0;
      final packName = element?["pkgName"] ?? "";
      final appName = element?["appName"] ?? "";
      var iconLocalPath = element?["iconFilePath"] ?? "";
      final iconLocalPathBig = element?["iconFilePath"] ?? "";
      if (Platform.isIOS) {
        final file = await IconHelp.cropPicture(
            iconLocalPath, packName, iconWidth, iconHeight);
        if (file != null) {
          iconLocalPath = file.path;
        }
      }
      final infoMap = {
        "evt_type": eventType,
        "pack_name_array": packName,
        "app_name": appName,
        "icon_local_path": iconLocalPath,
        "item_id": 0,
        "msg_cout": 0,
        "country_code": "",
        "icon_cloud_path": "",
        "icon_local_path_big": iconLocalPathBig,
        "need_sync_icon": 0
      };
      final item = IDOAppIconItemModel.fromJson(infoMap);
      item.isDefault = true;
      _defaultAppInfoList.add(item);
    }
    _defaultAppInfoList.forEach((element) {
      logger?.d(
          "get default app info == ${element.appName} ${element.packName} ${element.iconCloudPath} icon width $_iconWidth");
    });
    return _defaultAppInfoList;
  }

  @override
  Future<String> getIconDirPath() {
    return _getDirPath();
  }

  @override
  Future<bool> resetIconInfoData(
      {required String macAddress, bool deleteIcon = true}) async {
    final devices = await storage?.loadDeviceExtListByDisk();
    devices?.forEach((element) {
      ///清除所有消息图标信息
      storage?.cleanIconInfoData(element.macAddress);
    });
    if (deleteIcon) {
      final dirPath = await _getDirPath();
      await storage?.removeIconDir(dirPath);
    }
    _defaultAppInfoList.clear();
    return Future(() => true);
  }

  @override
  Future<IDOAppIconInfoModel> getCacheAppInfoModel() async {
    final model = await storage?.loadIconInfoDataByDisk();
    if (model != null) {
      if (Platform.isIOS) {
        final dirPath = await getIconDirPath();
        final appInfo = await getDefaultAppInfo();
        // 融合用户设置的应用图标信息
        final userSetMsgIconList = (await storage?.loadUserDefaultMsgIconByDisk())?.items ?? [];
        final existentItems = model.items?.where((element) {
          for (var e in userSetMsgIconList) {
            if (e.packName == element.packName) {
              if (element.iconLocalPathBig == null || element.iconLocalPathBig!.isEmpty) {
                element.iconLocalPathBig = e.iconLocalPathBig;
              }
              if (element.appName.isEmpty) {
                element.appName = e.appName;
              }
              if (element.iconLocalPath.isEmpty) {
                element.iconLocalPath = e.iconLocalPath;
              }
              break;
            }
          }
          final oneApps = appInfo
              .where((item) => item.packName == element.packName)
              .toList();
          /// 过滤不存在的APP信息
          if (oneApps.isNotEmpty) {
            /// 赋值默认应用信息
            element.isDefault = true;
          } else {
            element.isDefault = false;
          }

          if (element.appName.isEmpty) {
            if (oneApps.isNotEmpty) {
                /// 赋值默认应用名称
                element.appName = oneApps.first.appName;
            }
          }

          final packName = element.packName;
          final appName = element.appName;
          final filePath1 = "$dirPath/${element.packName}${'_100'}.png";
          final file1 = File(filePath1);
          if (file1.existsSync() == false) {
            logger?.d("local big image is not exist pack name == ${element.packName}");
            element.iconLocalPathBig = '';
          } else {
            // logger?.d("local big image is exist pack name == $filePath1");
            element.iconLocalPathBig = filePath1;
          }

          var filePath2 = "$dirPath/${element.packName}${'_46'}.png";
          if (_iconWidth > 60) {
              filePath2 = "$dirPath/${element.packName}${'_$_iconWidth'}.png";
          }
          final file2 = File(filePath2);
          if (file2.existsSync() == false) {
            element.iconLocalPath = '';
            logger?.d("local smart image is not exist pack name == ${element.packName}");
          }else {
            // logger?.d("local smart image is exist pack name == $filePath2");
            element.iconLocalPath = filePath2;
          }
          if (   packName.isNotEmpty
              && appName.isNotEmpty
              && file1.existsSync()) {
            return true;
          } else {
            return false;
          }
        }).toList();
        model.items = await _reCropIcon(existentItems ?? []);
      }
      logger?.d("get cache app items count 1: ${model.items?.length ?? 0}");
      return Future(() => model);
    } else {
      logger?.d("get cache app items count 2: 0");
      return Future(() => IDOAppIconInfoModel());
    }
  }

  Future<List<IDOAppIconItemModel>> _reCropIcon(List<IDOAppIconItemModel> items) async {
     if (Platform.isAndroid) {
        return Future(() => items);
     }
     if (items.isEmpty) {
       return Future(() => items);
     }
     final dirPath = await getIconDirPath();
     for (var element in items) {
       var filePath = "$dirPath/${element.packName}${'_46'}.png";
       if (_iconWidth > 60) {
         filePath = "$dirPath/${element.packName}${'_$_iconWidth'}.png";
       }
       final file = File(filePath);
       if (file.existsSync() == false) {
         final file = await IconHelp.cropPicture(
           element.iconLocalPathBig ?? '', element.packName, _iconWidth, _iconWidth);
         if (file != null) {
           element.iconLocalPath = file.path;
         }else {
           logger?.d("re crop icon error == ${element.packName}");
         }
       }
     }
     return Future(() => items);
  }

  // var _printTimer = 0;
  @override
  Future<List<IDOAppIconItemModel>> ios_getAllAppInfo(
      {bool force = false}) async {
    if (!Platform.isIOS) {
      logger?.d('android does not need to perform this method');
      return Future(() => []);
    }

    if (!_funTable.reminderMessageIcon) {
      logger?.d('message icon and name updates are not supported');
      return Future(() => []);
    }

    if (force) {
      /// 强制刷新应用名称
      return await _forceUpdateAppName();
    }

    _isFirst = false;
    final model = await getCacheAppInfoModel();
    if (model.items != null && (model.items ?? []).isNotEmpty) {
      return Future(() => model.items ?? []);
    }

    if (_isUpdate) {
      logger?.d('updating icons and names');
      return Future(() => []);
    }

    _isFirst = true;

    /// 获取默认APP信息
    await _getAppInfo();

    // logger?.d("get app info complete 2 == ${_currentModel?.toJson()}  apps count == ${model.items?.length ?? 0}");

    return _currentModel?.items ?? [];
  }

  @override
  Future<List<IDOAppIconItemModel>> android_getAllAppInfo(
      {bool force = false}) async {
    if (!Platform.isAndroid) {
      logger?.d('ios does not need to perform this method');
      return Future(() => []);
    }
    final items = await GetAndroidAppInfo().getInstallAppInfoList(force: force);
    if (!_isFirst || force) {
      /// 每次启动应用获取一次或者强制
      logger?.d("android icon all app info == $items  items count == ${items.length}  force == $force");
      _isFirst = true;
    }
    final allApps = <IDOAppIconItemModel>[];
    items.forEach((element) {
      final appInfo = element ?? {};
      final packName = appInfo?["pkgName"] ?? "";
      final appName = appInfo?["appName"] ?? "";
      final iconLocalPath = appInfo?["iconFilePath"] ?? "";
      final eventType = appInfo?["type"] ?? 0;
      final isDefault = (appInfo?["isDefault"] as bool?) ?? false;
      final infoMap = {
        "evt_type": eventType,
        "pack_name_array": packName,
        "app_name": appName,
        "icon_local_path": iconLocalPath,
        "item_id": 0,
        "msg_cout": 0,
        "country_code": "",
        "icon_cloud_path": "",
        "icon_local_path_big": "",
        "need_sync_icon": 0
      };
      final item = IDOAppIconItemModel.fromJson(infoMap);
      item.isDefault = isDefault;
      if (item.appName.isNotEmpty && item.iconLocalPath.isNotEmpty) {
        /// 空的APP名字和图片地址为空的不加入列表
        allApps.add(item);
      }
    });
    // _currentModel = IDOAppIconInfoModel();
    // _currentModel?.items = allApps;
    // final transfer = TransferIcon();
    // await transfer.tailorAndTransfer(_currentModel!).first;
    return allApps;
  }

  @override
  Future<List<IDOAppIconItemModel>> firstGetAllAppInfo({bool force = false}) {
    if (Platform.isIOS) {
      return ios_getAllAppInfo(force: force);
    } else if (Platform.isAndroid) {
      return android_getAllAppInfo(force: force);
    }
    return Future(() => []);
  }

  @override
  Future<bool> androidSendMessageIconToDevice(int eventType) async {
    if (!Platform.isAndroid) {
      logger?.d('ios does not need to perform this method');
      return false;
    }

    /// 当前事件类型对应的APP已经更新图标，不再下发接口判断是否需要更新
    if (_androidEventTypes.contains(eventType)) {
      logger?.d(
          'android this app icon has been updated do not need to pass the icon again == $eventType');
      return true;
    }

    /// 缓存事件类型
    if (!_cacheEventTypes.contains(eventType)) {
      _cacheEventTypes.add(eventType);
      logger?.d('android cache event types == $_cacheEventTypes');
    }

    if (_isUpdate) {
      logger?.d('android updating icons');
      return false;
    }

    isUpdate = true;
    logger?.d('android send message icon to device event type == $eventType');

    _currentModel = IDOAppIconInfoModel();
    _currentModel?.items = [];

    final map_objc = {
      "version": 0,
      "items_num": 0,
      "operat": 3,
      "all_on_off": 0,
      "all_send_num": 1,
      "now_send_index": 1
    };

    final response = await _libMgr
        .send(evt: CmdEvtType.setNoticeMessageState, json: jsonEncode(map_objc))
        .first;

    if (_isSuccessCallback(response)) {
      final map = jsonDecode(response.json!) as Map<String, dynamic>;
      _currentModel?.version = 0;
      _currentModel?.iconWidth = 0;
      _currentModel?.iconHeight = 0;
      _currentModel?.colorFormat = 0;
      _currentModel?.blockSize = 0;

      final count = (map['items_num'] as int?) ?? 0;
      _currentModel?.totalNum = count;
      if (map['items'] == null) {
        /// 固件返回数据异常，防止 items = null 的问题
        logger?.d('android icon items is null');
        _cacheEventTypes.clear();
        isUpdate = false;
        return Future(() => false);
      }
      var items = (map['items'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList();

      /// 超过通知50/100个数，可能返回的items没有对应的事件类型，需要添加赋值到items，传输图标到固件
      final noExistItems = _cacheEventTypes.where((type) {
        final list = items?.where((item) {
          final evtType = (item["evt_type"] as int?) ?? 0;
          return evtType == type;
        }).toList() ?? [];
        if (list.isNotEmpty) {
            return false;
        } else {
            return true;
        }
      }).toList();

      /// 添加没有的事件类型到items
      for (var element in noExistItems) {
        final item = {
            "evt_type" : element,
            "notify_state" : 1,
            "pic_flag" : 2
        };
        logger?.d('android add no exist item == $item');
        items?.add(item);
      }

      final appInfoItems = await _noticeStateToAppInfo(items);

      final otherItems = appInfoItems.where((element) {
        var isDownload = element.isUpdateAppIcon ?? false;
        return (_cacheEventTypes.contains(element.evtType)) && !isDownload;
      }).toList() ?? [];

      if (otherItems.isEmpty) {
        logger?.d('android does not need to update the icon');
        _cacheEventTypes.clear();
        isUpdate = false;
        return Future(() => false);
      }

      _currentModel?.items = otherItems;

      logger?.d('android get cache app info complete 2 == ${_currentModel?.toJson()}');

      final model = IDOAppIconInfoModel(
          version: 0,
          iconHeight: 0,
          iconWidth: 0,
          colorFormat: 0,
          blockSize: 0,
          totalNum: count);
      model.items = appInfoItems;

      await storage?.saveIconInfoDataToDisk(model);

      final transfer = TransferIcon();
      transfer.addSeChe(_scDelegate);
      final complete = await transfer.tailorAndTransfer(_currentModel!).first;
      otherItems.forEach((element) {
        _cacheEventTypes.remove(element.evtType);
        logger?.d(
            'android transfer icon complete cache event types == $_cacheEventTypes');
      });
      isUpdate = false;
      return Future(() => complete);
    } else {
      isUpdate = false;
      return Future(() => false);
    }

  }

  @override
  Future<String> androidOriginalIconDirPath() {
    return GetAndroidAppInfo().androidAppIconDirPath();
  }

  @override
  Stream<bool> listenUpdateState() {
    return _streamState.stream;
  }

  @override
  Stream<String> listenIconDirPath() {
    return _streamPath.stream;
  }

  @override
  void addSeChe(SeCheMessageIconDelegate delegate) {
    logger?.d('add seche message icon delegate == $delegate');
    _scDelegate = delegate;
  }

}

extension _IDOMessageIconExt on _IDOMessageIcon {

  /// 强制更新应用名字
  Future<List<IDOAppIconItemModel>> _forceUpdateAppName() async {

    if (_isUpdate) {
      /// 如果正在更新返回之前的应用信息
      final model = await getCacheAppInfoModel();
      logger?.d("get app info complete 5 == ${model?.toJson()}");
      return model.items ?? [];
    }

    isUpdate = true;
    logger?.d("force the app name to be updated");

    _currentModel = await getCacheAppInfoModel();

    if (_currentModel == null) {
      isUpdate = false;
      logger?.d("no app names need to be updated");
      return [];
    }

    _currentModel?.items?.forEach((element) {
      element.isDownloadAppInfo = false;
      element.isUpdateAppName = false;
    });

    logger?.d("force get app info");

    /// 获取app信息
    final getInfo = GetAppInfo();
    await getInfo.startGetInfo(_currentModel!).first;

    logger?.d("force set app name");

    /// 设置app名字
    final setAppName = SetAppName();
    final items = _currentModel?.items?.where((element) {
      var isSetAppName = element.isUpdateAppName ?? false;
      return !isSetAppName;
    }).toList();

    await setAppName.setAppName(items as List<IDOAppInfo>).first;

    logger?.d("force set app name complete");
    isUpdate = false;

    logger?.d('ios save app info update state');

    /// 存储一次数据
    await storage?.saveIconInfoDataToDisk(_currentModel!);

    logger?.d("get app info complete 3 == ${_currentModel?.toJson()}");

    /// 需要重新赋值新路径
    _currentModel = await getCacheAppInfoModel();

    return Future(() => _currentModel?.items ?? []);
  }

  /// 存放图片目录
  Future<String> _getDirPath() async {
    // FIXME: 过早调用，storage为null，延迟500毫秒，等待storage初始化完成
    if (storage == null) {
      logger?.v('storage is null, wait for 500ms');
      return Future.delayed(const Duration(milliseconds: 500), () => _getDirPath());
    }
    return storage!.pathMessageIcon();
  }

  ///判断返回数据是否成功
  bool _isSuccessCallback(CmdResponse response) {
    if (response.code == 0 && response.json != null) {
      if (response.json!.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  /// 监听快速配置完成
  _listenFastSyncComplete() {
    logger?.d('devices need to register to listen fast sync complete');
    statusSdkNotification?.listen((value) {
      if (value == IDOStatusNotification.fastSyncCompleted) {
        /// 断线重连复位更新状态
        isUpdate = false;

        /// 快速配置完成
        if (Platform.isIOS) {
          logger?.d('ios first get app info when fast sync complete');
          /// 只支持iOS
          ios_getAllAppInfo();
        }
      } else if (value == IDOStatusNotification.protocolConnectCompleted) {
        /// 每次连接成功都清除一次已更新的事件ID集合
        _androidEventTypes.clear();
        if (_macAddress != _libMgr.macAddress) {
          logger?.d('replace the connected device _libMgr.macAddress ==${_libMgr.macAddress} _macAddress == $_macAddress');
          _defaultAppInfoList.clear();
        }
        _macAddress = _libMgr.macAddress;
      }
    });
  }

  /// 监听更新
  _listenUpdate() {
    logger?.d('devices need to register to listen');
    _coreMgr.listenDeviceStateChanged((code) {
      if (code == 12) {
        logger?.d('ios listen device state === $code');

        /// 监听iOS更新图标
        if (!_funTable.reminderMessageIcon) {
          logger?.d('message icon and name updates are not supported');
          return;
        }
        if (!Platform.isIOS) {
          logger?.d(
              'non-ios devices do not require message icon and name updates');
          return;
        }
        if (_isUpdate) {
          logger?.d('ios updating icons and names');
          return;
        }
        _getAppInfo();
      } else if (code == 13) {
        logger?.d('android listen device state === $code');

        /// 监听安卓更新图标
        if (!_funTable.reminderMessageIcon) {
          logger?.d('message icon and name updates are not supported');
          return;
        }
        if (!Platform.isAndroid) {
          logger?.d(
              'non-android devices do not require message icon and name updates');
          return;
        }
        if (_isUpdate) {
          logger?.d('android updating icons and names');
          return;
        }
        _getAppInfo();
      }
    });
  }

  /// 获取通知状态
  Future<bool> _getNoticeState() async {
    logger?.d('android start get notice state');

    final map_objc = {
      "version": 0,
      "items_num": 0,
      "operat": 3,
      "all_on_off": 0,
      "all_send_num": 1,
      "now_send_index": 1
    };

    final response = await _libMgr
        .send(evt: CmdEvtType.setNoticeMessageState, json: jsonEncode(map_objc))
        .first;
    if (_isSuccessCallback(response)) {
      final map = jsonDecode(response.json!) as Map<String, dynamic>;
      _currentModel?.version = 0;
      _currentModel?.iconWidth = 0;
      _currentModel?.iconHeight = 0;
      _currentModel?.colorFormat = 0;
      _currentModel?.blockSize = 0;
      final count = (map['items_num'] as int?) ?? 0;
      _currentModel?.totalNum = count;
      final items = (map['items'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList();

      final appInfoItems = await _noticeStateToAppInfo(items);

      final otherItems = appInfoItems?.where((element) {
        /// 13 通知只更新默认消息图标
        var isDownload = element.isUpdateAppIcon ?? false;
        var isDefault = element.isDefault ?? false;
        var isLocal = element.iconLocalPath.isNotEmpty;
        return !isDownload && isLocal && isDefault;
      }).toList() ??
          [];

      if (otherItems.isEmpty) {
        logger?.d('android does not need to update the icon');
        isUpdate = false;
        return Future(() => false);
      }

      _currentModel?.items = otherItems;

      logger?.d('android get cache app info complete 1 == ${_currentModel?.toJson()}');

      final model = IDOAppIconInfoModel(
          version: 0,
          iconHeight: 0,
          iconWidth: 0,
          colorFormat: 0,
          blockSize: 0,
          totalNum: count);
      model.items = appInfoItems;

      await storage?.saveIconInfoDataToDisk(model);

      final transfer = TransferIcon();
      transfer.addSeChe(_scDelegate);
      final complete = await transfer.tailorAndTransfer(_currentModel!).first;

      isUpdate = false;
      return Future(() => complete);
    } else {
      isUpdate = false;
      return Future(() => false);
    }
  }

  /// 通知状态转换APP信息模型
  Future<List<IDOAppIconItemModel>> _noticeStateToAppInfo(
      List<Map<String, dynamic>>? items) async {
    if (items == null || items.isEmpty) {
      return [];
    }
    List<Future<IDOAppIconItemModel>> futures = <Future<IDOAppIconItemModel>>[];
    for (var element in items) {
      final evt_type = (element?["evt_type"] as int?) ?? 0;

      /// 1：已经更新图标 2：未更新图标
      final pic_flag = (element?["pic_flag"] as int?) ?? 0;

      if (pic_flag == 1) {
        /// androidEventTypes 保存已经更新图标的事件ID类型
        if (!_androidEventTypes.contains(evt_type)) {
            _androidEventTypes.add(evt_type);
        }
      }

      /// 1：允许通知 2：静默通知 3：关闭通知 0：无效
      final notify_state = (element?["notify_state"] as int?) ?? 0;
      // logger?.d('android get notice state == $element');
      final future =
      GetAndroidAppInfo().getCurrentAppInfo(evt_type).then((value) async {
        final appInfo = value ?? {};
        final packName = appInfo?["pkgName"] ?? "";
        final appName = appInfo?["appName"] ?? "";
        final iconLocalPath = appInfo?["iconFilePath"] ?? "";
        final isDefault = (appInfo?["isDefault"] as bool?) ?? false;
        var need_sync = appInfo.isEmpty ? 0 : (pic_flag == 2 ? 1 : 0);

        /// 通知开关状态关闭不更新图标
        need_sync = (notify_state == 1 || notify_state == 2) ? need_sync : 0;

        final infoMap = {
          "evt_type": evt_type,
          "pack_name_array": packName,
          "app_name": appName,
          "icon_local_path": iconLocalPath,
          "item_id": 0,
          "msg_cout": 0,
          "country_code": "",
          "icon_cloud_path": "",
          "icon_local_path_big": iconLocalPath,
          "need_sync_icon": need_sync
        };

        if (!((appName is String && appName.isNotEmpty)&&
            (packName is String && packName.isNotEmpty)&&
            (iconLocalPath is String && iconLocalPath.isNotEmpty))) {
          /// 暂时这样处理，记录相关日志，定位问题
          logger?.d("android icon is null == $evt_type");
          final allItems = await GetAndroidAppInfo().getInstallAppInfoList(force: false);
          final oneItem = allItems.where((element) => element?["evt_type"] == evt_type).toList();
          if (oneItem.isNotEmpty) {
            final item = oneItem.first;
            final packName2 = item?["pkgName"] ?? "";
            final appName2 = item?["appName"] ?? "";
            final iconLocalPath2 = item?["iconFilePath"] ?? "";
            final isDefault2 = (item?["isDefault"] as bool?) ?? false;
            infoMap["pack_name_array"] = packName2;
            infoMap["app_name"] = appName2;
            infoMap["icon_local_path"] = iconLocalPath2;
            infoMap["icon_local_path_big"] = iconLocalPath2;
            infoMap["is_default"] = isDefault2;
            infoMap["need_sync_icon"] = need_sync;
          }
          logger?.d('android get app info == $infoMap');
        }
        final item = IDOAppIconItemModel.fromJson(infoMap);
        item.isDefault = isDefault;
        infoMap["is_default"] = isDefault;
        return item;
      });
      futures.add(future);
    }
    logger
        ?.d("android event type icon have been updated == $_androidEventTypes");
    return await Future.wait(futures);
  }

  /// 获取包名数据
  Future<bool> _getPackName() async {
    logger?.d('ios start get pack name country code == $ios_countryCode');
    final map_objc = {
      "operat_flag": (_packNum == 0 ? 0 : 1),
      "last_id": _lastId
    };
    final response = await _libMgr
        .send(evt: CmdEvtType.getPackName, json: jsonEncode(map_objc)).first;
    if (_isSuccessCallback(response)) {
      final map = jsonDecode(response.json!) as Map<String, dynamic>;
      if (map['items'] == null) {
        /// 固件异常，防止 items = null 的问题
        logger?.d('ios icon items is null');
        isUpdate = false;
        return Future(() => false);
      }
      map.putIfAbsent('country_code', () => ios_countryCode ?? 'US');
      final model = IDOAppIconInfoModel.fromJson(map);
      if (_packNum == 0) {
        _currentModel?.version = model.version;
        _currentModel?.iconWidth = model.iconWidth;
        _currentModel?.iconHeight = model.iconHeight;
        _currentModel?.colorFormat = model.colorFormat;
        _currentModel?.blockSize = model.blockSize;
        _currentModel?.totalNum = model.totalNum;
        _iconWidth = model.iconWidth ?? 60;
        logger?.d("get pack name icon width == $_iconWidth");
      }
      final items = _currentModel?.items
          ?.where((item1) =>
      (model.items
          ?.where((item2) => item1.packName == item2.packName)
          .toList()
          .length)! >
          1)
          .toList() ??
          [];
      if (items.isEmpty) {
        /// 防止固件返回多次相同包名数据
        final localModel = await getCacheAppInfoModel();
        var allItems = localModel.items ?? [];
        if (allItems.isEmpty) {
           allItems = await getDefaultAppInfo();
        }
        allItems.forEach((element1) {
          model.items?.forEach((element2) {
            if (element2.packName == element1.packName) {
              if ((element1.isDefault ?? false) &&
                  File(element1.iconLocalPath).existsSync()) {
                element2.isDownloadAppInfo = true;
              }
              element2.iconLocalPathBig = element1.iconLocalPathBig;
              element2.iconLocalPath = element1.iconLocalPath;
              element2.iconCloudPath = element1.iconCloudPath;
              element2.appName = element1.appName;
              element2.isDefault = element1.isDefault ?? false;
              element2.appName = element1.appName;
              element2.appVersion = element1.appVersion;
            }
          });
        });
        _currentModel?.items?.addAll(model.items ?? []);
        _lastId = 0;
        if ((_currentModel?.items)!.isNotEmpty) {
          _lastId = _currentModel?.items?.last.itemId ?? 0;
        }
        _packNum = _currentModel?.items?.length ?? 0;
      } else {
        logger?.e("have the same package name == ${model.toJson()}");
      }
      if (_packNum == 0) {
        logger?.d('no message icons need to be updated');
        isUpdate = false;
        return Future(() => false);
      }
      if (_packNum < (_currentModel?.totalNum ?? 0)) {
        ///延迟250秒递归执行获取包名数据
        await Future.delayed(const Duration(milliseconds: 250));
        return _getPackName();
      } else {
        //执行完成
        logger?.d("get app pack name info complete");
        isUpdate = true;
        return _dynamicUpdateAppIcon();
      }
    } else {
      isUpdate = false;
      return Future(() => false);
    }
  }

  /// ios 动态更新消息图标和APP名字
  Future<bool> _dynamicUpdateAppIcon() async {

    if (_isFirst) {
      logger?.d('ios save app info first');

      /// 存储一次数据
      await storage?.saveIconInfoDataToDisk(_currentModel!);
      _isFirst = false;

    }

    logger?.d('get app info');

    /// 获取app信息
    final getInfo = GetAppInfo();
    await getInfo.startGetInfo(_currentModel!).first;

    logger?.d('download icon');

    /// 下载图标并裁剪压缩
    final download = DownloadIcon();
    await download.startDownload(_currentModel!).first;

    logger?.d('ios save app info update state');

    /// 存储一次数据
    await storage?.saveIconInfoDataToDisk(_currentModel!);

    logger?.d('save app info complete');

    logger?.d('transfer icon');

    /// 传输图标
    final transfer = TransferIcon();
    transfer.addSeChe(_scDelegate);
    final success1 = await transfer.onlyStartTransfer(_currentModel!).first;

    logger?.d('transfer icon complete');

    logger?.d('set app name');

    /// 设置app名字
    final setAppName = SetAppName();
    final items = _currentModel?.items?.where((element) {
      var isSetAppName = element.isUpdateAppName ?? false;
      return !isSetAppName;
    }).toList();
    final success2 =
    await setAppName.setAppName(items as List<IDOAppInfo>).first;
    isUpdate = false;
    logger?.d('message icon transfer complete');
    return Future(() => (success1 && success2));
  }

  /// 主动获取APP信息
  Future<bool> _getAppInfo() async {
    if (_libMgr.isFastSynchronizing) {
      /// 快速配置中不执行
      logger?.d('get app info is fast synchronizing');
      return Future(() => false);
    }

    isUpdate = true;
    _lastId = 0;
    _packNum = 0;
    _currentModel = IDOAppIconInfoModel();
    _currentModel?.items = [];

    if (Platform.isIOS) {
      return _getPackName();
    } else {
      return _getNoticeState();
    }
  }
}


extension _IDOMessageIconFileOpt on _IDOMessageIcon {
  /// 文件复制，覆盖已存在文件
  copyFile(String orgFilePath, String newFilePage) async {
    final file = await File(orgFilePath).copy(newFilePage);
    if (!await file.exists()) {
      logger?.d('_IDOMessageIconFileOpt copy file fail $orgFilePath to $newFilePage');
      //throw UnsupportedError('copy file fail');
    }
  }

  /// 文件复制，校验文件hash, 覆盖已存在文件
  ///
  /// 返回 0 - 未修改， 1 - 修改(目标文件不存)， 2 - 修改(hash不一致)
  Future<int> copyFileChecksum(String orgFilePath, String newFilePage) async {
    final orgFile = File(orgFilePath);
    final newFile = File(newFilePage);
    final orgFileChecksum = await getFileChecksum(orgFile);
    final newFileChecksum = await getFileChecksum(newFile);
    if (orgFileChecksum != newFileChecksum) {
      logger?.v('_IDOMessageIconFileOpt copy $orgFilePath to $newFilePage');
      await copyFile(orgFilePath, newFilePage);
      if (newFileChecksum != null) {
        return 2;
      }
      return 1;
    }
    return 0;
  }

  /// 用官方的crypto库同步获取文件hash
  ///
  /// 耗时情况：206MB 1.3s / 39MB 0.3s / 1.3MB 10 ms
  Future<String?> getFileChecksum(File file) async {
    if (!await file.exists()) {
      logger?.e('getFileChecksum file not exists: ${file.path}');
      return null;
    }
    final stream = file.openRead();
    final hash = await md5.bind(stream).first;
    return hash.toString();
  }
}