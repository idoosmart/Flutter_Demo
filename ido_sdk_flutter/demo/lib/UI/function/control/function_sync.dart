//  获取功能的通用样式

import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';
import 'package:protocol_lib/protocol_lib.dart';
import '../../common/commonTool.dart';

typedef _Fn = void Function();

class FunctionSync extends StatelessWidget {
  // nav的名字
  final String navTitle;

  const FunctionSync({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),
      body: _FunctionSyncContent(navTitle),
    );
  }
}

class _FunctionSyncContent extends StatefulWidget {
  final String typeName;
  const _FunctionSyncContent(this.typeName, {super.key});

  @override
  State<StatefulWidget> createState() => _FunctionSyncContentState(typeName);
}

class _FunctionSyncContentState extends State<_FunctionSyncContent> {
  final String typeName;
  _FunctionSyncContentState(this.typeName);

  // 获取到字符串
  String resultStr = '';
  bool isSyncing = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    libManager.syncData.stopSync();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext ctx, int index) {
        if (index == 0) {
          return Text(
            S.current.deviceConnected,
            style: const TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          );
        } else if (index == 1) {
          return ElevatedButton(
              onPressed: _doIt(S.current.startsync),
              child: Column(
                children: [
                  Text(
                    S.current.startsync,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ));
        } else if (index == 2) {
          return ElevatedButton(
              onPressed: _doIt(S.current.stopsync),
              child: Column(
                children: [
                  Text(
                    S.current.stopsync,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ));
        } else if (index == 3) {
          return Text(resultStr);
        }

        return const Text('test');
      },
      itemCount: 4,
      // itemExtent: 70,
    );
  }

  void _updateInformation() {
    setState(() {
      //_counter++;
    });
  }

  void _startSync() {
    isSyncing = true;
    resultStr = '';
    libManager.syncData.startSync(
        funcProgress: (progress) {
          debugPrint("progress: $progress");
        },
        funcData: (type, jsonStr, errorCode) async {
          resultStr += '\n$type: \n json:$jsonStr';
          _updateInformation();
        },
        funcCompleted: (errorCode) {
          resultStr += '\n sync done';
          isSyncing = false;
          _updateInformation();
        });
  }

  void _stopSync() {
    libManager.syncData.stopSync();
    isSyncing = false;
    _updateInformation();
  }

  _Fn? _doIt(title) {
    if (title == S.current.startsync) {
      return isSyncing
          ? null
          : () {
              _startSync();
            };
    } else if (title == S.current.stopsync) {
      return !isSyncing
          ? null
          : () {
              _stopSync();
            };
    }
  }
}
