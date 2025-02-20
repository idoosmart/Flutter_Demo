import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import '../../../private/local_storage/local_storage.dart';
import '../../../../protocol_lib.dart';
import '../../../private/logger/logger.dart';
import '../../../private/local_storage/ido_storage.dart';

import '../constants/dial_constants.dart';
import '../model/dial_list_obj.dart';
import '../model/sdk/dial_list_v3_obj.dart';
import '../model/sdk/screen_info_obj.dart';
import 'dial_sdk_helper.dart';
import 'ido_file_manager.dart';

class DialManager {
  StreamSubscription? deviceStatusStream;

  StreamSubscription? dialStatutream;

  // StreamSubscription? netSubscription;

  ///可安装表盘数量
  int installableDialNumber = 0;

  ///可安装表盘数量
  int totalNum = 0;

  ///安装的数量
  int installedNum = 0;

  ///表盘的已经使用容量
  int installedSize = 0;

  ///表盘的总容量 单位：字节
  int totalSize = 0;

  ///最大的可用表盘下载连续空间大小
  int maxDownloadSpaceSize = 0;

  ///壁纸表盘的总个数 2.0.1
  int wallpaperNum = 0;

  ///当前表盘name 固件名
  String currentDialName = '';

  String currentDialNamePath = '';

  ///当前设备的表盘的存储相关目录，eg:dial/7453
  String dialRootPath = '';

  String dialMemberOrCount = '--';

  String myDialListMemberOrCount = '--';

  ///我的表盘数据源-
  List<FaceListItems> myDialList = [];

  ///从固件获取到的表盘名
  List<String> otaFaceNames = [];

  ///通话中，无法安装表盘
  bool isInCalling = false;

  ///表盘安装中
  bool isInstalling = false;

  ///当前表盘空间处理的时长。只有在存在有返回错误码是24或者25的情况下才可以使用这个属性
  int organizeSpaceTime = 0;

  ///最大发送第一表盘Event的次数 2次
  int _fireFirstDialUriCount = 0;

  ///表盘相关属性
  late FirmwareInfo info;
  //SDK 表盘列表
  DialListV3Obj? dialListV3Obj = DialListV3Obj(0, 0, [], 0, 0, '', 0, 0, 0, 0, 0, 0, 0);
  //SDK 屏幕信息
  ScreenInfoObj? screenInfoObj = ScreenInfoObj(0, '', 0, 0, 0, 0);

  /// 单例公开访问点
  factory DialManager() => _sharedInstance();

  /// 静态私有成员，没有初始化
  static final DialManager _instance = DialManager._();

  /// 私有构造函数
  DialManager._() {
    updateFirmwareInfo();
    _registerListener();
  }

