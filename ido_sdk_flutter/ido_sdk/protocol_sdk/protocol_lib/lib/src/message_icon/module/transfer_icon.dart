

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:image/image.dart' as pkg_img;
import 'package:protocol_core/protocol_core.dart';
import 'package:protocol_lib/protocol_lib.dart';
import 'package:protocol_lib/src/message_icon/ido_message_icon.dart';

import '../../private/logger/logger.dart';

abstract class TransferIcon {

  factory TransferIcon() => _TransferIcon();

  /// 只执行文件传输
  Stream<bool>onlyStartTransfer(IDOAppIconInfoModel model);

  /// 裁剪图片和文件传输
  Stream<bool>tailorAndTransfer(IDOAppIconInfoModel model);

  /// 注册思澈图标传输
  void addSeChe(SeCheMessageIconDelegate? delegate);
}

class _TransferIcon implements TransferIcon {

  late final _coreMgr = IDOProtocolCoreManager();
  late final _libMgr = IDOProtocolLibManager();

  /// 思澈消息图标代理对象
  SeCheMessageIconDelegate? _scDelegate;

  Completer<bool>? _completer;
  /// 图标宽度
  int? _iconWidth;
  /// 图标高度
  int? _iconHeight;

  @override
  Stream<bool> tailorAndTransfer(IDOAppIconInfoModel model) {
    _completer = Completer();
    final stream = CancelableOperation.fromFuture(
        _tailorTransferExec(model),
        onCancel: () {
          _completer?.complete(false);
          _completer = null;
        }).asStream();
    return stream;
  }

  @override
  Stream<bool> onlyStartTransfer(IDOAppIconInfoModel model) {
    _completer = Completer();
    final stream = CancelableOperation.fromFuture(
        _onlyTransferExec(model),
        onCancel: () {
          _completer?.complete(false);
          _completer = null;
        }).asStream();
    return stream;
  }

  @override
  void addSeChe(SeCheMessageIconDelegate? delegate) {
    _scDelegate = delegate;
  }

}

extension _TransferIconExt on _TransferIcon {

