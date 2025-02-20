import 'package:json_annotation/json_annotation.dart';

part 'dial_photo_log_obj.g.dart';

@JsonSerializable()
class DialPhotoLogObj extends Object {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'imageUrl')
  String imageUrl;

  @JsonKey(name: 'linkUrl')
  String linkUrl;

  @JsonKey(name: 'otaFaceName')
  String otaFaceName;

  @JsonKey(name: 'fileSize')
  int size;

  DialPhotoLogObj(
    this.id,
    this.imageUrl,
    this.linkUrl,
    this.otaFaceName,
    this.size,
  );

  factory DialPhotoLogObj.fromJson(Map<String, dynamic> srcJson) =>
      _$DialPhotoLogObjFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DialPhotoLogObjToJson(this);
}
