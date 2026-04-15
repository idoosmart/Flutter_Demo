// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'om_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OMOfflineMapFileInfo _$OMOfflineMapFileInfoFromJson(
        Map<String, dynamic> json) =>
    OMOfflineMapFileInfo(
      name: json['name'] as String,
      size: (json['size'] as num?)?.toInt() ?? 0,
      crc16: (json['crc16'] as num?)?.toInt() ?? 0,
      path: json['path'] as String? ?? '',
    );

Map<String, dynamic> _$OMOfflineMapFileInfoToJson(
        OMOfflineMapFileInfo instance) =>
    <String, dynamic>{
      'name': instance.name,
      'size': instance.size,
      'crc16': instance.crc16,
      'path': instance.path,
    };

OMOfflineMapName _$OMOfflineMapNameFromJson(Map<String, dynamic> json) =>
    OMOfflineMapName(
      name: json['name'] as String,
    );

Map<String, dynamic> _$OMOfflineMapNameToJson(OMOfflineMapName instance) =>
    <String, dynamic>{
      'name': instance.name,
    };

OMMapInformation _$OMMapInformationFromJson(Map<String, dynamic> json) =>
    OMMapInformation(
      name: json['name'] as String? ?? '',
      size: (json['size'] as num?)?.toInt() ?? 0,
      fileCount: (json['file_count'] as num?)?.toInt() ?? 0,
      files: (json['files'] as List<dynamic>?)
              ?.map((e) =>
                  OMOfflineMapFileInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$OMMapInformationToJson(OMMapInformation instance) =>
    <String, dynamic>{
      'name': instance.name,
      'size': instance.size,
      'file_count': instance.fileCount,
      'files': instance.files,
    };

OMTrackInformation _$OMTrackInformationFromJson(Map<String, dynamic> json) =>
    OMTrackInformation(
      name: json['name'] as String? ?? '',
      size: (json['size'] as num?)?.toInt() ?? 0,
      crc16: (json['crc16'] as num?)?.toInt() ?? 0,
      distance: (json['distance'] as num?)?.toInt() ?? 0,
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      type: (json['type'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$OMTrackInformationToJson(OMTrackInformation instance) =>
    <String, dynamic>{
      'name': instance.name,
      'size': instance.size,
      'crc16': instance.crc16,
      'distance': instance.distance,
      'duration': instance.duration,
      'type': instance.type,
    };

OMMapConfig _$OMMapConfigFromJson(Map<String, dynamic> json) => OMMapConfig(
      allItemsNum: (json['all_items_num'] as num?)?.toInt() ?? 0,
      finishItemsNum: (json['finish_items_num'] as num?)?.toInt() ?? 0,
      curItemsNum: (json['cur_items_num'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$OMMapConfigToJson(OMMapConfig instance) =>
    <String, dynamic>{
      'all_items_num': instance.allItemsNum,
      'finish_items_num': instance.finishItemsNum,
      'cur_items_num': instance.curItemsNum,
    };

OMOfflineMapInformation _$OMOfflineMapInformationFromJson(
        Map<String, dynamic> json) =>
    OMOfflineMapInformation(
      version: (json['version'] as num?)?.toInt() ?? 0,
      operate: (json['operate'] as num?)?.toInt() ?? 0,
      mapInformationCount:
          (json['map_information_count'] as num?)?.toInt() ?? 0,
      mapNameCount: (json['map_name_count'] as num?)?.toInt() ?? 0,
      authorizationCodeLen:
          (json['authorization_code_len'] as num?)?.toInt() ?? 0,
      mapConfigCount: (json['map_config_count'] as num?)?.toInt() ?? 0,
      trackItemCount: (json['track_item_count'] as num?)?.toInt() ?? 0,
      authorizationCode: (json['authorization_code'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      mapItems: (json['map_items'] as List<dynamic>?)
          ?.map((e) => OMMapInformation.fromJson(e as Map<String, dynamic>))
          .toList(),
      mapNameItems: (json['map_name_items'] as List<dynamic>?)
          ?.map((e) => OMOfflineMapName.fromJson(e as Map<String, dynamic>))
          .toList(),
      mapConfigItem: (json['map_config_item'] as List<dynamic>?)
          ?.map((e) => OMMapConfig.fromJson(e as Map<String, dynamic>))
          .toList(),
      trackItem: (json['track_item'] as List<dynamic>?)
          ?.map((e) => OMTrackInformation.fromJson(e as Map<String, dynamic>))
          .toList(),
      filePath: json['file_path'] as String?,
      mapName: json['map_name'] as String?,
    );

Map<String, dynamic> _$OMOfflineMapInformationToJson(
        OMOfflineMapInformation instance) =>
    <String, dynamic>{
      'version': instance.version,
      'operate': instance.operate,
      'map_information_count': instance.mapInformationCount,
      'map_name_count': instance.mapNameCount,
      'authorization_code_len': instance.authorizationCodeLen,
      'map_config_count': instance.mapConfigCount,
      'track_item_count': instance.trackItemCount,
      'authorization_code': instance.authorizationCode,
      'map_items': instance.mapItems,
      'map_name_items': instance.mapNameItems,
      'map_config_item': instance.mapConfigItem,
      'track_item': instance.trackItem,
      'file_path': instance.filePath,
      'map_name': instance.mapName,
    };

OMMapSummaryInfo _$OMMapSummaryInfoFromJson(Map<String, dynamic> json) =>
    OMMapSummaryInfo(
      name: json['name'] as String? ?? '',
      size: (json['size'] as num?)?.toInt() ?? 0,
      downloadStatus: (json['download_status'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$OMMapSummaryInfoToJson(OMMapSummaryInfo instance) =>
    <String, dynamic>{
      'name': instance.name,
      'size': instance.size,
      'download_status': instance.downloadStatus,
    };

OMMapConfigReply _$OMMapConfigReplyFromJson(Map<String, dynamic> json) =>
    OMMapConfigReply(
      totalSpace: (json['total_space'] as num?)?.toInt() ?? 0,
      availableSpace: (json['available_space'] as num?)?.toInt() ?? 0,
      allItemsNum: (json['all_items_num'] as num?)?.toInt() ?? 0,
      finishItemsNum: (json['finish_items_num'] as num?)?.toInt() ?? 0,
      curItemsNum: (json['cur_items_num'] as num?)?.toInt() ?? 0,
      supportTrackNumMax: (json['support_track_num_max'] as num?)?.toInt() ?? 0,
      supportTrackFileNameLenMax:
          (json['support_track_file_name_len_max'] as num?)?.toInt() ?? 0,
      mapItems: (json['map_items'] as List<dynamic>?)
          ?.map((e) => OMMapSummaryInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OMMapConfigReplyToJson(OMMapConfigReply instance) =>
    <String, dynamic>{
      'total_space': instance.totalSpace,
      'available_space': instance.availableSpace,
      'all_items_num': instance.allItemsNum,
      'finish_items_num': instance.finishItemsNum,
      'cur_items_num': instance.curItemsNum,
      'support_track_num_max': instance.supportTrackNumMax,
      'support_track_file_name_len_max': instance.supportTrackFileNameLenMax,
      'map_items': instance.mapItems,
    };

OMAuthorizationInformation _$OMAuthorizationInformationFromJson(
        Map<String, dynamic> json) =>
    OMAuthorizationInformation(
      authIsGranted: (json['auth_is_granted'] as num?)?.toInt() ?? 0,
      uuid: json['uuid'] as String? ?? '',
    );

Map<String, dynamic> _$OMAuthorizationInformationToJson(
        OMAuthorizationInformation instance) =>
    <String, dynamic>{
      'auth_is_granted': instance.authIsGranted,
      'uuid': instance.uuid,
    };

OMMapInformationReply _$OMMapInformationReplyFromJson(
        Map<String, dynamic> json) =>
    OMMapInformationReply(
      name: json['name'] as String? ?? '',
      size: (json['size'] as num?)?.toInt() ?? 0,
      fileCount: (json['file_count'] as num?)?.toInt() ?? 0,
      downloadFileCount: (json['download_file_count'] as num?)?.toInt() ?? 0,
      downloadFileTotalSize:
          (json['download_file_total_size'] as num?)?.toInt() ?? 0,
      downloadFiles: (json['download_files'] as List<dynamic>?)
          ?.map((e) => OMOfflineMapFileInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OMMapInformationReplyToJson(
        OMMapInformationReply instance) =>
    <String, dynamic>{
      'name': instance.name,
      'size': instance.size,
      'file_count': instance.fileCount,
      'download_file_count': instance.downloadFileCount,
      'download_file_total_size': instance.downloadFileTotalSize,
      'download_files': instance.downloadFiles,
    };

OMOfflineMapInformationReply _$OMOfflineMapInformationReplyFromJson(
        Map<String, dynamic> json) =>
    OMOfflineMapInformationReply(
      version: (json['version'] as num?)?.toInt() ?? 0,
      operate: (json['operate'] as num?)?.toInt() ?? 0,
      errorCode: (json['error_code'] as num?)?.toInt() ?? -1,
      authorizationCount: (json['authorization_count'] as num?)?.toInt() ?? 0,
      mapConfigCount: (json['map_config_count'] as num?)?.toInt() ?? 0,
      mapCount: (json['map_count'] as num?)?.toInt() ?? 0,
      authorizationItems: (json['authorization_items'] as List<dynamic>?)
          ?.map((e) =>
              OMAuthorizationInformation.fromJson(e as Map<String, dynamic>))
          .toList(),
      mapConfigItems: (json['map_config_items'] as List<dynamic>?)
          ?.map((e) => OMMapConfigReply.fromJson(e as Map<String, dynamic>))
          .toList(),
      mapItems: (json['map_items'] as List<dynamic>?)
          ?.map(
              (e) => OMMapInformationReply.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OMOfflineMapInformationReplyToJson(
        OMOfflineMapInformationReply instance) =>
    <String, dynamic>{
      'version': instance.version,
      'operate': instance.operate,
      'error_code': instance.errorCode,
      'authorization_count': instance.authorizationCount,
      'map_config_count': instance.mapConfigCount,
      'map_count': instance.mapCount,
      'authorization_items': instance.authorizationItems,
      'map_config_items': instance.mapConfigItems,
      'map_items': instance.mapItems,
    };