  ///更新设备信息
  void updateFirmwareInfo() {
    //初始化一些数据信息
    installableDialNumber = 0;
    totalNum = 0;
    installedSize = 0;
    totalSize = 0;
    maxDownloadSpaceSize = 0;
    wallpaperNum = 0;
    currentDialName = '';
    currentDialNamePath = '';
    dialMemberOrCount = '--';
    myDialListMemberOrCount = '--';
    myDialList = [];
    otaFaceNames = [];
    isInCalling = false;
    organizeSpaceTime = 0;
    _fireFirstDialUriCount = 0;

    info = FirmwareInfo();
    IDODeviceInfo deviceInfo = libManager.deviceInfo;

    /// 设备类型 0：无效；1：手环；2：手表
    int deviceType = deviceInfo.deviceType;
    if (deviceType == 1) {
      info.shape = DialShapeType.bracelet;
    } else {
      /// 设备形状类型 0：无效；1：圆形；2：方形的； 3：椭圆
      int deviceShapeType = deviceInfo.deviceShapeType;

      switch (deviceShapeType) {
        case 1:
          info.shape = DialShapeType.circle;
          break;
        case 2:
          info.shape = DialShapeType.rectangle;
          break;
        default:
          info.shape = DialShapeType.rectangle;
      }
    }
    final key = '${libManager.deviceInfo.macAddress}${DialConstants.kDeviceScreenInfo}';
    final screenInfoJson = IDOKvEngine.withDefault().getString(key);
    if (screenInfoJson.isNotEmpty) {
      ScreenInfoObj obj = ScreenInfoObj.fromJson(json.decode(screenInfoJson));
      screenInfoObj = obj;
      info.size = Size(obj.width * 1.0, obj.height * 1.0);
      logger?.i("Watch: 屏幕信息缓存 ${obj.toJson()}");
    } else {
      info.size = const Size(0, 0);
    }
    info.deviceName = deviceInfo.deviceName ?? '';
    info.deviceId = deviceInfo.deviceId.toString();
    info.mac = deviceInfo.macAddressFull ?? '';
    final dialMainVersion = deviceInfo.dialMainVersion.toString();

    info.appFaceVersion = dialMainVersion;
    info.otaVersion = getDeviceOtaVersion(deviceInfo);
    info.supportFaceVersion = dialMainVersion;

    logger?.i('Watch: 0.3设备信息更新${info.deviceId}, ${info.deviceName}, ${info.mac}');
    // _instance.dialRootPath = await DialManager.getDialRootPath();

    //EventBus.getDefault().fire(DialStatusEvent(status: DialEventStatus.didUpdatedFirmwareInfo));

    getDialSDKInfo();
  }

  String getDeviceOtaVersion(IDODeviceInfo deviceInfo) {
    if (libManager.funTable.getBleAndBtVersion) {
      return '${deviceInfo.fwVersion1.toString()}'
          '.${deviceInfo.fwVersion2.toString().padLeft(2, '0')}'
          '.${deviceInfo.fwVersion3.toString().padLeft(2, '0')}';
    }
    return "${deviceInfo.firmwareVersion}";
  }

  ///表盘的根目录
  static Future<String> getDialRootPath(String deviceId) async {
    String path = await DialConstants.dialStoreFolderPath(deviceId);
    await storage?.createDir(absoluteDirPath: path);
    return path;
  }

  ///表盘的根目录
  static Future<String> getDialRootPathSync(String deviceId) async {
    String path = await DialConstants.dialStoreFolderPath(deviceId);
    await storage?.createDir(absoluteDirPath: path);
    return path;
  }

  ///安装表盘成功后，刷新数据源
  static installDialSuccess(String otaFaceName) {
    _instance.currentDialName = otaFaceName;
    // EventBus.getDefault().fire(DialStatusEvent(status: DialEventStatus.didGetFirstDialUri));
    // EventBus.getDefault().fire(DialStatusEvent(status: DialEventStatus.install));
  }

  ///卸载表盘成功后，刷新数据源
  static uninstallDialSuccess(String otaFaceName) {
    // EventBus.getDefault().fire(DialStatusEvent(status: DialEventStatus.didGetFirstDialUri));
    // EventBus.getDefault().fire(DialStatusEvent(status: DialEventStatus.delete));
  }

  ///设置第一表盘成功后，刷新数据源
  static setFirstDialSuccess(String otaFaceName) {
    // if (otaFaceName.isEmpty) {
    //   return;
    // }
    _instance.currentDialName = otaFaceName;
    // EventBus.getDefault().fire(DialStatusEvent(status: DialEventStatus.didGetFirstDialUri));
    // EventBus.getDefault().fire(DialStatusEvent(status: DialEventStatus.setFirst));
  }

