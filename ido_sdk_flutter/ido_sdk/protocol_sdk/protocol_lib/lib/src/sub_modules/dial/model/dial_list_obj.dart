import 'package:json_annotation/json_annotation.dart';

part 'dial_list_obj.g.dart';

@JsonSerializable()
class DialListObj extends Object {
  @JsonKey(name: 'items')
  List<FaceListItems>? faceListItems;

  @JsonKey(name: 'numRows')
  int numRows;

  @JsonKey(name: 'totalPages')
  int totalPages;

  @JsonKey(name: 'pageSize')
  int pageSize;

  @JsonKey(name: 'currentPage')
  int currentPage;

  DialListObj(
    this.faceListItems,
    this.numRows,
    this.totalPages,
    this.pageSize,
    this.currentPage,
  );

  factory DialListObj.fromJson(Map<String, dynamic> srcJson) =>
      _$DialListObjFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DialListObjToJson(this);
}

@JsonSerializable()
class FaceListItems extends Object {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'faceId')
  int? faceId;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'faceTypeName')
  String? faceTypeName;

  @JsonKey(name: 'description')
  String? description;

  @JsonKey(name: 'linkUrl')
  String? linkUrl;

  @JsonKey(name: 'size')
  String? size;

  @JsonKey(name: 'imageUrl')
  String imageUrl;

  @JsonKey(name: 'md5')
  String? md5;

  @JsonKey(name: 'sha256')
  String? sha256;

  @JsonKey(name: 'sha512')
  String? sha512;

  @JsonKey(name: 'sha128')
  String? sha128;

  @JsonKey(name: 'otaFaceName')
  String otaFaceName;

  @JsonKey(name: 'faceType')
  String faceType;

  @JsonKey(name: 'sid')
  String? sid;

  @JsonKey(name: 'customFaceType')
  String? customFaceType;

  FaceListItems(
    this.id,
    this.faceId,
    this.name,
    this.faceTypeName,
    this.description,
    this.linkUrl,
    this.size,
    this.imageUrl,
    this.md5,
    this.sha256,
    this.sha512,
    this.sha128,
    this.otaFaceName,
    this.faceType,
    this.sid,
    this.customFaceType,
  );

  static fromJsonList(List<dynamic> srcJson) {
    return srcJson
        .map((e) => FaceListItems.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  factory FaceListItems.fromJson(Map<String, dynamic> srcJson) =>
      _$FaceListItemsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$FaceListItemsToJson(this);
}
