import 'package:json_annotation/json_annotation.dart';

import '../../utils/dial_extensions.dart';
import 'dial_list_v3_obj.dart';

part 'dial_list_v2_obj.g.dart';

@JsonSerializable()
class DialListV2Obj extends Object {
  @JsonKey(name: 'available_count')
  int availableCount;

  @JsonKey(name: 'file_max_size')
  int fileMaxSize;

  @JsonKey(name: 'item')
  List<DialListV2Items>? dialListV2Items;

  @JsonKey(name: 'version')
  int version;

  DialListV2Obj(
    this.availableCount,
    this.fileMaxSize,
    this.dialListV2Items,
    this.version,
  );
  DialListV3Obj convertToV3Obj() {
    List<DialListV3Item> items = [];
    for (var i = 0; i < (dialListV2Items?.length ?? 0); i++) {
      DialListV3Item item =
          DialListV3Item(dialListV2Items![i].fileName, 0, i, 1, 0);
      items.add(item);
    }
    int localNum = items.where((element) => element.name.isLocalDial()).length;
    int cloudNum = (availableCount + items.length) - localNum;
    return DialListV3Obj(
        cloudNum, 0, items, 0, localNum, '', 0, 0, 0, 0, 0, 0, 0);
  }

  factory DialListV2Obj.fromJson(Map<String, dynamic> srcJson) =>
      _$DialListV2ObjFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DialListV2ObjToJson(this);
}

@JsonSerializable()
class DialListV2Items extends Object {
  @JsonKey(name: 'file_name')
  String fileName;

  DialListV2Items(
    this.fileName,
  );

  factory DialListV2Items.fromJson(Map<String, dynamic> srcJson) =>
      _$DialListV2ItemsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DialListV2ItemsToJson(this);
}
