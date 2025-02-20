import 'package:json_annotation/json_annotation.dart';

part 'dial_list_v3_obj.g.dart';

@JsonSerializable()
class DialListV3Obj extends Object {
  ///云端表盘的总个数
  @JsonKey(name: 'cloud_watch_num')
  int cloudWatchNum;

  @JsonKey(name: 'file_max_size')
  int fileMaxSize;

  @JsonKey(name: 'item')
  List<DialListV3Item>? dialListV3Item;

  @JsonKey(name: 'list_item_numb')
  int listItemNumb;

  @JsonKey(name: 'local_watch_num')
  int localWatchNum;

  @JsonKey(name: 'now_show_watch_name')
  String nowShowWatchName;

  @JsonKey(name: 'usable_max_download_space_size')
  int usableMaxDownloadSpaceSize;

  ///云表盘的已经使用个数
  @JsonKey(name: 'user_cloud_watch_num')
  int userCloudWatchNum;

  ///壁纸表盘的已经使用个数
  @JsonKey(name: 'user_wallpaper_watch_num')
  int userWallpaperWatchNum;

  ///表盘的已经使用容量 固件开启V3_support_watch_capacity_size_display有效,否则字段赋0
  @JsonKey(name: 'user_watch_capacity_size')
  int userWatchCapacitySize;

  @JsonKey(name: 'wallpaper_watch_num')
  int wallpaperWatchNum;

  ///表盘的总容量 固件开启V3_support_watch_capacity_size_display有效,否则字段赋0
  @JsonKey(name: 'watch_capacity_size')
  int watchCapacitySize;

  @JsonKey(name: 'watch_frame_main_version')
  int watchFrameMainVersion;

  DialListV3Obj(
    this.cloudWatchNum,
    this.fileMaxSize,
    this.dialListV3Item,
    this.listItemNumb,
    this.localWatchNum,
    this.nowShowWatchName,
    this.usableMaxDownloadSpaceSize,
    this.userCloudWatchNum,
    this.userWallpaperWatchNum,
    this.userWatchCapacitySize,
    this.wallpaperWatchNum,
    this.watchCapacitySize,
    this.watchFrameMainVersion,
  );

  factory DialListV3Obj.fromJson(Map<String, dynamic> srcJson) => _$DialListV3ObjFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DialListV3ObjToJson(this);
}

@JsonSerializable()
class DialListV3Item extends Object {
  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'size')
  int size;

  @JsonKey(name: 'sort_number')
  int sortNumber;

  @JsonKey(name: 'type')
  int type;

  @JsonKey(name: 'watch_version')
  int watchVersion;

  DialListV3Item(
    this.name,
    this.size,
    this.sortNumber,
    this.type,
    this.watchVersion,
  );

  factory DialListV3Item.fromJson(Map<String, dynamic> srcJson) => _$DialListV3ItemFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DialListV3ItemToJson(this);
}
