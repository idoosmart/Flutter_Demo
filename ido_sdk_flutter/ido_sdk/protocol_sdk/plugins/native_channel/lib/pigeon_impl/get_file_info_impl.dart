import 'package:native_channel/pigeon_generate/get_file_info.g.dart';

abstract class GetFileInfo {

  factory GetFileInfo() => GetFileInfoImpl();

  /// 读取文件信息
  /// {"createSeconds":0,"changeSeconds":0}
  Future<Map?> readFileInfo(String path);

}

class GetFileInfoImpl extends ApiGetFileInfo implements GetFileInfo {

  static GetFileInfoImpl? _instance;
  factory GetFileInfoImpl() => _instance ??= GetFileInfoImpl._internal();
  GetFileInfoImpl._internal();

  final _getFileInfo = ApiGetFileInfo();

  @override
  Future<Map?> readFileInfo(String path) {
     return _getFileInfo.readFileInfo(path);
  }

}