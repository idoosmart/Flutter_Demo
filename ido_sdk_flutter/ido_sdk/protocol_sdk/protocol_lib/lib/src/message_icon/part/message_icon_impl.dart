part of '../ido_message_icon.dart';

class _IDOMessageIcon implements IDOMessageIcon {
  static final _instance = _IDOMessageIcon._internal();
  _IDOMessageIcon._internal();
  factory _IDOMessageIcon() => _instance;
  late final _coreMgr = IDOProtocolCoreManager();
  late final _libMgr = IDOProtocolLibManager();
  late final _funTable = _libMgr.funTable;

  /// 当前获取累加个数
  int _packNum = 0;
  /// 获取最后一个应用id
  int _lastId = 0;
  /// 是否在更新中
  bool _isUpdate = false;

  /// 默认包名集合
  final List<String> _packNames = ['com.apple.MobileSMS','com.apple.mobilecal','com.apple.mobilemail','com.apple.missed.mobilephone',
    'com.tencent.xin','com.tencent.mqq','com.google.ios.youtube','com.facebook.Facebook','net.whatsapp.WhatsApp','com.atebits.Tweetie2',
    'com.tumblr.tumblr','com.burbn.instagram','com.linkedin.LinkedIn','com.facebook.Messenger','com.toyopagroup.picaboo',
    'jp.naver.line','com.vk.vkclient','com.viber','com.skype.skype','com.iwilab.KakaoTalk','pinterest','ph.telegra.Telegraph',
    'com.zhiliaoapp.musically','com.ss.iphone.ugc.Ame','net.whatsapp.WhatsAppSMB','com.microsoft.Office.Outlook','com.yahoo.Aerogram',
    'com.ido.life','com.ss.iphone.ugc.Aweme','com.ss.iphone.ugc.Ame','com.ido.standrandProject','com.apple.reminders',
    'sms','calendar','email','miss_call'];

  /// app图标信息模型
  IDOAppIconInfoModel? _currentModel;

  @override
  void ios_registerListenUpdate() {
    if (!Platform.isIOS) {
      return;
    }
    _listenUpdate();
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
  bool get ios_updating => _isUpdate;

  @override
  List<String>? ios_defaultPackNames() => _packNames;

  @override
  Stream<bool> android_transferAppIcon(List<IDOAppInfo> items) {
    if (!Platform.isAndroid) {
      logger?.d('non-android devices cannot execute this interface');
      final stream = CancelableOperation.fromFuture(
          Future(()=>false)).asStream();
      return stream;
    }
    if (!_funTable.reminderMessageIcon) {
      logger?.d('message icon and name updates are not supported');
      final stream = CancelableOperation.fromFuture(
          Future(()=>false)).asStream();
      return stream;
    }
    if (_isUpdate) {
      logger?.d('android updating icons');
      final stream = CancelableOperation.fromFuture(
          Future(()=>false)).asStream();
      return stream;
    }
    _isUpdate = true;
    final stream = CancelableOperation.fromFuture(
        Future(() {
          return _tailorTransfer(items).first.then((value) {
            _isUpdate = false;
            return value;
          });
        })).asStream();
    return stream;

  }

  @override
  Future<String> ios_getIconDirPath() {
    return _getDirPath();
  }

  @override
  Future<bool> ios_resetIconInfoData() async {
    storage?.cleanIconInfoData();
    final dirPath = await _getDirPath();
    final success = await storage?.removeDir(absoluteDirPath: dirPath) ?? false;
    return Future(() => success);
  }

  @override
  Future<IDOAppIconInfoModel> ios_getInfoModel() async {
    final model = await storage?.loadIconInfoDataByDisk();
    if (model != null) {
      return Future(() => model);
    }else {
      return Future(() => IDOAppIconInfoModel());
    }
  }

  @override
  Stream<bool> ios_getDefaultAppInfo() {
    if (!Platform.isIOS) {
      logger?.d('non-ios devices cannot execute this interface');
      final stream = CancelableOperation.fromFuture(
          Future(()=>false)).asStream();
      return stream;
    }
    if (!_funTable.reminderMessageIcon) {
      logger?.d('message icon and name updates are not supported');
      final stream = CancelableOperation.fromFuture(
          Future(()=>false)).asStream();
      return stream;
    }
    if (_isUpdate) {
      logger?.d('updating icons and names');
      final stream = CancelableOperation.fromFuture(
          Future(()=>false)).asStream();
      return stream;
    }
    final stream = CancelableOperation.fromFuture(
        _getAppInfo()).asStream();
    return stream;
  }

}


extension _IDOMessageIconExt on _IDOMessageIcon {

  /// 存放图片目录
  Future<String> _getDirPath() async {
    return storage!.pathMessageIcon();
  }

