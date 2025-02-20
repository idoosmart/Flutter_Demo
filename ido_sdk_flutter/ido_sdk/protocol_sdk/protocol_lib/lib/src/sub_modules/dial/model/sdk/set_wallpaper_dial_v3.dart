import 'package:json_annotation/json_annotation.dart';

part 'set_wallpaper_dial_v3.g.dart';

@JsonSerializable()
class SetWallpaperDialV3 extends Object {
  @JsonKey(name: 'operate', includeIfNull: false)
  int operate;

  @JsonKey(name: 'hide_type', includeIfNull: false)
  int? hideType;

  @JsonKey(name: 'location', includeIfNull: false)
  int? location;

  @JsonKey(name: 'time_color', includeIfNull: false)
  int? timeColor;

  @JsonKey(name: 'widget_icon_color', includeIfNull: false)
  int? widgetIconColor;

  @JsonKey(name: 'widget_num_color', includeIfNull: false)
  int? widgetNumColor;

  @JsonKey(name: 'widget_type', includeIfNull: false)
  int? widgetType;

  SetWallpaperDialV3(
    this.operate,
    this.hideType,
    this.location,
    this.timeColor,
    this.widgetIconColor,
    this.widgetNumColor,
    this.widgetType,
  );

  factory SetWallpaperDialV3.fromJson(Map<String, dynamic> srcJson) =>
      _$SetWallpaperDialV3FromJson(srcJson);

  Map<String, dynamic> toJson() => _$SetWallpaperDialV3ToJson(this);
}
