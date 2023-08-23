

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:image/image.dart' as pkg_img;
import 'package:protocol_core/protocol_core.dart';
import 'package:protocol_lib/protocol_lib.dart';
import 'package:protocol_lib/src/private/local_storage/local_storage.dart';

import '../../private/logger/logger.dart';

abstract class TransferIcon {

  factory TransferIcon() => _TransferIcon();

  /// ios 文件传输接口
  Stream<bool>ios_startTransfer(IDOAppIconInfoModel model);

  /// ios android 需要裁剪图片 文件传输接口
  Stream<bool>tailor_Transfer(List<IDOAppInfo> items);

}

class _TransferIcon implements TransferIcon {

  late final _coreMgr = IDOProtocolCoreManager();
  late final _libMgr = IDOProtocolLibManager();

  Completer<bool>? _completer;
  /// 图标宽度
  int? _iconWidth;
  /// 图标高度
  int? _iconHeight;

  @override
  Stream<bool> tailor_Transfer(List<IDOAppInfo> items) {
    _completer = Completer();
    final stream = CancelableOperation.fromFuture(
        _tailorTransferExec(items),
        onCancel: () {
          _completer?.complete(false);
          _completer = null;
        }).asStream();
    return stream;
  }

  @override
  Stream<bool> ios_startTransfer(IDOAppIconInfoModel model) {
    _completer = Completer();
    final stream = CancelableOperation.fromFuture(
        _iosExec(model),
        onCancel: () {
          _completer?.complete(false);
          _completer = null;
        }).asStream();
    return stream;
  }
}

extension _TransferIconExt on _TransferIcon {

  //********** android *****************

  /// 图片裁剪并压缩
  Future<bool>_tailorPicture(List<IDOAppInfo> items) async {
    final dirPath = await _libMgr.messageIcon.ios_getIconDirPath();
    if (dirPath == '') {
      logger?.d('icon dir path is empty');
      return Future(()=> false);
    }
    /* 测试代码
    final rootPath = await storage!.pathRoot();
    final item = items[0];
    item.iconLocalPath = rootPath + '/com.weaver.emobile7_100.png';
    */
    List<Future> futures = <Future>[];
    items.forEach((element) {
      if ((element.iconLocalPath??'').length > 0) {
        var image = pkg_img.decodeImage(File(element.iconLocalPath??'').readAsBytesSync());
        if (image == null) {
          logger?.d('icon file does not exist => ${element.packName}');
          futures.add(Future(()=> false));
        }else {
          logger?.d('icon file start corp circle => ${element.packName}');
          var newImage = pkg_img.copyResize(image!, width:_iconWidth?? 46, height:_iconHeight?? 46);
          newImage = pkg_img.copyCropCircle(newImage!);
          final filePath = "${dirPath}/${element.packName}${'_46'}.png";
          final future = File(filePath).writeAsBytes(pkg_img.encodePng(newImage)).then((file){
            logger?.d('icon file start compress => ${element.packName}');
            ///图片压缩
            _coreMgr.compressToPNG(inputFilePath: file.path, outputFilePath: file.path);
            ///赋值裁剪后地址
            element.iconLocalPath = file.path;
            return _one_transfer(element);
          });
          futures.add(future);
        }
      }else {
        logger?.d('icon file path is empty => ${element.packName}');
        futures.add(Future(() => false));
      }
    });
    Future allTasks = Future.wait(futures);
    return allTasks.then((value) {
      logger?.d('android transfer message icon complete === ${value}');
      return true;
    });
  }

  /// 图标裁剪传输执行
  Future<bool> _tailorTransferExec(List<IDOAppInfo> items) async {
    if(items.length == 0) {
      logger?.d('android tailor transfer 0 count');
      return Future(() => false);
    }
    logger?.d('android need tailor transfer items length == ${items?.length}');
    /// 获取图标大小
    final config = {
      "type": 0,
      "evt_type": 1,
      "sport_type": 0
    };
    final response = await _libMgr.send(evt:CmdEvtType.getDataTranConfig,json:jsonEncode(config)).first;
    if (response.code != 0) {
      logger?.d('android get data transfer config failed');
       return Future(()=> false);
    }
    final dic = jsonDecode(response.json!) as Map<String,dynamic>;
    _iconWidth = dic['icon_width'] as int? ?? 0;
    _iconHeight = dic['icon_height'] as int? ?? 0;
    logger?.d('icon width == ${_iconWidth} icon height == ${_iconHeight}');
    /// 裁剪图标
    return _tailorPicture(items);
  }

  /// 传输单张图标
  Future<bool> _one_transfer(IDOAppInfo model) async {

    logger?.d('start android one transfer icon == ${model.iconLocalPath}');

    final item = MessageFileModel(filePath: model.iconLocalPath, fileName:'', evtType: model.evtType, packName: model.packName);

    _libMgr.transFile.transferSingle(fileItem: item, funcStatus: (status) {

    }, funcProgress: (progress){

    }).listen((event) {
      logger?.d('_one_transfer == ${event}');
      _completer?.complete(event);
      _completer = null;
    }).onError((e){
      logger?.d('_one_transfer error == ${e}');
      _completer?.complete(false);
      _completer = null;
    });
    return _completer!.future;
  }


  //********** ios *****************

  /// ios 图标执行传输
  Future<bool> _iosExec(IDOAppIconInfoModel model) async {
    final items = model?.items?.where((element) {
      var isDownload = element.isUpdateAppIcon ?? false;
      return !isDownload;
    }).toList();
    return _transfer(items as List<IDOAppInfo>);
  }

  /// 传输图标
  Future<bool> _transfer(List<IDOAppInfo> items) async {
    final fileItems = <MessageFileModel>[];
    for (var element in items) {
      var path = element?.iconLocalPath ?? '';
      var packName = element?.iconLocalPath ?? '';
      var evtType = element?.evtType ?? 0;
      if (path.length > 0) {
        final item = MessageFileModel(filePath: path, fileName:'', evtType: evtType, packName: packName);
        fileItems.add(item);
      }
    }
    if (fileItems.length == 0) {
      /// 传输文件个数0，不再执行传输
      logger?.d('if the number of transferred files is 0, no transmission is performed');
      Future((){
        _completer?.complete(false);
        _completer = null;
      });
      return _completer!.future;
    }

    logger?.d('need transfer icon items length == ${items?.length}');

    _libMgr.transFile.transferMultiple(fileItems: fileItems, funcStatus: (index, status) {

    }, funcProgress: (currentIndex, totalCount, currentProgress, totalProgress){

    }).listen((event) {
      logger?.d('_transfer == ${event}');
      _completer?.complete(event.last);
      _completer = null;
    }).onError((e){
      logger?.d('_transfer error == ${e}');
      _completer?.complete(false);
      _completer = null;
    });
    return _completer!.future;
  }

}