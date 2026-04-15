part of '../utils_manager.dart';

class _IDOUtilsManager implements IDOUtilsManager {
  static final _instance = _IDOUtilsManager._internal();

  factory _IDOUtilsManager() => _instance;

  _IDOUtilsManager._internal();

  @override
  Future<bool> toJieLiDialFile(
      {required String dialFilePath,
      String? bgPath,
      String? previewPath,
      required int color,
      required String baseBinPath}) async {
    return ToolsImpl().makeJieLiDialFile(dialFilePath, bgPath!, previewPath!, color, baseBinPath);
    // return _UtilsMakeDial.toDialFile(
    //     dialFilePath: dialFilePath, color: color, bgPath: bgPath, previewPath: previewPath, baseBinPath: baseBinPath);
  }

  @override
  Future<bool> writeCoordinatesToFile(List<IDOTrackLocation> coordinates, String filePath) async {
    try {
      final binaryData = _createBinaryData(coordinates);
      final file = File(filePath);
      await file.writeAsBytes(binaryData);
      return true;
    } catch (e) {
      // logger?.e("writeCoordinatesToFile error: $e");
      return false;
    }
  }

}

extension _IDOUtilsManagerExt on _IDOUtilsManager {

  /// 创建二进制数据（小端模式）
  Uint8List _createBinaryData(List<IDOTrackLocation> coordinates) {
    int bufferSize = coordinates.length * 8;
    final byteData = ByteData(bufferSize);
    int offset = 0;

    for (var coord in coordinates) {
      int scaledLon = (coord.longitude * 1000000).round();
      int scaledLat = (coord.latitude * 1000000).round();

      // 小端模式写入：先经度后纬度
      byteData.setInt32(offset, scaledLon, Endian.little);
      offset += 4;
      byteData.setInt32(offset, scaledLat, Endian.little);
      offset += 4;
    }
    return byteData.buffer.asUint8List();
  }

} 