  // ///获取 并缓存当前使用的表盘的路径或ImageUrl
  // Future<String> getCurrentNamePath() async {
  //   String faceName = _instance.currentDialName;
  //   logger?.i('Watch: 获取到当前表盘: $faceName');
  //
  //   if (faceName.isEmpty) {
  //     return '';
  //   }
  //   if (faceName == kPhotoOtaFaceName) {
  //     if (_instance.dialRootPath.isEmpty) {
  //       _instance.dialRootPath = await DialManager.getDialRootPath(info.deviceId);
  //     }
  //     const wallpaperImgNameKey = DialConstants.kWallpaperPhotoCacheKey;
  //     String wallpaperImgName = await storage?.getString(key: wallpaperImgNameKey) ?? '';
  //     String path = '${_instance.dialRootPath}/$wallpaperImgName';
  //     if (wallpaperImgName.isNotEmpty && File(path).existsSync()) {
  //       _instance.currentDialNamePath = path;
  //     } else {
  //       return '';
  //     }
  //   } else {
  //     if (otaInfoProvider.checkIsOtaing() || faceName.isEmpty) {
  //       return '';
  //     }
  //
  //     List<DialDetailObj> myFaceList = await DialInfoUtils.fetchMyFaceList([faceName]);
  //     if (myFaceList.isEmpty) {
  //       return '';
  //     }
  //     DialDetailObj item = myFaceList.first;
  //     // String type = item?.customFaceType ?? '';
  //     DialType type = checkTheDialType(item.faceType, item.customFaceType ?? '');
  //     //云照片表盘的图片，设置后存储到previewSet，默认使用preview
  //     if (type == DialType.cloudPhoto) {
  //       if (DialManager().dialRootPath.isEmpty) {
  //         final path = await DialManager.getDialRootPath(info.deviceId);
  //         DialManager().dialRootPath = path;
  //       }
  //       final previewImgNameKey =
  //           "${DialConstants.kCloudPhotoCachePreviewKey}-${libManager.deviceInfo.macAddress}-${item.otaFaceName ?? ""}";
  //       String previewImgName = IDOKvEngine.withDefault().getString(previewImgNameKey);
  //       String filePath = '${_instance.dialRootPath}/${item.otaFaceName}/images/$previewImgName';
  //       if (IDOFileManager.existFile(filePath)) {
  //         _instance.currentDialNamePath = filePath;
  //       } else {
  //         filePath = '${_instance.dialRootPath}/${item.otaFaceName}/images/preview.png';
  //         if (IDOFileManager.existFile(filePath)) {
  //           _instance.currentDialNamePath = filePath;
  //         } else {
  //           _instance.currentDialNamePath = item.imageUrl;
  //         }
  //       }
  //     } else {
  //       _instance.currentDialNamePath = item.imageUrl;
  //     }
  //   }
  //   final key = '${libManager.deviceInfo.macAddress}${DialConstants.kDialFacePathKey}';
  //   IDOKvEngine.withDefault().putString(key, _instance.currentDialNamePath);
  //   logger?.i('Watch: 保存表盘的 putString   $key  path:${_instance.currentDialNamePath}');
  //   logger?.i('Watch: 0.8当前表盘地址 $key ${_instance.currentDialNamePath} $_fireFirstDialUriCount');
  //
  //   if (_fireFirstDialUriCount < 2) {
  //     //EventBus.getDefault().fire(DialStatusEvent(status: DialEventStatus.didGetFirstDialUri));
  //     _fireFirstDialUriCount += 1;
  //   } else {
  //     _fireFirstDialUriCount = 0;
  //   }
  //
  //   final dao = DBManager.instance.database.deviceDialInfoDao;
  //   var bean = await dao.selectByMacAddress(libManager.deviceInfo.macAddress);
  //   bean ??= DeviceDialInfoBean(macAddress: libManager.deviceInfo.macAddress);
  //
  //   bean.otaFaceNames = DialManager().otaFaceNames.join(',');
  //   bean.firstDialName = faceName;
  //   bean.firstDialUri = _instance.currentDialNamePath;
  //
  //   await dao.insert(bean);
  //   return _instance.currentDialNamePath;
  // }

  /// 静态、同步、私有访问点
  static DialManager _sharedInstance() {
    return _instance;
  }

  static bool isCircleShape() {
    return _instance.info.shape == DialShapeType.circle;
  }

