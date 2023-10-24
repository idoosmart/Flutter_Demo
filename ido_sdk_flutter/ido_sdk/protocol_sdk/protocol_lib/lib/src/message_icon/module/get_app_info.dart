
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
      Future(() {
        _completer?.complete(model);
        _completer = null;
      });
      return _completer!.future;
    }
    logger?.d('need get app info items length == ${items?.length}');
    List<Future> futures = <Future>[];
    items?.forEach((element) {
      var httpClient = new http.Client();
      var baseUrl = _libMgr.messageIcon.ios_baseUrlPath ?? 'https://itunes.apple.com/lookup';
      var country = _libMgr.messageIcon.ios_countryCode ?? 'US';
      var appKey  = _libMgr.messageIcon.ios_appKey ?? '800a6444f9c0433c8e88741b6ddf1443';
      var bundleId = element.packName ?? '';
      var request = new http.Request('GET',Uri.parse('${baseUrl}?bundleId=${bundleId}&country=${country}'));
      if (baseUrl == 'https://itunes.apple.com/lookup') {
        request.headers.addAll({"content-type":"application/json; charset=utf-8"});
      }else {
        request.headers.addAll({"content-type":"application/json; charset=utf-8","appKey":appKey});
      }
      Future future = httpClient.send(request).then((response){
        return response.stream.bytesToString().then((value) {
          final responseObject = jsonDecode(value) as Map<String,dynamic>;
          final results = responseObject['results'] as List<dynamic>?;
          if (results?.length == 0) {
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
      }).onError((error, stackTrace) {
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
      futures.add(future);
    });
    Future allTasks = Future.wait(futures);
    allTasks.then((value) {
      final allItems = value as List?;
      allItems?.forEach((element) {
        model.items?.forEach((item) {
          final bundleId = element['bundleId'] as String? ?? '';
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
}