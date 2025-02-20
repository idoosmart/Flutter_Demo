
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:protocol_core/protocol_core.dart';
import 'package:protocol_lib/protocol_lib.dart';

import '../../private/logger/logger.dart';

abstract class GetAppInfo {

  factory GetAppInfo() => _GetAppInfo();

  Stream<IDOAppIconInfoModel>startGetInfo(IDOAppIconInfoModel model);
}

class _GetAppInfo implements GetAppInfo {

  late final _libMgr = IDOProtocolLibManager();

  Completer<IDOAppIconInfoModel>? _completer;

  @override
  Stream<IDOAppIconInfoModel> startGetInfo(IDOAppIconInfoModel model) {
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

extension _GetAppInfoExt on _GetAppInfo {

  Future<IDOAppIconInfoModel> _exec(IDOAppIconInfoModel model) async {
    final items = model?.items?.where((element) {
      var isDownload = element.isDownloadAppInfo ?? false;
      return !isDownload;
    }).toList();
    if (items?.length == 0) {
      logger?.d('app name exists do not need to get app info');
      Future(() {
        _completer?.complete(model);
        _completer = null;
      });
      return _completer!.future;
    }
    logger?.d('need get app info items length == ${items?.length} \n app info == ${items?.map((e) => e.packName).toList()}');
    List<Future> futures = <Future>[];
    items?.forEach((element) {
      final future = _addTryGetAppInfo(_libMgr.messageIcon.ios_countryCode ?? 'US', element.packName);
      futures.add(future);
    });
    Future allTasks = Future.wait(futures);
    allTasks.then((value) {
      final allItems = value as List?;
      allItems?.forEach((element) {
        final bundleId = element['bundleId'] as String? ?? '';
        model.items?.forEach((item) {
          if (bundleId == item.packName) {
            item.appName = element['trackName'] as String? ?? '';
            item.packName = element['bundleId'] as String? ?? '';
            item.iconCloudPath = element['artworkUrl100'] as String? ?? '';
            item.countryCode = element['country'] as String? ?? '';
            item.appVersion = element['version'] as String? ?? '';
          }
        });
      });
      _completer?.complete(model);
      _completer = null;
    });
    return _completer!.future;
  }

  Future _addTryGetAppInfo(String country, String packName) async{
    final dic = (await _getAppInfo(country, packName)) as Map<String, dynamic>;
    final state = dic["success"] as bool? ?? false;
    if (state == false) {
      /// 重试一次 使用"US"国家编码获取
      logger?.d("get app info error == $dic");
      logger?.d('try again get app info country == $country packName == $packName');
      return _getAppInfo("US", packName);
    }else {
      return Future(() => dic);
    }
  }

  /// 下载获取APP信息
  Future _getAppInfo(String country, String packName) {
    if (packName == "in.startv.hotstarLite") {
      /// 此应用英国发布的app，需要使用"GB"国家编码获取
      country = 'GB';
    }
    try {
      var httpClient = http.Client();
      var baseUrl = _libMgr.messageIcon.ios_baseUrlPath ?? 'https://itunes.apple.com/lookup';
      var appKey  = _libMgr.messageIcon.ios_appKey ?? '800a6444f9c0433c8e88741b6ddf1443';
      var request = http.Request('GET',Uri.parse('${baseUrl}?bundleId=${packName}&country=${country}'));
      if (baseUrl == 'https://itunes.apple.com/lookup') {
        request.headers.addAll({"content-type":"application/json; charset=utf-8"});
      }else {
        request.headers.addAll({"content-type":"application/json; charset=utf-8","appKey":appKey});
      }
      Future future = httpClient.send(request)
          .then((response){
        return response.stream.bytesToString().then((value) {
          final responseObject = jsonDecode(value) as Map<String,dynamic>;
          final results = responseObject['results'] as List<dynamic>?;
          if (results == null || results?.length == 0) {
            final dic = {"bundleId":"","success":false,"artworkUrl100":"",
              "trackName":"","country":"","version":"","message":"data is empty"};
            return dic;
          }else {
            logger?.d('response == ${results}');
            var objc = results?[0] as Map<String,dynamic>?;
            var path = objc?['artworkUrl100'] as String? ?? '';
            var id = objc?['bundleId'] as String? ?? '';
            var appName = objc?['trackName'] as String? ?? '';
            var code = objc?['country'] as String? ?? country;
            var version = objc?['version'] as String? ?? '';
            final dic = {"bundleId":id,"success":true,"artworkUrl100":path,
              "trackName":appName,"country":code,"version":version,"message":"request data success"};
            logger?.d('get app info success == ${dic}');
            return dic;
          }
        }).catchError((error){
          logger?.d(error.toString());
          final dic = {"bundleId":"","success":false,"artworkUrl100":"",
            "trackName":"","country":"","version":"","message":error.toString()};
          return dic;
        });
      })
          .onError((error, stackTrace) {
        final dic = {"bundleId":"","success":false,"artworkUrl100":"",
          "trackName":"","country":"","version":"","message":error.toString()};
        return dic;
      }).timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            final dic = {"bundleId":"","success":false,"artworkUrl100":"",
              "trackName":"","country":"","version":"","message":"request data timeout"};
            return dic;
          });
      return future;
    }catch (e) {
      logger?.e('get app info error == $e');
      final dic = {"bundleId":"","success":false,"artworkUrl100":"",
        "trackName":"","country":"","version":"","message":"request data timeout"};
      return Future(() => dic);
    }
  }

}