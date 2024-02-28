import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth/ido_bluetooth.dart';
import 'package:ido_logger/ido_logger.dart';
import 'package:protocol_lib/protocol_lib.dart';
import 'package:english_words/english_words.dart';
import 'package:path_provider/path_provider.dart';

import '../detail/device_detail_page.dart';

class DeviceDetailContent extends StatefulWidget {
  const DeviceDetailContent({Key? key}) : super(key: key);

  @override
  State<DeviceDetailContent> createState() => _DeviceDetailContentState();
}

class _DeviceDetailContentState extends State<DeviceDetailContent> {
  // late final libManager = IDOProtocolLibManager();

  StreamSubscription? _subscripTrans;
  String state = IDOBluetoothDeviceStateType.disconnected.toString();

  IDOAppStartExchangeModel? _startModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    bluetoothManager.deviceState().listen((event) async {
      //print('event:${event.state.toString()}');
      if ((event.state == IDOBluetoothDeviceStateType.connected &&
              event.macAddress != null &&
              event.macAddress!.isNotEmpty)) {
        final device = bluetoothManager.currentDevice!;
        //debugPrint('begin markConnectedDevice');
        final otaType = device.isTlwOta
            ? IDOOtaType.telink
            : device.isOta
            ? IDOOtaType.nordic
            : IDOOtaType.none;
        final isBinded = await libManager.cache
            .loadBindStatus(macAddress: event.macAddress!);
        var uniqueId = event.macAddress!;
        // 获取设备uuid(只有ios)
        if (Platform.isIOS && bluetoothManager.currentDevice?.uuid != null) {
          uniqueId = bluetoothManager.currentDevice!.uuid!;
        }
        await libManager.markConnectedDeviceSafe(
            uniqueId: uniqueId,
            isBinded: isBinded,
            otaType: otaType);
        // debugPrint('end markConnectedDevice');
      } else if (event.state == IDOBluetoothDeviceStateType.disconnected) {
        // debugPrint('begin markDisconnectedDevice');
        await libManager.markDisconnectedDevice();
        // debugPrint('end markDisconnectedDevice');
      }
      setState(() {
        print(event.toJson());
        state = event.state.toString();
      });
    });

    libManager.exchangeData.listenBleResponse().listen((event) {
      if (event.code == 0) {
        debugPrint(
            'appListenBleExec === ${event.model?.day} ${event.model?.hour} ${event.model?.minute} ${event.model?.second}');
      }
    });

    libManager.exchangeData.v2_exchangeData().listen((event) {
      debugPrint(
          'v2_exchangeData === ${event?.day} ${event?.hour} ${event?.minute} ${event?.second}');
    });

