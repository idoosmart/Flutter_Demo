
import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image/image.dart' as pkg_img;
import 'package:protocol_core/protocol_core.dart';
import 'package:protocol_lib/protocol_lib.dart';
import 'package:tuple/tuple.dart';

import '../../private/logger/logger.dart';

abstract class DownloadIcon {

  factory DownloadIcon() => _DownloadIcon();

  Stream<IDOAppIconInfoModel>startDownload(IDOAppIconInfoModel model);
}

class _DownloadIcon implements DownloadIcon {

  late final _coreMgr = IDOProtocolCoreManager();
  late final _libMgr = IDOProtocolLibManager();

  Completer<IDOAppIconInfoModel>? _completer;

  @override
  Stream<IDOAppIconInfoModel> startDownload(IDOAppIconInfoModel model) {
    _completer = Completer();
    final stream = CancelableOperation.fromFuture(
        _exec(model),
        onCancel: () {
          _completer?.complete(model);
          _completer = null;
        }).asStream();
    return stream;
  }

}

extension _DownloadIconExt on _DownloadIcon {

  /// 地址映射包名
  String _getPackNameWithPath(String? path,List<IDOAppIconItemModel> items) {
     for (var i = 0; i < items.length; i++) {
        final item = items[i];
        final path1 = item.iconCloudPath??'';
        final path2 = path??'';
        if (path2.length > 0 && path1.contains(path2)) {
            return item.packName ?? '';
        }
     }
     return '';
  }

  /// 执行下载图片
  Future<IDOAppIconInfoModel> _exec(IDOAppIconInfoModel model) async {
    final dirPath = await _libMgr.messageIcon.ios_getIconDirPath();
    if (dirPath == '') {
      Future((){
        _completer?.complete(model);
        _completer = null;
      });
      return _completer!.future;
    }
    final items = model?.items?.where((element) {
      var isDownload = element.isUpdateAppIcon ?? false;
      var big = element.iconLocalPathBig ?? '';
      return !isDownload && big.isEmpty;
    }).toList();

    if (items?.length == 0) {
      Future((){
        _completer?.complete(model);
        _completer = null;
      });
      return _completer!.future;
    }
    logger?.d('need download icon items length == ${items?.length}');
    List<Future> futures = <Future>[];
    items?.forEach((element) {
      var path = element.iconCloudPath;
      var httpClient = new http.Client();
      var request = new http.Request('GET',Uri.parse(path??''));
      Future future = httpClient.send(request).then((response){
        final urlPath = response.request?.url?.path;
        logger?.d('icon urlPath == ${urlPath}');
        final packName = this._getPackNameWithPath(urlPath,model.items??[]);
        if (packName == '') {
          logger?.d('the network address is not mapped to the corresponding package name');
          return Tuple2('', '');
        }
        final filePath = "${dirPath}/${packName}${'_100'}.png";
        return response.stream.toBytes().then((value) {
         return File(filePath).writeAsBytes(value).then((file1) {
           return _cropPicture(filePath, packName, model.iconWidth ?? 46, model.iconHeight ?? 46).then((file2) {
             logger?.d('download icon success == ${packName}');
              return Tuple2(file1.path,file2?.path??'');
            });
          });
        });
      }).onError((error, stackTrace) {
        return Tuple2('', '');
      }).timeout(const Duration(seconds: 10),
          onTimeout: (){
        return Tuple2('', '');
      });
      futures.add(future);
    });
    Future allTasks = Future.wait(futures);
    allTasks.then((value) {
      final allItems = value as List?;
      allItems?.forEach((element) {
        model?.items?.forEach((item) {
          final tuple = element as Tuple2;
          final path1 = tuple.item1 as String;
          final path2 = tuple.item2 as String;
          if (path1.contains(item.packName)) {
            item?.iconLocalPathBig = path1;
            item?.iconLocalPath = path2;
          }
        });
      });
      _completer?.complete(model);
      _completer = null;
    });
    return _completer!.future;
  }

  /// 图片裁剪并压缩
  Future<File?>_cropPicture(String path,String packName,int iconWidth,int iconHeight) async {
    logger?.d('cutting picture pack name == ${packName} path == ${path} width == ${iconWidth} height == ${iconHeight}');
    final dirPath = await _libMgr.messageIcon.ios_getIconDirPath();
    var image = pkg_img.decodeImage(File(path).readAsBytesSync());
    if (image == null) {
      return Future(() => null);
    }
    var newImage = pkg_img.copyResize(image!,width:iconWidth, height:iconHeight);
    newImage = pkg_img.copyCropCircle(newImage!);
    final filePath = "${dirPath}/${packName}${'_46'}.png";
    final file = await File(filePath).writeAsBytes(pkg_img.encodePng(newImage));
    ///图片压缩
    _coreMgr.compressToPNG(inputFilePath: file.path, outputFilePath: file.path);
    return file;
  }

}