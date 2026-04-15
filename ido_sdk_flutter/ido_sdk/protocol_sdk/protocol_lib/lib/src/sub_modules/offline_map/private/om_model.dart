import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';

part 'om_model.g.dart';

@JsonSerializable()
class OMOfflineMapFileInfo {
  /// 文件名
  @JsonKey(name: 'name')
  final String name;

  /// 文件大小
  @JsonKey(name: 'size')
  final int size;

  /// 文件校验码
  @JsonKey(name: 'crc16')
  final int crc16;

  /// 相对MAP地图存储目录路径去掉前面地图名
  @JsonKey(name: 'path')
  final String path;

  OMOfflineMapFileInfo({
    required this.name,
    this.size = 0,
    this.crc16 = 0,
    this.path = '',
  });

  factory OMOfflineMapFileInfo.fromJson(Map<String, dynamic> json) =>
      _$OMOfflineMapFileInfoFromJson(json);

  Map<String, dynamic> toJson() => _$OMOfflineMapFileInfoToJson(this);
}

@JsonSerializable()
class OMOfflineMapName {
  /// 文件名
  @JsonKey(name: 'name')
  final String name;

  OMOfflineMapName({required this.name});

  factory OMOfflineMapName.fromJson(Map<String, dynamic> json) =>
      _$OMOfflineMapNameFromJson(json);

  Map<String, dynamic> toJson() => _$OMOfflineMapNameToJson(this);
}

@JsonSerializable()
class OMMapInformation {
  /// 文件名
  @JsonKey(name: 'name')
  final String name;

  /// 地图大小
  @JsonKey(name: 'size')
  final int size;

  /// 离线地图文件个数
  @JsonKey(name: 'file_count')
  final int fileCount;

  // /// 预留
  // @JsonKey(name: 'data')
  // final List<int> data;

  /// 离线地图文件的具体信息，最大支持13个
  @JsonKey(name: 'files')
  final List<OMOfflineMapFileInfo> files;

  OMMapInformation({
    this.name = '',
    this.size = 0,
    this.fileCount = 0,
    // this.data = const [],
    this.files = const [],
  });

  factory OMMapInformation.fromJson(Map<String, dynamic> json) =>
      _$OMMapInformationFromJson(json);

  Map<String, dynamic> toJson() => _$OMMapInformationToJson(this);
}

@JsonSerializable()
class OMTrackInformation {
  /// 轨迹文件名(运动路线名称)，最多支持30个中文字符
  @JsonKey(name: 'name')
  final String name;

  /// 轨迹文件大小
  @JsonKey(name: 'size')
  final int size;

  /// 文件校验码
  @JsonKey(name: 'crc16')
  final int crc16;

  /// 运动路线距离，单位：米
  @JsonKey(name: 'distance')
  final int distance;

  /// 运动路线推荐时长，单位：秒
  @JsonKey(name: 'duration')
  final int duration;

  /// 运动路线类型：0 无效，1 步行类，2 骑行类
  @JsonKey(name: 'type')
  final int type;

  // /// 预留
  // @JsonKey(name: 'data')
  // final List<int> data;

  OMTrackInformation({
    this.name = '',
    this.size = 0,
    this.crc16 = 0,
    this.distance = 0,
    this.duration = 0,
    this.type = 0,
    // this.data = const [],
  });

  factory OMTrackInformation.fromJson(Map<String, dynamic> json) =>
      _$OMTrackInformationFromJson(json);

  Map<String, dynamic> toJson() => _$OMTrackInformationToJson(this);
}

@JsonSerializable()
class OMMapConfig {
  /// 总的items的个数 地图详情个数
  @JsonKey(name: 'all_items_num')
  final int allItemsNum;

  /// 已经发送/接收的items的个数
  @JsonKey(name: 'finish_items_num')
  final int finishItemsNum;

  /// 当前包items的个数 查询有效
  @JsonKey(name: 'cur_items_num')
  final int curItemsNum;

  // /// 预留
  // @JsonKey(name: 'data')
  // final List<int> data;

  OMMapConfig({
    this.allItemsNum = 0,
    this.finishItemsNum = 0,
    this.curItemsNum = 0,
    // this.data = const [],
  });

  factory OMMapConfig.fromJson(Map<String, dynamic> json) =>
      _$OMMapConfigFromJson(json);

  Map<String, dynamic> toJson() => _$OMMapConfigToJson(this);
}

@JsonSerializable()
class OMOfflineMapInformation {
  /// 版本号0
  @JsonKey(name: 'version')
  final int version;

  /// 操作类型 0:无效 1:查询授权  2:设置(下发)授权码 3:查询固件地图配置信息 4:删除地图
  /// 5:查询单个地图详细信息 6:添加单个地图 7:添加单个轨迹文件
  @JsonKey(name: 'operate')
  final int operate;

