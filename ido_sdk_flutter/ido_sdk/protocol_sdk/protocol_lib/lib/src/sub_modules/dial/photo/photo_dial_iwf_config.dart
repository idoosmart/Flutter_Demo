import 'package:json_annotation/json_annotation.dart';

part 'photo_dial_iwf_config.g.dart';

@JsonSerializable()
class IDOPhotoDialIwfConfig {
  int? version;
  int? clouddialversion;
  String? preview;
  String? name;
  String? author;
  String? description;
  String? compress;
  List<IDOPhotoDialIwfItem>? item;
  String? jsonFilePath;

  IDOPhotoDialIwfConfig({
    this.version,
    this.clouddialversion,
    this.preview,
    this.name,
    this.author,
    this.description,
    this.compress,
    this.item,
    this.jsonFilePath
  });

  factory IDOPhotoDialIwfConfig.fromJson(Map<String, dynamic> json) =>
      _$PhotoDialIwfConfigFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoDialIwfConfigToJson(this);

}

@JsonSerializable()
class IDOPhotoDialIwfItem {
  String? widget;
  String? type;
  int? x;
  int? y;
  int? w;
  int? h;
  String? bg;
  String? bgcolor;

  IDOPhotoDialIwfItem({
    this.widget,
    this.type,
    this.x,
    this.y,
    this.w,
    this.h,
    this.bg,
    this.bgcolor,
  });

  factory IDOPhotoDialIwfItem.fromJson(Map<String, dynamic> json) =>
      _$IWFItemFromJson(json);

  Map<String, dynamic> toJson() => _$IWFItemToJson(this);
}