    libManager.exchangeData.v3_exchangeData().listen((event) {
      debugPrint(
          'v3_exchangeData === ${event?.day} ${event?.hour} ${event?.minute} ${event?.second}');
    });
  }

  bind() {
    // libManager.deviceBind
    //     .startBind(osVersion: 15, deviceInfo: (d) {
    //       debugPrint('设备信息：$d');
    // }, functionTable: (f) {
    //   debugPrint('功能表：$f');
    // })
    libManager.deviceBind
        .startBind(
            osVersion: 15,
            deviceInfo: (d) {
              //debugPrint('设备信息：$d');
            },
            functionTable: (f) {})
        .listen((event) {
      switch (event) {
        case BindStatus.failed:
          debugPrint('绑定失败');
          break;
        case BindStatus.successful:
          debugPrint('绑定成功');
          break;
        case BindStatus.binded:
          debugPrint('该设备已绑定');
          break;
        case BindStatus.needAuth:
          debugPrint('需要配对码绑定');
          break;
        case BindStatus.refusedBind:
          debugPrint('拒绝绑定');
          break;
        case BindStatus.wrongDevice:
          debugPrint('绑定错误设备');
          break;
        case BindStatus.authCodeCheckFailed:
          debugPrint('授权码校验失败，请重试');
          break;
        case BindStatus.canceled:
           debugPrint('取消绑定操作');
          break;
        case BindStatus.failedOnGetFunctionTable:
           debugPrint('BindStatus.failedOnGetFunctionTable');
          break;
        case BindStatus.failedOnGetDeviceInfo:
           debugPrint('BindStatus.failedOnGetDeviceInfo');
          break;
      }
    });
  }

  unbind() {
    libManager.deviceBind
        .unbind(macAddress: libManager.macAddress)
        .then((res) {
      debugPrint(res ? '解绑成功' : '解绑失败，请重试');
    });
  }

  testGetCmd() {
    createGetCmd().forEach((e) {
      libManager.send(evt: e.cmd, json: jsonEncode(e.json ?? {})).listen((res) {
        debugPrint(
            '${e.name} evtType:${e.cmd.evtType} code:${res.code} json: ${res.json ?? 'NULL'}');
      });
    });
  }

  testSetCmd() {
    try {
      createSetCmd().forEach((e) {
        libManager
            .send(evt: e.cmd, json: jsonEncode(e.json ?? {}))
            .listen((res) {
          debugPrint(
              '${e.name} ${e.cmd.evtType} 返回 code: ${res.code} json: ${res.json ?? 'NULL'}');
        });
      });
    } catch (e) {
      print('error: $e');
    }

    // Future.delayed(
    //     Duration(seconds: 1),
    //         () {
    //          libManager.markDisconnectedDevice();
    //         });
  }

  syncData() async {
    // libManager.messageIcon.ios_countryCode = 'CN';
    // libManager.messageIcon.ios_baseUrlPath = 'https://ali-user.idoocloud.com/api/ios/lookup/get';
    // libManager.messageIcon.ios_getDefaultAppInfo();
    // final dirPath = await libManager.messageIcon.getIconDirPath();
    // final model1 = IDOAppIconItemModel(evtType: 1, packName: 'com.ido.life', appName: '', iconLocalPath: '');
    // final model2 = IDOAppIconItemModel(evtType: 2, packName: 'com.tencent.mqq', appName: '', iconLocalPath: '');
    // final model3 = IDOAppIconItemModel(evtType: 3, packName: 'com.tencent.xin', appName: '', iconLocalPath: '');
    // final model4 = IDOAppIconItemModel(evtType: 4, packName: 'ph.telegra.Telegraph', appName: '', iconLocalPath: '');
    // final model5 = IDOAppIconItemModel(evtType: 5, packName: 'com.zhiliaoapp.musically', appName: '', iconLocalPath: '');
    // final model6 = IDOAppIconItemModel(evtType: 6, packName: 'pinterest', appName: '', iconLocalPath: '');
    // libManager.messageIcon.test([model1,model2,model3,model4,model5,model6]);

    // final item = IDOAppInfo(
    //     evtType: 1,
    //     packName: 'com.weaver.emobile7',
    //     appName: 'Emobile7',
    //     iconLocalPath: '');

    // libManager.messageIcon.android_transferAppIcon([item]).listen((event) {
    //   debugPrint('android_transferAppIcon: $event');
    // });

    // libManager.syncData.startSync(funcProgress: (progress) {
    //   debugPrint(
    //     '数据同步 - $progress',
    //   );
    // }, funcData: (type, jsonStr, errorCode) {
    //   debugPrint('数据同步 - type：$type jsonStr: $jsonStr');
    // }, funcCompleted: (errorCode) {
    //   debugPrint('数据同步 - errorCode: $errorCode');
    // });

    // libManager.deviceLog.startGet([IDOLogType.reboot]).listen((event) {
    //   debugPrint('获取设备日志完成 ${event}');
    // });
  }

  cancelAll() async {
    _subscripTrans?.cancel();
    libManager.dispose();
    // libManager.cache.exportLog().then((value) {
    //   debugPrint('export log:$value');
    // });

    // final path = await libManager.funTable.exportFuncTableFile();
    // debugPrint('export funcTable:$path');
  }

  @override
  Widget build(BuildContext context) {
    final device =
        context.findAncestorWidgetOfExactType<DeviceDetailPage>()?.device;
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => bluetoothManager.connect(device),
          style: TextButton.styleFrom(backgroundColor: Colors.green),
          child: const Text("connect"),
        ),
        ElevatedButton(
          onPressed: () => bluetoothManager.cancelConnect(),
          style: TextButton.styleFrom(backgroundColor: Colors.green),
          child: const Text("cancelConnect"),
        ),
        Text(state),
        const SizedBox(
          height: 10,
        ),
        const SizedBox(
          height: 10,
        ),
        const Spacer(),
        Row(
          children: [
            CupertinoButton(
              onPressed: bind,
              child: const Text('绑定'),
            ),
            CupertinoButton(
              onPressed: unbind,
              child: const Text('解绑'),
            )
          ],
        ),
        Row(
          children: [
            CupertinoButton(
              onPressed: testGetCmd,
              child: const Text('获取指令'),
            ),
            CupertinoButton(
              onPressed: testSetCmd,
              child: const Text('设置指令'),
            ),
          ],
        ),
        Row(
          children: [
            //const Spacer(),
            CupertinoButton(
              onPressed: tranFile,
              child: const Text('文件传输'),
            ),
            //const Spacer(),
            CupertinoButton(
              onPressed: syncData,
              child: const Text('数据同步'),
            ),
          ],
        ),
        Row(
          children: [
            CupertinoButton(
              onPressed: cancelAll,
              child: const Text('取消所有指令'),
            ),
          ],
        ),
        Row(
          children: [
            CupertinoButton(
              onPressed: startSport,
              child: const Text('运动开始'),
            ),
          ],
        ),
        Row(
          children: [
            CupertinoButton(
              onPressed: endSport,
              child: const Text('运动停止'),
            ),
          ],
        ),
        Row(
          children: [
            CupertinoButton(
              onPressed: suspendSport,
              child: const Text('运动暂停'),
            ),
          ],
        ),
        Row(
          children: [
            CupertinoButton(
              onPressed: restoreSport,
              child: const Text('运动恢复'),
            ),
          ],
        ),
        // const SizedBox(
        //   height: 80,
        // ),
      ],
    );
  }

  startSport() {
    _startModel = IDOAppStartExchangeModel();
    final date = DateTime.now();
    _startModel?.day = date.day;
    _startModel?.hour = date.hour;
    _startModel?.minute = date.minute;
    _startModel?.second = date.second;
    _startModel?.sportType = 48;
    _startModel?.forceStart = 1;

    libManager.exchangeData.appExec(model: _startModel!);
  }

  endSport() {
    final model = IDOAppEndExchangeModel();
    model.isSave = 1;
    model.day = _startModel?.day;
    model.hour = _startModel?.hour;
    model.minute = _startModel?.minute;
    model.second = _startModel?.second;
    model.duration = 10;
    model.calories = 10;
    model.distance = 10;
    libManager.exchangeData.appExec(model: model);
  }

  suspendSport() {}

  restoreSport() {}

  List<_TestCmd> createGetCmd() {
    return [
      // _TestCmd(cmd: CmdEvtType.getMac, name: '获取mac地址'),
      // _TestCmd(cmd: CmdEvtType.getDeviceInfo, name: '获取设备信息'),
      // _TestCmd(cmd: CmdEvtType.getScreenBrightness, name: '获取屏幕亮度'),
      // _TestCmd(cmd: CmdEvtType.getFirmwareBtVersion, name: '获得固件三级版本和bt的3级版本'),
      // _TestCmd(cmd: CmdEvtType.getDeviceName, name: '获取手表名字'),
      // _TestCmd(cmd: CmdEvtType.getVersionInfo, name: '获取版本信息'),
      // _TestCmd(cmd: CmdEvtType.getWatchDialInfo, name: '获取屏幕信息'),
      // _TestCmd(cmd: CmdEvtType.getStressVal, name: '获取压力值'),
      // _TestCmd(cmd: CmdEvtType.getHeartRateMode, name: '获取心率监测模式'),
      // _TestCmd(cmd: CmdEvtType.getDeviceName, name: '获取设备名称'),
      _TestCmd(cmd: CmdEvtType.getBleMusicInfo, name: '获取音乐信息'),
    ];
  }

  // List<_TestCmd> createGetCmd2() {
  //   final list = <_TestCmd>[];
  //   for (var element in CmdEvtType.values) {
  //     if (element.name.startsWith('get')) {
  //       list.add(_TestCmd(cmd: element, name: element.name));
  //     }
  //   }
  //   return list;
  // }

  List<_TestCmd> createSetCmd() {
    final date = DateTime.now();
    //generateWordPairs().first.first
    return [
      /// 验证设置指令
      // _TestCmd(
      //     cmd: CmdEvtType.setDevicesName,
      //     name: '设置设备名称',
      //     json: {'dev_name': '😊中（）国😊'}),
      // _TestCmd(cmd: CmdEvtType.getDeviceName, name: '获取设备名称'),
      _TestCmd(cmd: CmdEvtType.setTime, name: '设置时间', json: {
        'year': date.year,
        'monuth': date.month,
        'day': date.day,
        'hour': date.hour,
        'minute': Random().nextInt(60),
        'second': date.second,
        'week': date.weekday,
        'time_zone': date.timeZoneOffset.inHours,
      }),
      // _TestCmd(cmd: CmdEvtType.setSchedulerReminderV3, name: '', json: {
      //   "items": [
      //     {
      //       "day": 21,
      //       "hour": 12,
      //       "id": 0,
      //       "min": 30,
      //       "mon": 12,
      //       "note": "please ....;.",
      //       "remind_on_off": 1,
      //       "repeat_type": 0,
      //       "sec": 0,
      //       "state": 2,
      //       "title": "test",
      //       "weekRepeat": [false, false, false, false, false, false, false],
      //       "year": 2022
      //     }
      //   ],
      //   "num": 1,
      //   "operate": 1,
      //   "version": 0
      // }),
      // _TestCmd(cmd: CmdEvtType.setMusicOperate, name: '', json: {"version":0,"music_operate":2,"folder_operate":0,"music_items":[{"music_id":1,"music_memory":4012232,"music_name":"祝你平安","singer_name":"孙悦"},{"music_id":2,"music_memory":4012232,"music_name":"祝你平安1","singer_name":"孙悦1"}],"folder_items":{}}),
      // _TestCmd(cmd: CmdEvtType.setHand, name: '设置左右手', json: {'hand': 1}),
      // _TestCmd(cmd: CmdEvtType.setV3Noise, name: '环境音量的开关和阀值', json: {"mode":170,"start_hour":0,"start_minute":0,"end_hour":23,"end_minute":59,"high_noise_on_off":85,"high_noise_value":0}),
    ];

    //_TestCmd(cmd: CmdEvtType.setMusicOperate, name: '', json: {"version":0,"music_operate":2,"folder_operate":0,"music_items":[{"music_id":1,"music_memory":4012232,"music_name":"祝你平安","singer_name":"孙悦"}],"folder_items":[{}]}),
    //{"version":0,"music_operate":2,"folder_operate":0,"music_items":{"music_id":1,"music_memory":4012232,"music_name":"祝你平安","singer_name":"孙悦"},"folder_items":{}}
  }

  tranFile() {
    Stream<List<bool>> exec(List<BaseFileModel> items) {
      final t = libManager.transFile.transferMultiple(
          fileItems: items,
          funcStatus: (index, FileTransStatus status) {
            debugPrint('状态： ${status.name}');
          },
          funcProgress: (int currentIndex, int totalCount,
              double currentProgress, double totalProgress) {
            debugPrint(
                '进度：${currentIndex + 1}/$totalCount $currentProgress $totalProgress');
          });
      _subscripTrans = t.listen((event) {
        debugPrint('传输结束 结果:${event.toString()}');
      });
      return t;
    }

    // 通讯录
    contact() async {
      final dir = await getApplicationDocumentsDirectory();
      final mlPath = '${dir.path}/files_trans/ml';
      final fileItems = [
        NormalFileModel(
            fileType: FileTransType.ml,
            filePath: '$mlPath/a.json',
            fileName: 'a'),
      ];
      exec(fileItems);
    }

    // mp3
    mp3() async {
      if (!libManager.funTable.getSupportV3BleMusic) {
        debugPrint('当前设备不支持');
        return;
      }

      final dir = await getApplicationDocumentsDirectory();
      final mp3Path = '${dir.path}/files_trans/mp3';

      doit(bool useSpp) {
        final fileItems = [
          MusicFileModel(
              filePath: '$mp3Path/1.mp3',
              musicId: 0,
              fileName: 'mp3_1',
              useSpp: useSpp),
          // MusicFileModel(
          //     filePath: '$mp3Path/3.mp3', musicId: 2, fileName: 'mp3_2'),
          MusicFileModel(
              filePath: '$mp3Path/1.mp3', musicId: 3, fileName: 'mp3_3'),
        ];
        exec(fileItems);
      }

      // 安卓添加spp传输
      if (Platform.isAndroid &&
          libManager.funTable.getBtVersion &&
          libManager.deviceInfo.macAddressBt != null) {
        bluetoothManager.stateSPP().listen((event) {
          if (event == IDOBluetoothSPPStateType.onSuccess) {
            libManager.send(evt: CmdEvtType.getMtuLengthSPP).listen((event) {
              doit(true);
            });
          }
        });
        bluetoothManager.writeSPPCompleteState().listen((event) {
          print('writeSPPCompleteState :$event');
          libManager.writeDataComplete();
        });
        bluetoothManager.connectSPP(libManager.deviceInfo.macAddressBt!);
      } else {
        doit(false);
      }
    }

    // 提示音
    ton() async {
      if (!libManager.funTable.getSupportGetBleBeepV3) {
        debugPrint('当前设备不支持');
        return;
      }

      final dir = await getApplicationDocumentsDirectory();
      final imgPath = '${dir.path}/files_trans/ton';
      /*bi-0.ton
    bo-1.ton
    bo-2.ton
    bobi-9.ton
    bolu-3.ton
    bu-4.ton
    di-5.ton
    ding-6.ton
    dingding-7.ton
    kacha-8.ton*/
      final fileItems = [
        NormalFileModel(
            fileType: FileTransType.ton,
            filePath: '$imgPath/bi-0.ton',
            fileName: 'bi-0.ton'),
      ];
      exec(fileItems).last.whenComplete(() {
        libManager.send(evt: CmdEvtType.getBleBeepV3);
      });
    }

    epo() async {
      if (!(libManager.funTable.setAirohaGpsChip ||
          libManager.funTable.getUbloxModel)) {
        debugPrint('当前设备不支持');
        return;
      }
      final dir = await getApplicationDocumentsDirectory();
      final imgPath = '${dir.path}/files_trans/epo';
      final fileItems = [
        NormalFileModel(
            fileType: FileTransType.epo,
            filePath: '$imgPath/epo.zip',
            fileName: 'EPO.DAT'),
      ];
      exec(fileItems);
    }

    epoDir() async {
      if (!(libManager.funTable.setAirohaGpsChip ||
          libManager.funTable.getUbloxModel)) {
        debugPrint('当前设备不支持');
        return;
      }
      final dir = await getApplicationDocumentsDirectory();
      final epoPath = '${dir.path}/files_trans/epo_dir';
      final epoFile = '${dir.path}/files_trans/aaa.DAT';
      final rs = await libManager.tools.makeEpoFile(dirPath: epoPath, epoFilePath: epoFile);
      debugPrint('制作epo文件：$rs path:$epoFile');
      final fileItems = [
        NormalFileModel(
            fileType: FileTransType.epo,
            filePath: epoFile,
            fileName: 'EPO.DAT'),
      ];
      exec(fileItems);
    }

    // 壁纸表盘
    wallpaper() async {
      final dir = await getApplicationDocumentsDirectory();
      final imgPath = '${dir.path}/files_trans/imgs';
      final fileItems = [
        NormalFileModel(
            fileType: FileTransType.wallpaper_z,
            filePath: '$imgPath/preview.png',
            fileName: 'wallpaper.z'),
      ];
      exec(fileItems);
    }

    // 云表盘
    dial() async {
      final dir = await getApplicationDocumentsDirectory();
      final imgPath = '${dir.path}/files_trans/dial';
      final fileItems = [
        NormalFileModel(
            fileType: FileTransType.iwf_lz,
            filePath: '$imgPath/w139.zip',
            fileName: 'w139'), //watch177.zip w292.zip
      ];
      exec(fileItems).listen((event) {
        debugPrint('云表盘传输结束');
        if (event.last) {
          // libManager.send(evt: CmdEvtType.getWatchFaceList).listen((event) {
          //
          // });
          //
          // Future.delayed(const Duration(seconds: 5), () {
          //   libManager.send(evt: CmdEvtType.setWatchFaceData, json: jsonEncode({
          //     'operate': 1,
          //     'file_name':items.first.fileName,
          //     'watch_file_size': 0,
          //   })).listen((event) {
          //
          //   });
          // });
        }
      });
    }

    // ID205G 设备支持该功能
    agps() async {
      // if (!libManager.funTable.setAgpsOnLine && !libManager.funTable.setAgpsOffLine) {
      //   debugPrint('当前设备不支持');
      //   return;
      // }
      if (!libManager.funTable.getUbloxModel) {
        debugPrint('当前设备不支持1');
        return;
      }

      final dir = await getApplicationDocumentsDirectory();
      final imgPath = '${dir.path}/files_trans/agps';
      exec([
        NormalFileModel(
            fileType: FileTransType.offline_ubx,
            filePath: '$imgPath/offLine.ubx', // mgaoffline.ubx
            fileName: 'offLine.ubx')
      ]);
    }

    language() async {
      if (libManager.funTable.getDownloadLanguage ||
          libManager.funTable.getLangLibraryV3) {
        final dir = await getApplicationDocumentsDirectory();
        final imgPath = '${dir.path}/files_trans/lang';
        //  lat.lang / jp.lang
        exec([
          NormalFileModel(
              fileType: FileTransType.lang,
              filePath: '$imgPath/jp.lang',
              fileName: 'jp.lang')
        ]).first.whenComplete(() {
          debugPrint('结束');
        });
      } else {
        debugPrint('当前设备不支持');
      }
    }

    fw() async {
      final dir = await getApplicationDocumentsDirectory();
      final imgPath = '${dir.path}/files_trans/fw';
      /*
      GT01_V51_DFU_2022052801.fw
      gt01p_b91_T2.10.7_DFU.bt ok
      GT01Pro_noise_DFU_V1.01.10_20220909.fw
      gt01pro_noise_ui_v17.fzbin  ok
      * */
      return exec([
        NormalFileModel(
            fileType: FileTransType.fw,
            filePath: '$imgPath/GT01Pro_noise_DFU_V1.01.10_20220909.fw',
            fileName: 'test')
      ]);
    }

    fzbin() async {
      final dir = await getApplicationDocumentsDirectory();
      final imgPath = '${dir.path}/files_trans/fw';
      return exec([
        NormalFileModel(
            fileType: FileTransType.fzbin,
            filePath: '$imgPath/gt01pro_noise_ui_v17.fzbin',
            fileName: 'test')
      ]);
    }

    // 运动图标
    sport() async {
      // if (!libManager.funTable.setSportMediumIcon && !libManager.funTable.setSupportSecondSportIcon) {
      if (!libManager.funTable.getNotifyIconAdaptive) {
        debugPrint('当前设备不支持');
        return;
      }
      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}/files_trans/imgs';
      // icon_sport1.bmp
      final fileItems = [
        SportFileModel(
            filePath: '$path/preview.png',
            fileName: 'icon_sport1',
            iconType: 3,
            sportType: 2,
            isSports: false),
        SportFileModel(
            filePath: '$path/preview.png',
            fileName: 'icon_sport2',
            iconType: 3,
            sportType: 2,
            isSports: false),
        SportFileModel(
            filePath: '$path/preview.png',
            fileName: 'icon_sport3',
            iconType: 3,
            sportType: 2,
            isSports: false),
        SportFileModel(
            filePath: '$path/preview.png',
            fileName: 'icon_sport4',
            iconType: 3,
            sportType: 2,
            isSports: false),
      ];
      exec(fileItems);
    }

    // 运动图标 动画
    sports() async {
      if (!libManager.funTable.getNotifyIconAdaptive) {
        debugPrint('当前设备不支持');
        return;
      }
      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}/files_trans/imgs';
      // icon_sport1.bmp
      final fileItems = [
        // SportFileModel(
        //     filePath: '$path/motion_48.bmp',
        //     fileName: 'icon_sports1',
        //     iconType: 3,
        //     sportType: 2,
        //     isSports: true),
        SportFileModel(
            filePath: '$path/motion_49.bmp',
            fileName: 'motion_49',
            iconType: 3,
            sportType: 2,
            isSports: true),
        // SportFileModel(
        //     filePath: '$path/motion_52.bmp',
        //     fileName: 'icon_sports3',
        //     iconType: 3,
        //     sportType: 2,
        //     isSports: true),
        // SportFileModel(
        //     filePath: '$path/motion_53.bmp',
        //     fileName: 'icon_sports4',
        //     iconType: 3,
        //     sportType: 2,
        //     isSports: true),
      ];
      exec(fileItems);
    }

    iwfSize() async {
      final dir = await getApplicationDocumentsDirectory();
      final dialPath = '${dir.path}/files_trans/dial';
      final imgPath = '${dir.path}/files_trans/imgs';
      final s1 = await libManager.transFile
          .iwfFileSize(filePath: '$dialPath/w139.zip', type: 1);
      final s2 = await libManager.transFile
          .iwfFileSize(filePath: '$imgPath/preview.png', type: 2);
      debugPrint('s1: $s1, s2: $s2');
    }

    allIn() async {
      final dir = await getApplicationDocumentsDirectory();
      final dialPath = '${dir.path}/files_trans/dial';
      final imgPath = '${dir.path}/files_trans/imgs';
      final mp3Path = '${dir.path}/files_trans/mp3';

      // 单文件
      // libManager.transFile.transferSingle(fileItem: MusicFileModel(
      //     filePath: '$mp3Path/3.mp3', musicId: 1, fileName: 'mp3_3'),
      //     funcStatus: (FileTransStatus status) {
      //   print('状态： ${status.name}');
      // },
      //     funcProgress: (double progress) {
      //       print('进度：$progress');
      //     });

      exec([
        // MusicFileModel(
        //     filePath: '$mp3Path/3.mp3', musicId: 1, fileName: 'mp3_3'),
        // NormalFileModel(
        //     fileType: FileTransType.wallpaper_z,
        //     filePath: '$imgPath/preview.png',
        //     fileName: 'wallpaper.z'),
        SportFileModel(
            filePath: '$imgPath/preview.png',
            fileName: 'icon_sport1',
            iconType: 2,
            sportType: 2,
            isSports: false),
        SportFileModel(
            filePath: '$imgPath/motion_49.bmp',
            fileName: 'motion_49',
            iconType: 3,
            sportType: 2,
            isSports: true),
        // MusicFileModel(
        //     filePath: '$mp3Path/3.mp3', musicId: 2, fileName: 'mp3_2'),
      ]);
    }

    // contact(); // 制作 ok, 上传 ok (208 / g01 pro)
    // wallpaper(); // 制作 ok, 上传ok
    // dial(); // 制作 ok，上传ok
    // language(); // 上传ok
    // fzbin();  // 上传ok
    fw(); // 上传ok
    // ton(); // 上传ok
    // agps(); //
    // epo(); // ID205G 上传ok ，安装 ok
    // sport(); // GT01 Pro 单图 制作ok， 上传ok
    // sports(); // GT01 Pro 单图 制作ok， 上传ok
    // mp3(); // 制作 ok，上传ok
    // iwfSize();
    // epoDir();
    // allIn();
  }
}

class _TestCmd {
  final CmdEvtType cmd;
  Map<String, dynamic>? json;
  final String name;
  _TestCmd({required this.cmd, required this.name, this.json});
}
