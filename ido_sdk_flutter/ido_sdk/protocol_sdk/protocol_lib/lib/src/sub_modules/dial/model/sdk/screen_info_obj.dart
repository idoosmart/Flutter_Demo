import 'package:json_annotation/json_annotation.dart';

part 'screen_info_obj.g.dart';

@JsonSerializable()
class ScreenInfoObj extends Object {
  @JsonKey(name: 'block_size')
  int blockSize;

  @JsonKey(name: 'family_name')
  String familyName;

  @JsonKey(name: 'format')
  int format;

  @JsonKey(name: 'height')
  int height;

  @JsonKey(name: 'sizex100')
  int sizex100;

  @JsonKey(name: 'width')
  int width;

  ScreenInfoObj(
    this.blockSize,
    this.familyName,
    this.format,
    this.height,
    this.sizex100,
    this.width,
  );

  factory ScreenInfoObj.fromJson(Map<String, dynamic> srcJson) =>
      _$ScreenInfoObjFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ScreenInfoObjToJson(this);
}
