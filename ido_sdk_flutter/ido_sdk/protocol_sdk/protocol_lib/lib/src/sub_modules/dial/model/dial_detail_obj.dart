import 'package:json_annotation/json_annotation.dart';

part 'dial_detail_obj.g.dart';

@JsonSerializable()
class DialDetailObj extends Object {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'faceTypeName', defaultValue: '') //有些数据为null
  String faceTypeName;

  @JsonKey(name: 'description')
  String description;

  @JsonKey(name: 'imageUrl')
  String imageUrl;

  @JsonKey(name: 'otaFaceName')
  String otaFaceName;

  @JsonKey(name: 'faceType')
  String faceType;

  @JsonKey(name: 'sid')
  String sid;

  @JsonKey(name: 'otaFaceVersion')
  OtaFaceVersion? otaFaceVersion;

  @JsonKey(name: 'customFaceType')
  String? customFaceType;

  @JsonKey(name: 'enabled')
  bool? enabled;

  @JsonKey(name: 'collected')
  bool? collected;

  DialDetailObj({
    this.id = 0,
    this.name = '',
    this.faceTypeName = '',
    this.description = '',
    this.imageUrl = '',
    this.otaFaceName = '',
    this.faceType = '',
    this.sid = '',
    this.otaFaceVersion,
    this.customFaceType,
    this.enabled = true,
    this.collected = false,
  });

  factory DialDetailObj.fromJson(Map<String, dynamic> srcJson) =>
      _$DialDetailObjFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DialDetailObjToJson(this);

  static List<DialDetailObj> fromJsonList(List<dynamic> srcJson) {
    return srcJson
        .map((e) => DialDetailObj.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

@JsonSerializable()
class OtaFaceVersion extends Object {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'faceId')
  int faceId;

  @JsonKey(name: 'enabled')
  bool enabled;

  @JsonKey(name: 'linkUrl')
  String linkUrl;

  @JsonKey(name: 'size')
  int? size;

  @JsonKey(name: 'md5')
  String? md5;

  @JsonKey(name: 'sha256')
  String? sha256;

  @JsonKey(name: 'sha512')
  String? sha512;

  @JsonKey(name: 'sha128')
  String? sha128;

  @JsonKey(name: 'supportFaceVersion')
  String supportFaceVersion;

  @JsonKey(name: 'version')
  String? version;

  @JsonKey(name: 'type')
  String? type;

  @JsonKey(name: 'otaFace')
  String? otaFace;

  @JsonKey(name: 'remark')
  String? remark;

  OtaFaceVersion(
    this.id,
    this.faceId,
    this.enabled,
    this.linkUrl,
    this.size,
    this.md5,
    this.sha256,
    this.sha512,
    this.sha128,
    this.supportFaceVersion,
    this.version,
    this.type,
    this.otaFace,
    this.remark,
  );

  factory OtaFaceVersion.fromJson(Map<String, dynamic> srcJson) =>
      _$OtaFaceVersionFromJson(srcJson);

  Map<String, dynamic> toJson() => _$OtaFaceVersionToJson(this);

  String getFileExtension() => linkUrl.split('.').last;
}