  /// 地图详情个数  操作(6:添加单个地图)有效
  @JsonKey(name: 'map_information_count')
  final int mapInformationCount;

  /// 地图名字详情  操作(4:删除地图/5:查询单个地图详细信息)有效
  @JsonKey(name: 'map_name_count')
  final int mapNameCount;

  /// 授权码长度 操作(2:下发授权码)有效 最大长度64
  @JsonKey(name: 'authorization_code_len')
  final int authorizationCodeLen;

  /// 固件离线地图的配置信息个数 操作(3:查询固件地图配置信息)有效
  @JsonKey(name: 'map_config_count')
  final int mapConfigCount;

  /// 轨迹文件个数  操作(7:添加单个轨迹文件)有效
  @JsonKey(name: 'track_item_count')
  final int trackItemCount;

  // /// 预留
  // @JsonKey(name: 'data')
  // final List<int> data;

  /// 授权码 操作(2:下发授权码)有效
  @JsonKey(name: 'authorization_code')
  final List<int>? authorizationCode;

  /// 地图详情 操作(6:添加单个地图)有效
  @JsonKey(name: 'map_items')
  final List<OMMapInformation>? mapItems;

  /// 地图名字详情 操作(4:删除地图，支持最多一次性30个；5:查询单个地图细信息，只支持一次查询1个)有效
  @JsonKey(name: 'map_name_items')
  final List<OMOfflineMapName>? mapNameItems;

  /// 固件离线地图的配置信息 操作(3:查询固件地图配置信息)有效
  @JsonKey(name: 'map_config_item')
  final List<OMMapConfig>? mapConfigItem;

  /// 轨迹文件详情 操作(7:添加单个轨迹文件)有效
  @JsonKey(name: 'track_item')
  final List<OMTrackInformation>? trackItem;

  /// 查询单个地图详细信息 (5: 查询有效）
  @JsonKey(name: 'file_path')
  final String? filePath;

  /// 查询单个地图详细信息 (5: 查询有效）
  @JsonKey(name: 'map_name')
  final String? mapName;

  OMOfflineMapInformation({
    this.version = 0,
    this.operate = 0,
    this.mapInformationCount = 0,
    this.mapNameCount = 0,
    this.authorizationCodeLen = 0,
    this.mapConfigCount = 0,
    this.trackItemCount = 0,
    // this.data = const [],
    this.authorizationCode,
    this.mapItems,
    this.mapNameItems,
    this.mapConfigItem,
    this.trackItem,
    this.filePath,
    this.mapName,
  });

  factory OMOfflineMapInformation.fromJson(Map<String, dynamic> json) =>
      _$OMOfflineMapInformationFromJson(json);

  Map<String, dynamic> toJson() => _$OMOfflineMapInformationToJson(this);
}

@JsonSerializable()
class OMMapSummaryInfo {
  /// 地图名字
  @JsonKey(name: 'name')
  final String name;

  /// 地图大小
  @JsonKey(name: 'size')
  final int size;

  /// 下载状态：0 无效，1 已下载完成，2 未下载完
  @JsonKey(name: 'download_status')
  final int downloadStatus;

  OMMapSummaryInfo({
    this.name = '',
    this.size = 0,
    this.downloadStatus = 0,
  });

  factory OMMapSummaryInfo.fromJson(Map<String, dynamic> json) =>
      _$OMMapSummaryInfoFromJson(json);

  Map<String, dynamic> toJson() => _$OMMapSummaryInfoToJson(this);
}

@JsonSerializable()
class OMMapConfigReply {
  /// 固件地图分配可使用总空间
  @JsonKey(name: 'total_space')
  final int totalSpace;

  /// 固件地图剩余可使用空间
  @JsonKey(name: 'available_space')
  final int availableSpace;

  /// 总的items的个数 地图详情个数
  @JsonKey(name: 'all_items_num')
  final int allItemsNum;

  /// 已经发送/接收的items的个数
  @JsonKey(name: 'finish_items_num')
  final int finishItemsNum;

  /// 当前包items的个数 查询有效
  @JsonKey(name: 'cur_items_num')
  final int curItemsNum;

  /// 固件支持的轨迹文件最大个数
  @JsonKey(name: 'support_track_num_max')
  final int supportTrackNumMax;

  /// 固件支持的轨迹文件名最大长度
  @JsonKey(name: 'support_track_file_name_len_max')
  final int supportTrackFileNameLenMax;

  // /// 预留
  // @JsonKey(name: 'data')
  // final List<int> data;

  /// 固件已有地图文件概要信息，建议一次性最多获取27个
  @JsonKey(name: 'map_items')
  final List<OMMapSummaryInfo>? mapItems;

