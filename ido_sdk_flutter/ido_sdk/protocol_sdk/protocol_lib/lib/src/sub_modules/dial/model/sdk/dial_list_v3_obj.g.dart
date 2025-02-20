// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dial_list_v3_obj.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DialListV3Obj _$DialListV3ObjFromJson(Map<String, dynamic> json) =>
    DialListV3Obj(
      json['cloud_watch_num'] as int,
      json['file_max_size'] as int,
      (json['item'] as List<dynamic>?)
          ?.map((e) => DialListV3Item.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['list_item_numb'] as int,
      json['local_watch_num'] as int,
      json['now_show_watch_name'] as String,
      json['usable_max_download_space_size'] as int,
      json['user_cloud_watch_num'] as int,
      json['user_wallpaper_watch_num'] as int,
      json['user_watch_capacity_size'] as int,
      json['wallpaper_watch_num'] as int,
      json['watch_capacity_size'] as int,
      json['watch_frame_main_version'] as int,
    );

Map<String, dynamic> _$DialListV3ObjToJson(DialListV3Obj instance) =>
    <String, dynamic>{
      'cloud_watch_num': instance.cloudWatchNum,
      'file_max_size': instance.fileMaxSize,
      'item': instance.dialListV3Item,
      'list_item_numb': instance.listItemNumb,
      'local_watch_num': instance.localWatchNum,
      'now_show_watch_name': instance.nowShowWatchName,
      'usable_max_download_space_size': instance.usableMaxDownloadSpaceSize,
      'user_cloud_watch_num': instance.userCloudWatchNum,
      'user_wallpaper_watch_num': instance.userWallpaperWatchNum,
      'user_watch_capacity_size': instance.userWatchCapacitySize,
      'wallpaper_watch_num': instance.wallpaperWatchNum,
      'watch_capacity_size': instance.watchCapacitySize,
      'watch_frame_main_version': instance.watchFrameMainVersion,
    };

DialListV3Item _$DialListV3ItemFromJson(Map<String, dynamic> json) =>
    DialListV3Item(
      json['name'] as String,
      json['size'] as int,
      json['sort_number'] as int,
      json['type'] as int,
      json['watch_version'] as int,
    );

Map<String, dynamic> _$DialListV3ItemToJson(DialListV3Item instance) =>
    <String, dynamic>{
      'name': instance.name,
      'size': instance.size,
      'sort_number': instance.sortNumber,
      'type': instance.type,
      'watch_version': instance.watchVersion,
    };
