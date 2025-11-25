import 'package:json_annotation/json_annotation.dart';

part 'watch_dail_info.g.dart';

@JsonSerializable()
class WatchDailInfo {
  final int? blockSize;
  final String? familyName;
  final int? format;
  final int? height;
  final int? sizex100;
  final int? width;

  const WatchDailInfo({
    this.blockSize,
    this.familyName,
    this.format,
    this.height,
    this.sizex100,
    this.width,
  });

  factory WatchDailInfo.fromJson(Map<String, dynamic> json) =>
      _$WatchDailInfoFromJson(json);

  Map<String, dynamic> toJson() => _$WatchDailInfoToJson(this);
}
