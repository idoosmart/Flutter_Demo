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

  /// 实现set方法
  set isUpdate(bool value) {
    _isUpdate = value;
    logger?.d('message icon isUpdate state == $value');
    _streamState.add(_isUpdate);
  }

  /// 第一次获取包名数据
  bool _isFirst = false;

  /// app图标信息模型
  IDOAppIconInfoModel? _currentModel;

  @override
  void registerListenUpdate() async {
    ToolsImpl().listenNativeLog().listen((event) {
      logger?.d(event);
    });
    await GetAndroidAppInfo().copyAppIcon();
    _listenUpdate();
    _listenFastSyncComplete();
    final path = await getIconDirPath();
    _streamPath.add(path);
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
      final map_objc = {"operat_flag": 0, "last_id": 0};
      final response = await _libMgr
          .send(evt: CmdEvtType.getPackName, json: jsonEncode(map_objc))
          .first;
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
          "get default app info == ${element.appName} ${element.packName} ${element.iconCloudPath}");
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
        final existentItems = model.items?.where((element) {
          final oneApps = appInfo
              .where((item) => item.packName == element.packName)
              .toList();
          /// 过滤不存在的APP信息
          if (oneApps.isNotEmpty) {
            /// 赋值默认应用信息
            element.isDefault = true;
            element.appName = oneApps.first.appName;
          } else {
            element.isDefault = false;
          }

          // final isDefault = element.isDefault ?? false;
          final packName = element.packName;
          final appName = element.appName;
          var imagePath = element.iconLocalPathBig ?? '';
          if (imagePath.isNotEmpty) {
            imagePath = '$dirPath/${element.packName}${'_100'}.png';
            element.iconLocalPathBig = imagePath;
          }
          var imagePath1 = element.iconLocalPath;
          if (imagePath1.isNotEmpty) {
            imagePath1 = '$dirPath/${element.packName}${'_46'}.png';
            element.iconLocalPath = imagePath1;
          }
          if (   packName.isNotEmpty
              && appName.isNotEmpty
              && imagePath.isNotEmpty) {
            return true;
          } else {
            return false;
          }
        }).toList();
        model.items = existentItems;
      }
      return Future(() => model);
    } else {
      return Future(() => IDOAppIconInfoModel());
    }
  }

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
      logger?.d("get app info complete 1 == ${model.toJson()}");
      return Future(() => model.items ?? []);
    }

    if (_isUpdate) {
      logger?.d('updating icons and names');
      return Future(() => []);
    }

    _isFirst = true;

    /// 获取默认APP信息
    await _getAppInfo();

    logger?.d("get app info complete 2 == ${_currentModel?.toJson()}");

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
      logger?.d("android icon all app info == $items  force == $force");
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
      final items = (map['items'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList();
      final appInfoItems = await _noticeStateToAppInfo(items);

      final otherItems = appInfoItems.where((element) {
            var isDownload = element.isUpdateAppIcon ?? false;
            return (_cacheEventTypes.contains(element.evtType)) && !isDownload;
          }).toList() ??
          [];

      if (otherItems.isEmpty) {
        logger?.d('android does not need to update the icon');
        _cacheEventTypes.clear();
        isUpdate = false;
        return Future(() => false);
      }

      _currentModel?.items = otherItems;

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

    _currentModel = await storage?.loadIconInfoDataByDisk();

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

    return Future(() => _currentModel?.items ?? []);
  }

  /// 存放图片目录
  Future<String> _getDirPath() async {
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
    statusNotification?.listen((value) {
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
          GetAndroidAppInfo().getCurrentAppInfo(evt_type).then((value) {
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
        final item = IDOAppIconItemModel.fromJson(infoMap);
        item.isDefault = isDefault;
        infoMap["is_default"] = isDefault;
        //logger?.d('android get app info == $infoMap');
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
      map.putIfAbsent('country_code', () => ios_countryCode ?? 'US');
      final model = IDOAppIconInfoModel.fromJson(map);
      if (_packNum == 0) {
        _currentModel?.version = model.version;
        _currentModel?.iconWidth = model.iconWidth;
        _currentModel?.iconHeight = model.iconHeight;
        _currentModel?.colorFormat = model.colorFormat;
        _currentModel?.blockSize = model.blockSize;
        _currentModel?.totalNum = model.totalNum;
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
        final defaultList = await getDefaultAppInfo();
        defaultList.forEach((element1) {
          model.items?.forEach((element2) {
            if (element2.packName == element1.packName) {
              element2.iconLocalPathBig = element1.iconLocalPathBig;
              element2.iconLocalPath = element1.iconLocalPath;
            }
          });
        });
        _currentModel?.items?.addAll(model.items ?? []);
        _lastId = _currentModel?.items?.last.itemId ?? 0;
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
        await _setLocalPathWithPackName();
        return _dynamicUpdateAppIcon();
      }
    } else {
      isUpdate = false;
      return Future(() => false);
    }
  }

  /// 赋值本地存储图片地址
  Future<bool> _setLocalPathWithPackName() async {
    final dirPath = await _getDirPath();
    _currentModel?.items?.forEach((element) {
      final filePath1 = "$dirPath/${element.packName}${'_100'}.png";
      final filePath2 = "$dirPath/${element.packName}${'_46'}.png";
      final file1 = File(filePath1);
      final file2 = File(filePath2);
      if (!file1.existsSync()) {
        element.iconLocalPathBig = '';
      } else {
        logger?.d("local big image is exist pack name == ${element.packName}");
        element.iconLocalPathBig = filePath1;
      }
      if (!file2.existsSync()) {
        element.iconLocalPath = '';
      } else {
        logger
            ?.d("local smart image is exist pack name == ${element.packName}");
        element.iconLocalPath = filePath2;
      }
    });
    return Future(() => true);
  }

  /// ios 动态更新消息图标和APP名字
  Future<bool> _dynamicUpdateAppIcon() async {

    if (_isFirst) {
      logger?.d('ios save app info first');

      /// 赋值更新状态
      final appInfo = await getDefaultAppInfo();
      _currentModel?.items?.forEach((element) {
        final oneApps = appInfo
            .where((item) => item.packName == element.packName)
            .toList();
        if (oneApps.isNotEmpty) {
          element.isDefault = true;
          element.appName = oneApps.first.appName;
        } else {
          element.isDefault = false;
        }
      });

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

    // logger?.d('download icon complete to json == ${_currentModel?.toJson()}');

    /// 赋值更新状态
    final appInfo = await getDefaultAppInfo();
    _currentModel?.items?.forEach((element) {
      final oneApps = appInfo
          .where((item) => item.packName == element.packName)
          .toList();
      if (oneApps.isNotEmpty) {
        element.isDefault = true;
        element.appName = oneApps.first.appName;
      } else {
        element.isDefault = false;
      }
    });

    logger?.d('ios save app info update state');

    /// 存储一次数据
    await storage?.saveIconInfoDataToDisk(_currentModel!);

    logger?.d('save app info complete');

    logger?.d('transfer icon');

    /// 传输图标
    final transfer = TransferIcon();
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
