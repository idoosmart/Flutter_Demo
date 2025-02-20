
import 'package:protocol_lib/src/private/logger/logger.dart';

class IDOAppInfo {
  /// 事件类型
  int evtType;

  /// 应用包名
  String packName;

  /// 应用名称
  String appName;

  /// icon 沙盒小图标地址 (设备使用)
  String iconLocalPath;

  IDOAppInfo({
    required this.evtType,
    required this.packName,
    required this.appName,
    required this.iconLocalPath
  });

}


class IDOAppIconItemModel extends IDOAppInfo {
  /// 每个包名给一个id 由0开始
  int? itemId;

  /// 消息收到次数
  int? msgCount;

  /// icon 云端地址
  String? iconCloudPath;

  /// 消息图标更新状态
  /// 0：不需要更新 1：需要更新icon ，2：需要更新app名，3：icon和app都需要更新
  int? state;

  /// icon 沙盒大图标地址 (app 列表上展示)
  String? iconLocalPathBig;

  /// 国家编码
  String? countryCode;

  /// 应用版本号
  String? appVersion;

  /// 是否已经下载APP信息
  bool? isDownloadAppInfo;

  /// 是否已经更新应用名称
  bool? isUpdateAppName;

  /// 是否已经更新应用图标
  bool? isUpdateAppIcon;

  /// 是否为默认应用
  bool? isDefault;

  IDOAppIconItemModel({
    required super.evtType,
    required super.packName,
    required super.appName,
    required super.iconLocalPath,
    this.itemId,
    this.msgCount,
    this.countryCode,
    this.iconCloudPath,
    this.iconLocalPathBig,
    this.state,
    this.appVersion
  });

  factory IDOAppIconItemModel.fromJson(Map<String, dynamic> json) {
   final model =  IDOAppIconItemModel(
      evtType: json['evt_type'] as int? ?? 0,
      packName: (json['pack_name_array'] as String? ?? '').trim(),
      appName: json['app_name'] as String? ?? '',
      iconLocalPath: json['icon_local_path'] as String? ?? '',
      itemId: json['item_id'] as int?,
      msgCount: json['msg_cout'] as int?,
      countryCode: json['country_code'] as String? ?? '',
      iconCloudPath: json['icon_cloud_path'] as String? ?? '',
      iconLocalPathBig: json['icon_local_path_big'] as String? ?? '',
      state: json['need_sync_icon'] as int?,
      appVersion: json['app_version'] as String? ?? ''
    );
   if (model.packName == 'com.apple.MobileSMS') {
     //0：不需要更新 1：需要更新icon ，2：需要更新app名，3：icon和app都需要更新
     final state = json['need_sync_icon'] as int?;
     model.isUpdateAppName = true;
     model.isDownloadAppInfo = true;
     model.isUpdateAppIcon = state == 0 || state == 2;
     model.appName = 'SMS';
   }else if (model.packName == 'com.apple.missed.mobilephone') {
     //0：不需要更新 1：需要更新icon ，2：需要更新app名，3：icon和app都需要更新
     final state = json['need_sync_icon'] as int?;
     model.isUpdateAppName = true;
     model.isDownloadAppInfo = true;
     model.isUpdateAppIcon = state == 0 || state == 2;
     model.appName = 'Missed calls';
   }else if (model.packName == 'others') { /// SKG 2021-07-30
     //0：不需要更新 1：需要更新icon ，2：需要更新app名，3：icon和app都需要更新
     final state = json['need_sync_icon'] as int?;
     model.isUpdateAppName = true;
     model.isDownloadAppInfo = true;
     model.isUpdateAppIcon = true;
     model.appName = 'Others';
   }else {
     if (model.packName == "com.ss.iphone.ugc.Ame") {
          /// tiktok老的包名强转新的包名
         logger?.d("tiktok老的包名强转新的包名 com.ss.iphone.ugc.Ame => com.zhiliaoapp.musically");
         model.packName = "com.zhiliaoapp.musically";
     } else if (model.packName == "in.startv.hotstar") {
       /// Hotstar老的包名强转新的包名
       logger?.d("Hotstar老的包名强转新的包名 in.startv.hotstar => in.startv.hotstarLite");
       model.packName = "in.startv.hotstarLite";
     }
     //0：不需要更新 1：需要更新icon ，2：需要更新app名，3：icon和app都需要更新
     final state = json['need_sync_icon'] as int?;
     model.isUpdateAppName = state == 0 || state == 1;
     model.isDownloadAppInfo = state == 0;
     model.isUpdateAppIcon = state == 0 || state == 2;
   }
   return model;
  }
}

class IDOAppIconInfoModel {
  ///版本号
  int? version;

  /// icon宽度
  int? iconWidth;

  /// icon高度
  int? iconHeight;

  /// 颜色格式
  int? colorFormat;

  /// 压缩块大小
  int? blockSize;

  /// 总个数
  int? totalNum;

  /// 包名详情集合
  List<IDOAppIconItemModel>? items;

  IDOAppIconInfoModel({
    this.version,
    this.iconWidth,
    this.iconHeight,
    this.colorFormat,
    this.blockSize,
    this.totalNum,
    this.items
  });

  factory IDOAppIconInfoModel.fromJson(Map<String, dynamic> json) {
    final model = IDOAppIconInfoModel(
      version: json['version'] as int?,
      iconWidth: json['icon_width'] as int?,
      iconHeight: json['icon_height'] as int?,
      colorFormat: json['format'] as int?,
      blockSize: json['block_size'] as int?,
      totalNum: json['package_num'] as int?,
      items: [],
    );
    List<dynamic>? json_items = json['items'] as List<dynamic>?;
    List<IDOAppIconItemModel> models = [];
    json_items?.forEach((element) {
      final item = IDOAppIconItemModel.fromJson(element);
      final countryCode = item.countryCode ?? '';
      if (countryCode.isEmpty) {
          item.countryCode = json['country_code'] as String?;
      }
      models.add(item);
    });
    model.items = models;
    return model;
  }

  Map<String, dynamic> _IDOAppIconInfoModelToJson (
      IDOAppIconInfoModel instance) {
    final map = <String, dynamic>{
      'version': instance.version,
      'icon_width': instance.iconWidth,
      'icon_height': instance.iconHeight,
      'format': instance.colorFormat,
      'block_size': instance.blockSize,
      'package_num': instance.totalNum
    };

    List<Map<String,dynamic>> items = [];
    instance.items?.forEach((element) {
    final item = {'evt_type': element.evtType,'pack_name_array': element.packName,
    'app_name': element.appName,'icon_local_path': element.iconLocalPath,
    'item_id': element.itemId ?? 0,'msg_cout': element.msgCount ?? 0,
    'country_code':element.countryCode ?? '','icon_cloud_path':element.iconCloudPath ?? '',
    'icon_local_path_big': element.iconLocalPathBig ?? '','need_sync_icon' : element.state ?? 0,
    'app_version': element.appVersion ?? ''
      };
      items.add(item);
    });
    map.putIfAbsent('items', () => items);
    return map;
  }

  Map<String, dynamic> toJson() => _IDOAppIconInfoModelToJson(this);

}
