import 'dart:async';

import 'package:protocol_lib/protocol_lib.dart';

import '../pigeon_generate/message_icon.g.dart';

class MessageIconImpl extends MessageIcon {

  final _messageIconDelegate = MessageIconDelegate();

  MessageIconImpl() {
    libManager.messageIcon.listenUpdateState().listen((event) {
       _messageIconDelegate.listenMessageIconState(event);
    });
    libManager.messageIcon.listenIconDirPath().listen((event) {
       _messageIconDelegate.listenIconDirPath(event);
    });
  }

  @override
  Future<AppIconInfoModel> getCacheAppInfoModel() async {
    final rs = await libManager.messageIcon.getCacheAppInfoModel();
    return AppIconInfoModel(
        version: rs.version,
        iconWidth: rs.iconWidth,
        iconHeight: rs.iconHeight,
        colorFormat: rs.colorFormat,
        blockSize: rs.blockSize,
        totalNum: rs.totalNum,
        items: rs.items?.map((e) => e.toAppIconItemModel()).toList());
  }

  @override
  Future<List<AppIconItemModel?>> getDefaultAppInfo() async {
    final rs = await libManager.messageIcon.getDefaultAppInfo();
    return rs.map((e) => e.toAppIconItemModel()).toList();
  }

  @override
  Future<String> getIconDirPath() async {
    return libManager.messageIcon.getIconDirPath();
  }


  @override
  void registerListenUpdate() {
    libManager.messageIcon.registerListenUpdate();
  }

  @override
  Future<bool> resetIconInfoData(String macAddress, bool deleteIcon) async {
    return libManager.messageIcon
        .resetIconInfoData(macAddress: macAddress, deleteIcon: deleteIcon);
  }

  @override
  Future<bool> updating() {
    return libManager.messageIcon.updating;
  }

  @override
  Future<List<AppIconItemModel?>> firstGetAllAppInfo(bool force) async {
    final rs = await libManager.messageIcon.firstGetAllAppInfo(force: force);
    return rs.map((e) => e.toAppIconItemModel()).toList();
  }

  @override
  Future<bool> androidSendMessageIconToDevice(int eventType) {
    return libManager.messageIcon.androidSendMessageIconToDevice(eventType);
  }

  @override
  void iOSConfig(String? countryCode, String? baseUrlPath, String? appKey, int? language) {
    libManager.messageIcon.ios_appKey = appKey;
    libManager.messageIcon.ios_baseUrlPath = baseUrlPath;
    libManager.messageIcon.ios_countryCode = countryCode;
    libManager.messageIcon.ios_languageUnit = language;
  }

  @override
  void setDefaultAppInfoList(List<AppIconItemModel?> models) {
    final list = models.map((e) => e!.toIDOAppIconItemModel()).toList();
    libManager.messageIcon.setDefaultAppInfoList(list);
  }
}

extension _IDOAppIconItemModelExt on IDOAppIconItemModel {
  AppIconItemModel toAppIconItemModel() {
    return AppIconItemModel(
        evtType: evtType,
        packName: packName,
        appName: appName,
        iconLocalPath: iconLocalPath,
        itemId: itemId,
        msgCount: msgCount,
        iconCloudPath: iconCloudPath,
        state: state,
        iconLocalPathBig: iconLocalPathBig,
        countryCode: countryCode,
        isDownloadAppInfo: isDownloadAppInfo,
        isUpdateAppName: isUpdateAppName,
        isUpdateAppIcon: isUpdateAppIcon,
        appVersion: appVersion,
        isDefault: isDefault);
  }
}

extension _AppIconItemModelExt on AppIconItemModel {
  IDOAppIconItemModel toIDOAppIconItemModel() {
    return IDOAppIconItemModel(
        evtType: evtType ?? 0,
        packName: packName ?? "",
        appName: appName ?? "",
        iconLocalPath: iconLocalPath ?? "",
        itemId: itemId,
        msgCount: msgCount,
        iconCloudPath: iconCloudPath,
        state: state,
        iconLocalPathBig: iconLocalPathBig,
        countryCode: countryCode,
        appVersion: appVersion);
  }
}