  ///从固件获取表盘列表
  void getDialSDKInfo() async {
    dialRootPath = await DialManager.getDialRootPath(info.deviceId);

    // IDOProtocolLibManager.initLog(writeToFile: true, outputToConsole: true);
    //优先赋值缓存的数据
    // final dao = DBManager.instance.database.deviceDialInfoDao;
    // DeviceDialInfoBean? bean =
    //     await dao.selectByMacAddress(DialManager().info.mac);
    // if (bean != null) {
    //   DialManager().otaFaceNames = bean.otaFaceNames.split(',');
    // }
    //是否是v3协议
    if (libManager.funTable.getNewWatchList) {
      await DialSDKHelper.getV3DialList();
    } else {
      await DialSDKHelper.getV2DialList();
    }
    await DialSDKHelper.getScreenInfo();
    logger?.i('Watch: 0.4从固件获取表盘列表');
  }
}

///设备表盘信息
class FirmwareInfo {
  ///表盘相关属性

  ///表盘形状
  late DialShapeType shape;

  ///表盘物理尺寸大小
  late Size size;

  ///设备ID
  late String deviceId;

  ///设备
  late String deviceName;

  ///设备Mac地址
  late String mac;

  ///app支持框架版本
  late String appFaceVersion;

  ///当前固件版本
  late String otaVersion;

  ///当前表盘框架版本，返回配置的常规表盘和符合条件的自定义表盘
  late String supportFaceVersion = '';

  FirmwareInfo([
    this.shape = DialShapeType.rectangle,
    this.size = const Size(240, 280),
    this.deviceId = '',
    this.deviceName = '',
    this.mac = '',
    this.appFaceVersion = '',
    this.otaVersion = '',
    this.supportFaceVersion = '',
  ]);

  reset() {
    shape = DialShapeType.rectangle;
    size = const Size(240, 280);
    deviceId = '';
    deviceName = '';
    mac = '';
    appFaceVersion = '';
    otaVersion = '';
    supportFaceVersion = '';
  }
}


extension _DialManagerExtension on DialManager {

  void _registerListener() {

    // dialStatutream = EventBus.getDefault().on<DialStatusEvent>().listen((event) {
    //   switch (event.status) {
    //     case DialEventStatus.shouldGetDialListFromFirmware:
    //       getDialSDKInfo();
    //       break;
    //     case DialEventStatus.didGetDialListFromFirmware:
    //       getCurrentNamePath();
    //       break;
    //     default:
    //   }
    // });

    // 文件传输状态变更
    libManager.transFile.listenTransFileTypeChanged((fileType) {
      if (fileType == null) {
        // 空闲状态
        //_statusModel.isTransBusy = false;
      } else if (fileType != FileTransType.epo) {
        // 不是EPO文件
        //_statusModel.isTransBusy = true;
      }
    });

    // 连接状态变更，切换设备
    libManager.listenConnectStatusChanged((isConnected) {
      // _statusModel.isConnected = isConnected;
      // if (isConnected) {
      //   if (_statusModel.lastMacAddress != libManager.macAddress) {
      //     stop(); // 切换设备，停止epo升级（如果有）
      //   }
      //   _statusModel.lastMacAddress = libManager.macAddress;
      // } else {
      //   _statusModel.lastMacAddress = '';
      // }
    });

    // 快速配置
    libManager.listenStatusNotification((status) {
      if (status == IDOStatusNotification.fastSyncCompleted ||
          status == IDOStatusNotification.fastSyncFailed) {
        logger?.i('Watch: 0.2监听到设备切换完成');
        updateFirmwareInfo();
      }
    });

    // 数据同步
    libManager.syncData.listenSyncStatus().listen((event) {
      // if (event == SyncStatus.syncing && _statusModel.isUpgrading) {
      //   //stop(); // 可并行执行epo升级，先不停止
      // } else if (event == SyncStatus.finished && !_statusModel.isUpgrading) {
      //   _startAutoUpgradeTimer();
      // }
    });

    // 设备解绑
    libManager.deviceBind.listenUnbindNotification((macAddress) async {
      if (macAddress.isNotEmpty) {
        //await storage?.removeOtaInfo(macAddress);
      }
    });
  }
}