  /// 图片裁剪并压缩
  Future<bool>_tailorPicture(List<IDOAppIconItemModel> items) async {
    logger?.d('android start tailor picture');
    final dirPath = await _libMgr.messageIcon.getIconDirPath();
    if (dirPath == '') {
      logger?.d('icon dir path is empty 1');
      return Future(()=> false);
    }
    logger?.d('icon dir path == $dirPath');
    List<Future> futures = <Future>[];
    items.forEach((element) {
      if ((element.iconLocalPath??'').isNotEmpty) {
        final filePath = "$dirPath/${element.packName}${'_$_iconWidth'}.png";
        final filePng = File(filePath);
        if (filePng.existsSync()) { /// 图片文件存在不再处理
          logger?.d('file presence no longer needs to be clipped => ${element.packName}');
          element.iconLocalPath = filePath;
          futures.add(Future(()=> true));
        }else {
          var image = pkg_img.decodeImage(File(element.iconLocalPath).readAsBytesSync());
          if (image == null) {
            logger?.d('icon file does not exist => ${element.packName}');
            futures.add(Future(()=> false));
          }else {
            logger?.d('icon file start corp circle => ${element.packName}');
            final radius  = (_iconWidth?? 46) ~/2;
            logger?.d("android icon radius == $radius");
            /// 转图片格式
            final future = _libMgr.tools.imageCompressToPng(element.iconLocalPath).then((pngImage) {
              /// 计算非透明图标宽度
              final noTranWidth = _getNoTransparentWidth(pngImage ?? image!);
              logger?.d("noTranWidth == $noTranWidth pack name == ${element.packName}");
              /// 图片裁圆
              var circleImage =  pkg_img.copyCropCircle(pngImage ?? image!,radius: noTranWidth~/2);
              logger?.d("android crop circle icon == ${circleImage.isNotEmpty}");
              /// 图片缩放
              var resizeImage = pkg_img.copyResize(circleImage!, width:_iconWidth ?? 46, height:_iconHeight ?? 46,interpolation: pkg_img.Interpolation.cubic);
              /// 写入文件
              return File(filePath).writeAsBytes(pkg_img.encodePng(resizeImage)).then((file1){
                logger?.d("android picture redrawing");
               // return canvasImage(file1).then((file2){
               //   /// 画圆裁剪图标
               //   var canvasImage = pkg_img.decodeImage(file2.readAsBytesSync());
               //   var resizeImage = pkg_img.copyResize(canvasImage!, width:_iconWidth ?? 46, height:_iconHeight ?? 46,interpolation: pkg_img.Interpolation.cubic);
               //   logger?.d("android resize icon == ${resizeImage.isNotEmpty}");
               //   return File(filePath).writeAsBytes(pkg_img.encodePng(resizeImage)).then((file3){
               //     ///图片压缩 （暂时不压缩图片）
               //     logger?.d('icon file start compress => ${element.packName}');
               //     // _coreMgr.compressToPNG(inputFilePath: file3.path, outputFilePath: file3.path);
               //     ///赋值裁剪后地址
               //     element.iconLocalPath = file3.path;
               //     return Future(() => true);
               //   });
               //  }).onError((error, stackTrace) {
               //   logger?.d("android picture redrawing failed error == ${error.toString()} file path == $filePath");
               //    return Future(() => false);
               //  });
                element.iconLocalPath = file1.path;
                return Future(() => true);
              }).onError((error, stackTrace) {
                logger?.d("android write icon file failed error == ${error.toString()} file path == $filePath");
                return Future(() => false);
              });
            }).onError((error, stackTrace) {
              logger?.d("android compress to png failed error == ${error.toString()} file path == $filePath");
              return Future(() => false);
            });
            futures.add(future);
          }
         }
      }else {
        logger?.d('icon file path is empty => ${element.packName}');
        futures.add(Future(() => false));
      }
    });
    if (futures.isEmpty) {
      logger?.d('icon dir path is empty 2');
      return Future(()=> false);
    }
    Future allTasks = Future.wait(futures);
    return allTasks.then((value) {
      logger?.d('android copy crop circle complete === ${value}');
      return true;
    });
  }

