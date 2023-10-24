

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:protocol_core/protocol_core.dart';
import 'package:protocol_lib/protocol_lib.dart';

import '../ido_message_icon.dart';
import '../../private/logger/logger.dart';

abstract class SetAppName {

  factory SetAppName() => _SetAppName();

  Stream<bool>setAppName(List<IDOAppInfo> items);

}

class _SetAppName implements SetAppName {

  late final _libMgr = IDOProtocolLibManager();
  late final _iconMgr = IDOMessageIcon();

  Completer<bool>? _completer;

  @override
  Stream<bool> setAppName(List<IDOAppInfo> items) {
    _completer = Completer();
    final stream = CancelableOperation.fromFuture(
        _exec(items),
        onCancel: () {
          _completer?.complete(false);
          _completer = null;
        }).asStream();
    return stream;
  }

}

extension _SetAppNameExt on _SetAppName {

  Future<bool> _exec(List<IDOAppInfo> items) async {
    if (items.isEmpty) {
      Future((){
        _completer?.complete(false);
        _completer = null;
      });
      return _completer!.future;
    }
    logger?.d('need set app name items length == ${items?.length}');
    List<Future> futures = <Future>[];
    for (var element in items) {
      var appName = element?.appName ?? '';
      var evtType = element?.evtType ?? 0;
      if (appName.length > 0) {
         final dic = {
           "verison":0,
           "os_platform": (Platform.isAndroid ? 1 : 2),
           "evt_type": evtType,
           "notify_type": 0,
           "msg_ID": 0,
           "contact": '',
           "phone_number": '',
           "msg_data": '',
           "app_items_len": 1,
           "items": [{"language":_iconMgr.ios_languageUnit?? 2,"name":appName}],
         };
         final json_str = jsonEncode(dic);
         final future = _libMgr.send(evt: CmdEvtType.setNoticeAppName,json: json_str).first;
         futures.add(future);
      }
    }
    Future.wait(futures).then((value) {
     final items = value.where((element) => (element as CmdResponse).code != 0).toList();
       _completer?.complete(items.length == 0);
       _completer = null;
    });
    return _completer!.future;
  }

}