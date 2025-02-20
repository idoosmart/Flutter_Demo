// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_wallpaper_dial_v3.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SetWallpaperDialV3 _$SetWallpaperDialV3FromJson(Map<String, dynamic> json) =>
    SetWallpaperDialV3(
      json['operate'] as int,
      json['hide_type'] as int?,
      json['location'] as int?,
      json['time_color'] as int?,
      json['widget_icon_color'] as int?,
      json['widget_num_color'] as int?,
      json['widget_type'] as int?,
    );

Map<String, dynamic> _$SetWallpaperDialV3ToJson(SetWallpaperDialV3 instance) {
  final val = <String, dynamic>{
    'operate': instance.operate,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('hide_type', instance.hideType);
  writeNotNull('location', instance.location);
  writeNotNull('time_color', instance.timeColor);
  writeNotNull('widget_icon_color', instance.widgetIconColor);
  writeNotNull('widget_num_color', instance.widgetNumColor);
  writeNotNull('widget_type', instance.widgetType);
  return val;
}