  ///判断返回数据是否成功
  bool _isSuccessCallback(CmdResponse response) {
    if (response.code == 0
        && response.json != null
    ) {
      if (response.json!.isNotEmpty) {
          return true;
      }else {
          return false;
      }
    }else {
      return false;
    }
  }

  /// 监听更新
   _listenUpdate() {
     logger?.d('iOS devices need to register to listen');
      _coreMgr.listenDeviceStateChanged((code) {
        if(code == 12) {
          if (!_funTable.reminderMessageIcon) {
            logger?.d('message icon and name updates are not supported');
            return;
          }
          if (!Platform.isIOS) {
            logger?.d('non-ios devices do not require message icon and name updates');
            return;
          }
          if (_isUpdate) {
            logger?.d('updating icons and names');
            return;
          }
          _getAppInfo();
        }
      });
   }

   /// 获取包名数据
  Future<bool> _getPackName() async {
    logger?.d('start get pack name');
     final map_objc = {
       "operat_flag" : (_packNum == 0 ? 0 : 1),
       "last_id" : _lastId
     };
     final response = await _libMgr.send(evt:CmdEvtType.getPackName,json: jsonEncode(map_objc)).first;
     if (_isSuccessCallback(response)) {
       final map = jsonDecode(response.json!) as Map<String,dynamic>;
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
       _currentModel?.items?.addAll(model?.items ?? []);
       _lastId  = _currentModel?.items?.last?.itemId ?? 0;
       _packNum = _currentModel?.items?.length ?? 0;
       if (_packNum == 0) {
         logger?.d('no message icons need to be updated');
         return Future(() => false);
       }
       if (_packNum < (_currentModel?.totalNum ?? 0)) { //延迟250秒递归执行获取包名数据
         await  Future.delayed(Duration(milliseconds:250));
         return _getPackName();
       }else { //执行完成
         _isUpdate = true;
        final value = await storage?.loadIconInfoDataByDisk();
         if (value != null) {
           value.items?.forEach((element) {
             var packName = element.packName;
             var path1 = element.iconLocalPathBig ?? '';
             var path2 = element.iconLocalPath ?? '';
             _setLocalPathWithPackName(packName, path1, path2);
           });
         }
         return _dynamicUpdateAppIcon();
       }
     }else {
       _isUpdate = false;
       return Future(() => false);
     }
   }

   /// 赋值本地存储图片地址
   _setLocalPathWithPackName(String packName,String bigPath,String smallPath) {
      _currentModel?.items?.forEach((element) {
         if (packName == element.packName) {
            final file = File(bigPath);
            if (!file.existsSync()) { ///图片不存在
              element.iconLocalPathBig = '';
              element.iconLocalPath = '';
            }else {
              element.iconLocalPathBig = bigPath;
              element.iconLocalPath = smallPath;
            }
         }
      });
   }

  Future<bool> _dynamicUpdateAppIcon() async {

    logger?.d('get app info');
    /// 获取app信息
      final getInfo = GetAppInfo();
      await getInfo.startGetInfo(_currentModel!).first;

    logger?.d('get app info complete to json == ${_currentModel!.toJson()}');

    logger?.d('download icon');
    /// 下载图标并裁剪压缩
      final download = DownloadIcon();
      await download.startDownload(_currentModel!).first;

    logger?.d('download icon complete to json == ${_currentModel!.toJson()}');

    logger?.d('save app info');
      /// 存储一次数据
      await storage?.saveIconInfoDataToDisk(_currentModel!);

    logger?.d('save app info complete');

    logger?.d('transfer icon');
      /// 传输图标
      final transfer = TransferIcon();
      final success1 = await transfer.ios_startTransfer(_currentModel!).first;

    logger?.d('transfer icon complete');

    logger?.d('set app name');
      /// 设置app名字
      final setAppName = SetAppName();
      final items = _currentModel?.items?.where((element) {
        var isSetAppName = element.isUpdateAppName ?? false;
        return !isSetAppName;
      }).toList();
      final success2 = await setAppName.setAppName(items as List<IDOAppInfo>).first;
      _isUpdate = false;
    logger?.d('message icon transfer complete');
      return Future(() => (success1 && success2));
   }

  /// android 裁剪图标传输
  Stream<bool> _tailorTransfer(List<IDOAppInfo> items) {
    logger?.d('start transfer android message icon');
      final transfer = TransferIcon();
      return transfer.tailor_Transfer(items);
  }

  /// 主动获取APP信息
  Future<bool> _getAppInfo() async {
    _isUpdate = true;
    _lastId = 0;
    _packNum = 0;
    _currentModel = IDOAppIconInfoModel();
    _currentModel?.items = [];
     return _getPackName();
  }

}