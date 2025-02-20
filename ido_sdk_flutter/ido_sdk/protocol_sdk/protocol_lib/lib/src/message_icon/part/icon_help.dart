import '../../private/logger/logger.dart';
import 'dart:io';
import 'package:image/image.dart' as pkg_img;
import 'package:protocol_core/protocol_core.dart';
import 'package:protocol_lib/protocol_lib.dart';

class IconHelp {
  /// 图片裁剪并压缩
  static Future<File?> cropPicture(String path,String packName,int iconWidth,int iconHeight) async {
    late final _coreMgr = IDOProtocolCoreManager();
    late final _libMgr = IDOProtocolLibManager();
    logger?.d('cutting picture pack name == ${packName} path == ${path} width == ${iconWidth} height == ${iconHeight}');
    File? file;
    try {
      final dirPath = await _libMgr.messageIcon.getIconDirPath();
      /// 存放路径
      var filePath = "${dirPath}/${packName}${'_46'}.png";
      if (iconWidth > 60) {
         filePath = "${dirPath}/${packName}${'_$iconWidth'}.png";
      }
      if (File(filePath).existsSync()) {
        logger?.e('icon file exists, not cropPicture');
        return Future(() => File(filePath));
      }
      if (!File(path).existsSync()) {
        logger?.e('icon file not exists path 1 == ${path}');
        return Future(() => null);
      }
      var image = pkg_img.decodeImage(File(path).readAsBytesSync());
      if (image == null) {
        logger?.e('icon file not exists path 2 == ${path}');
        return Future(() => null);
      }
      logger?.v("cropPicture - imageCompressToPng");
      /// 格式转换
      final pngImage = await _libMgr.tools.imageCompressToPng(path) ?? image;
      logger?.v("cropPicture - copyResize");
      /// 缩放
      final resizeImage = pkg_img.copyResize(pngImage,width:iconWidth, height:iconHeight,interpolation: pkg_img.Interpolation.cubic);
      logger?.v("cropPicture - copyCropCircle");
      /// 图片裁圆
      final circleImage = pkg_img.copyCropCircle(resizeImage);
      logger?.v("cropPicture - writeAsBytes");
      /// 写入文件
      file = await File(filePath).writeAsBytes(pkg_img.encodePng(circleImage));
      logger?.v("cropPicture - done");
      ///图片压缩 (暂时不压缩处理)
      // _coreMgr.compressToPNG(inputFilePath: file.path, outputFilePath: file.path);
    }catch (e){
       logger?.e("cutting picture error == $e");
    }
    return file;
  }
}