  OMMapConfigReply({
    this.totalSpace = 0,
    this.availableSpace = 0,
    this.allItemsNum = 0,
    this.finishItemsNum = 0,
    this.curItemsNum = 0,
    this.supportTrackNumMax = 0,
    this.supportTrackFileNameLenMax = 0,
    // this.data = const [],
    this.mapItems,
  });

  factory OMMapConfigReply.fromJson(Map<String, dynamic> json) =>
      _$OMMapConfigReplyFromJson(json);

  Map<String, dynamic> toJson() => _$OMMapConfigReplyToJson(this);
}

@JsonSerializable()
class OMAuthorizationInformation {
  /// 是否授权 0:无效 1:授权 2:未授权
  @JsonKey(name: 'auth_is_granted')
  final int authIsGranted;

  /// UUID
  @JsonKey(name: 'uuid')
  final String uuid;

  // /// 预留
  // @JsonKey(name: 'data')
  // final List<int> data;

  OMAuthorizationInformation({
    this.authIsGranted = 0,
    this.uuid = '',
    // this.data = const [],
  });

  factory OMAuthorizationInformation.fromJson(Map<String, dynamic> json) =>
      _$OMAuthorizationInformationFromJson(json);

  Map<String, dynamic> toJson() => _$OMAuthorizationInformationToJson(this);
}

@JsonSerializable()
class OMMapInformationReply {
  /// 文件名
  @JsonKey(name: 'name')
  final String name;

  /// 地图大小
  @JsonKey(name: 'size')
  final int size;

  /// 离线地图文件个数
  @JsonKey(name: 'file_count')
  final int fileCount;

  /// 已下载文件个数
  @JsonKey(name: 'download_file_count')
  final int downloadFileCount;

  /// 已下载文件总大小
  @JsonKey(name: 'download_file_total_size')
  final int downloadFileTotalSize;

  // /// 预留
  // @JsonKey(name: 'data')
  // final List<int> data;

  /// 已下载文件的具体信息，最大支持13个
  @JsonKey(name: 'download_files')
  final List<OMOfflineMapFileInfo>? downloadFiles;

  OMMapInformationReply({
    this.name = '',
    this.size = 0,
    this.fileCount = 0,
    this.downloadFileCount = 0,
    this.downloadFileTotalSize = 0,
    // this.data = const [],
    this.downloadFiles,
  });

  factory OMMapInformationReply.fromJson(Map<String, dynamic> json) =>
      _$OMMapInformationReplyFromJson(json);

  Map<String, dynamic> toJson() => _$OMMapInformationReplyToJson(this);
}

@JsonSerializable()
class OMOfflineMapInformationReply {
  @JsonKey(name: 'version')
  final int version;

  /// 操作类型 0:无效 1:查询授权  2:设置(下发)授权码
  /// 3:查询固件地图配置信息(不返回文件列表struct offline_map_file_info)
  /// 4:删除地图 5:查询单个地图详细信息 6:添加单个地图 7:添加单个轨迹文件
  @JsonKey(name: 'operate')
  final int operate;

  /// 错误码 0:成功 非0失败(详情:见错误码表)
  @JsonKey(name: 'error_code')
  final int errorCode;

  /// 授权信息详情个数 操作(1:查询授权)有效
  @JsonKey(name: 'authorization_count')
  final int authorizationCount;

  /// 固件离线地图的配置信息个数 操作(3:查询固件地图配置信息)有效
  @JsonKey(name: 'map_config_count')
  final int mapConfigCount;

  /// 固件地图详情个数 操作（5:查询单个地图详细信息）有效0
  @JsonKey(name: 'map_count')
  final int mapCount;

  // /// 预留
  // @JsonKey(name: 'data')
  // final List<int> data;

  /// 授权信息详情  操作(1:查询授权)有效
  @JsonKey(name: 'authorization_items')
  final List<OMAuthorizationInformation>? authorizationItems;

  /// 固件离线地图的配置信息详情
  /// 操作(3:查询固件地图配置信息)有效
  @JsonKey(name: 'map_config_items')
  final List<OMMapConfigReply>? mapConfigItems;

  /// 固件地图详情 操作（5:查询单个地图详细信息）有效
  @JsonKey(name: 'map_items')
  final List<OMMapInformationReply>? mapItems;

  OMOfflineMapInformationReply({
    this.version = 0,
    this.operate = 0,
    this.errorCode = -1,
    this.authorizationCount = 0,
    this.mapConfigCount = 0,
    this.mapCount = 0,
    // this.data = const [],
    this.authorizationItems,
    this.mapConfigItems,
    this.mapItems,
  });

  factory OMOfflineMapInformationReply.fromJson(Map<String, dynamic> json) =>
      _$OMOfflineMapInformationReplyFromJson(json);

  Map<String, dynamic> toJson() => _$OMOfflineMapInformationReplyToJson(this);
}