  /// 计算非透明图片的宽度
  int _getNoTransparentWidth(pkg_img.Image pngImage) {
    // 获取图像的宽度和高度
    final width = pngImage!.width;
    final height = pngImage.height;
    // 遍历图像的每个像素
    int notTransparentWidth = 0;
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        // 获取像素的alpha通道值
        final alpha = pngImage.getPixel(x, y);
        // 如果alpha通道值为0，表示透明像素
        if (alpha.a != 0) {
          notTransparentWidth++;
        }
      }
    }
    double squareRoot = sqrt(notTransparentWidth);
    return squareRoot.toInt();
  }

  /// 画圆裁剪图标
  Future<File> canvasImage(File file) async{
    try {
      var paint = Paint()
        ..isAntiAlias = true;
      final recorder = ui.PictureRecorder();
      final bytes = file.readAsBytesSync();
      final image = await decodeImageFromList(bytes);
      final width = image.width;
      final height = image.height;
      final canvas = Canvas(recorder,Rect.fromLTWH(0,0,width.toDouble(),height.toDouble()));
      final radius = min(width,height)~/2;
      final srcRect = ui.Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
      final destRect = ui.Rect.fromCircle(center: ui.Offset(radius.toDouble(),radius.toDouble()), radius: radius - 4);
      canvas.drawImageRect(image,srcRect,destRect,paint);
      canvas.restore();
      final newImage = await recorder.endRecording().toImage(width,height);
      final a = await newImage.toByteData(format: ui.ImageByteFormat.png);
      file.writeAsBytesSync(a!.buffer.asInt8List());
      return file;
    }catch (e) {
      logger?.e("android canvas image error == ${e.toString()}");
    }
    return file;
  }

  /// 图标裁剪传输执行
  Future<bool> _tailorTransferExec(IDOAppIconInfoModel model) async {

    var items = model?.items?.where((element) {
      var isDownload = element.isUpdateAppIcon ?? false;
      return !isDownload;
    }).toList() ?? [];

    if(items.isEmpty) {
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
    if (_iconWidth == 0 || _iconHeight == 0) {
        _iconWidth = 60;
        _iconHeight = 60;
    }
    logger?.d('icon width == ${_iconWidth!} icon height == ${_iconHeight!}');
    /// 裁剪图标
    logger?.d("android tailor picture time length == ${items.length}");

    /// 裁剪超时增加1秒，当只有1个图标裁剪时容易超时
    final isOk = await _tailorPicture(items)
        .timeout(Duration(seconds: (items.length + 1)),
        onTimeout: () {
       logger?.d('android tailor picture timeout');
       return false;
    });

    if (!isOk) {
      logger?.d('android tailor picture failed');
      return Future(() => false);
    } else {
      logger?.d('android tailor picture success');
    }

    return _transfer(items);
  }



  Future<bool> _onlyTransferExec(IDOAppIconInfoModel model) async {
    final items = model?.items?.where((element) {
      var isDownload = element.isUpdateAppIcon ?? false;
      return !isDownload;
    }).toList();
    return _transfer(items ?? []);
  }

  /// 传输图标
  Future<bool> _transfer(List<IDOAppIconItemModel> items) async {
    final fileItems = <MessageFileModel>[];
    for (var element in items) {
      var path = element?.iconLocalPath ?? '';
      var packName = element?.packName ?? '';
      var evtType = element?.evtType ?? 0;
      if (path.isNotEmpty) {
        final item = MessageFileModel(filePath: path, fileName:'', evtType: evtType, packName: packName);
        fileItems.add(item);
      }
    }
    if (fileItems.isEmpty) {
      /// 传输文件个数0，不再执行传输
      logger?.d('if the number of transferred files is 0, no transmission is performed');
      Future((){
        _completer?.complete(false);
        _completer = null;
      });
      return _completer!.future;
    }

    logger?.d('need transfer icon items length == ${fileItems?.length}');

    return _transferIcon(fileItems);
  }

  Future<bool> _transferIcon(List<MessageFileModel> fileItems) {

    for (var element in fileItems) {
      logger?.d('transfer icon file path == ${element.filePath} package name == ${element.packName} event type == ${element.evtType}');
    }

     if (_libMgr.deviceInfo.platform == 97) {
       logger?.d('transfer icon file siche protocol delegate == $_scDelegate');
       if (_scDelegate != null) {
         _scDelegate?.iconTransferFile(fileItems, (isSuccess, filePath) {
           logger?.d('siche transfer icon file path == $filePath state == $isSuccess');
         }, (complete) {
           logger?.d('siche _transfer message icon complete == $complete');
           _completer?.complete(complete);
           _completer = null;
         });
       }else {
         _completer?.complete(false);
         _completer = null;
       }
     }else {
       logger?.d('transfer icon file ido protocol');
       _libMgr.transFile.transferMultiple(fileItems: fileItems, funcStatus:
           (index, status) {
         if (status == FileTransStatus.busy) {
           final item = fileItems[index];
           final packName = item.packName;
           final path = item.filePath;
           logger?.d('transfer file busy pack name == $packName file path == $path');
         }
       }, funcProgress: (currentIndex, totalCount, currentProgress, totalProgress){

       }).listen((event) {
         logger?.d('_transfer message icon complete == ${event}');
         _completer?.complete(event.last);
         _completer = null;
       });
     }
    return _completer!.future;
  }

}