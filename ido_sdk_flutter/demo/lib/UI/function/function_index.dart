// 功能列表首页

import 'dart:async';
import 'dart:io';

import 'package:demo/UI/function/control/function_sync.dart';
import 'package:demo/utility/bind_state_storage.dart';
import 'package:demo/utility/connection_status_controller.dart';
import 'package:flutter/material.dart';
import '../alexa/home_page.dart';
import '../common/Toast.dart';
import 'function_general.dart';
import '../../generated/l10n.dart';
import 'package:flutter_bluetooth/ido_bluetooth.dart';
import 'package:protocol_lib/protocol_lib.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:share_plus/share_plus.dart';
import '../detail/photo_dial/photo_dial_test_page.dart';

typedef _Fn = void Function();

class FunctionIndex extends StatelessWidget {
  final IDOBluetoothDeviceModel device;

  FunctionIndex(this.device, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.functionlist),
      ),
      body: Column(
        children: [
          const ConnectionStatusBanner(showBindChip: true),
          Expanded(child: FunctionContent(device: device)),
        ],
      ),
    );
  }
}

class FunctionContent extends StatefulWidget {
  final IDOBluetoothDeviceModel device;

  const FunctionContent({super.key, required this.device});

  @override
  State<StatefulWidget> createState() => _FunctionContentState();
}

class _FunctionContentState extends State<FunctionContent> {
  final listNames = [
    S.current.deviceConnect,
    S.current.deviceDisconnect,
    S.current.deviceBind,
    S.current.deviceunbind,
    S.current.setfunction,
    S.current.getfunction,
    S.current.syncfunction,
    S.current.alexa,
    '照片表盘',
    '分享 SDK 日志',
  ];

  final typeMap = {
    S.current.deviceunbind: [
      S.current.deviceunbind,
      S.current.deviceswitch,
      S.current.unbindDeviceData
    ],
    S.current.setfunction: [
      S.current.setuserinfo,
      S.current.settargetinfo,
      S.current.setfindphone,
      S.current.sethandupidentify,
      S.current.setleftrighthand,
      S.current.setpreventlost,
      S.current.setdisplaymode,
      S.current.setsmartnotfity,
      S.current.setcurrenttime,
      S.current.factoryreset,
      S.current.rebootdevice
    ],
    S.current.getfunction: [
      S.current.getfunctionlist,
      S.current.getMacaddress,
      S.current.getdeviceinformation,
      S.current.getRealTimeData,
      S.current.getthenumberofactivities,
      S.current.getGPSinformation,
      S.current.getPressureThresholdinformation,
      S.current.getnotificationstatus,
      S.current.getversioninformation,
      S.current.getthenumberofstars,
      S.current.getotaauthinformation,
      S.current.getflashinfo,
      S.current.getbatteryinfo,
      S.current.getdefaultlanguage,
      S.current.getmenulist,
      S.current.getdefaultsporttype,
      S.current.geterrorlogstate,
      S.current.getv3alarmsinfo,
      S.current.getv3heartratemode,
      S.current.getbluemtuinfo,
      S.current.getoverheatlog,
      S.current.getdevicebatterylog,
      S.current.getnotdisturbmode,
      S.current.getencryptedcode,
      S.current.gettargetinfo,
      S.current.getwalkreminder,
      S.current.gethealthswitchstate,
      S.current.getmainuisort,
      S.current.getschedulereminder,
      S.current.getV3notificationstatus,
      S.current.getsportsort,
      S.current.obtainTheLevel3VersionNumber
    ],
    S.current.syncfunction: [S.current.alldatasync],
    S.current.deviceupdate: [
      S.current.nordicupdate,
      S.current.realtkupdate,
      S.current.apolloupdate,
      S.current.wordupdate,
      S.current.agpsupdate,
      S.current.fileupdate,
      S.current.contactupdate,
      S.current.photoupdate,
      S.current.updateMessageIcon,
      S.current.updatesporticon,
    ],
  };

  bool isBinded = false;
  bool isConnected = false;
  StreamSubscription? _streamSubscriptionBleState;
  StreamSubscription? _streamSubscriptionLibStatus;
  bool _autoConnectStarted = false;

  IDOBluetoothDeviceModel get device => widget.device;

  @override
  void dispose() {
    debugPrint("FunctionIndex page dispose (keep connection)");
    _streamSubscriptionBleState?.cancel();
    _streamSubscriptionLibStatus?.cancel();
    // 不在离开页面时断连，断连仅由用户显式触发
    EasyLoading.dismiss();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    bluetoothManager.setBindStateAsyncDelegate(
        (macAddress) async => BindStateStorage.load(macAddress));

    bluetoothManager.setAutoConnectInterceptor((macAddress) async {
      final isInOta = await libManager.checkSiceOtaDoing();
      debugPrint("checkSiceOtaDoing  $isInOta");
      return isInOta;
    });

    _initBindStateAndMaybeAutoConnect();

    _streamSubscriptionBleState =
        bluetoothManager.deviceState().listen((event) async {
      print('ble deviceState:${event.state.toString()}');

      if (event.errorState == IDOBluetoothDeviceConnectErrorType.pairFail) {
        if (Platform.isIOS) {
          libManager.cache.writeLog(
              "配对异常，需要手动忽略设备（设置-蓝牙-找到设备-\"!\")-忽略此设备");
          Toast.toast(context,
              msg: "配对异常，需要手动忽略设备（设置-蓝牙-找到设备-\"!\")-忽略此设备",
              showTime: 3 * 1000);
        }
      }

      if ((event.state == IDOBluetoothDeviceStateType.connected &&
          event.macAddress != null &&
          event.macAddress!.isNotEmpty)) {
        final current = bluetoothManager.currentDevice!;
        var uniqueId = event.macAddress!;
        if (Platform.isIOS && bluetoothManager.currentDevice?.uuid != null) {
          uniqueId = bluetoothManager.currentDevice!.uuid!;
        }
        final otaType = current.isTlwOta
            ? IDOOtaType.telink
            : current.isOta
                ? IDOOtaType.nordic
                : IDOOtaType.none;
        final binded = await BindStateStorage.load(event.macAddress!);
        isBinded = binded;
        ConnectionStatusController.instance.setBindedHint(binded);
        // 先关掉「正在连接」；markConnected 内部若已绑定会同步发出
        // fastSyncStarting 并弹出「快速配置中」，此处不可在 await 后再 dismiss，否则会冲掉弹窗
        EasyLoading.dismiss();
        await libManager.markConnectedDeviceSafe(
            uniqueId: uniqueId, otaType: otaType, isBinded: binded);
        isConnected = libManager.isConnected;
      } else if (event.state == IDOBluetoothDeviceStateType.disconnected) {
        await libManager.markDisconnectedDevice();
        isConnected = libManager.isConnected;
        EasyLoading.dismiss();
      }

      print(event.toJson());
      if (event.errorState ==
              IDOBluetoothDeviceConnectErrorType
                  .deviceAlreadyBindAndNotSupportRebind ||
          event.errorState ==
              IDOBluetoothDeviceConnectErrorType.deviceHasBeenReset) {
        final msg = event.errorState ==
                IDOBluetoothDeviceConnectErrorType.deviceHasBeenReset
            ? "设备已重置，可以删除设备"
            : "设备已绑定，不支持重复绑定";
        debugPrint(msg);
        Toast.toast(context, msg: msg, showTime: 2500);
      }

      _updateInformation();
    });

    _streamSubscriptionLibStatus =
        libManager.listenStatusNotification((status) async {
      print("sdk状态变更：$status ");
      if (status == IDOStatusNotification.fastSyncStarting) {
        EasyLoading.show(
            status: "执行快速配置中...", maskType: EasyLoadingMaskType.black);
      } else if (status == IDOStatusNotification.fastSyncCompleted) {
        EasyLoading.showSuccess("快速配置完成");
        // 快速配置完成后补齐设备快照（名称等可能已更新）
        final current = bluetoothManager.currentDevice;
        if (isBinded && current?.macAddress != null) {
          await BindStateStorage.upsert(current!, isBinded: true);
        }
      } else if(status == IDOStatusNotification.fastSyncFailed) {
        EasyLoading.showError("快速配置失败");
      } else if (status == IDOStatusNotification.unbindOnBindStateError) {
        await _handleBindStateMismatch(
          title: '绑定状态错误',
          message: '本地绑定状态与设备不一致（设备可能已重置），将清除本地绑定记录。',
        );
      } else if (status == IDOStatusNotification.unbindOnAuthCodeError) {
        await _handleBindStateMismatch(
          title: '绑定授权码异常',
          message: '该设备已重置并被别处绑定，需清除本地绑定状态。',
        );
      }
    });
  }

  /// 绑定态异常：先模态提示，点「确定」后再清除本地绑定并强制解绑
  Future<void> _handleBindStateMismatch({
    required String title,
    required String message,
  }) async {
    EasyLoading.dismiss();
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    final mac = bluetoothManager.currentDevice?.macAddress ?? device.macAddress;
    if (mac != null && mac.isNotEmpty) {
      debugPrint('绑定状态异常需解绑: $title mac=$mac');
      await BindStateStorage.remove(mac);
      isBinded = false;
      ConnectionStatusController.instance.setBindedHint(false);
      _updateInformation();
      libManager.deviceBind.unbind(macAddress: mac, isForceRemove: true);
    }
  }

  Future<void> _initBindStateAndMaybeAutoConnect() async {
    final mac = device.macAddress;
    if (mac != null && mac.isNotEmpty) {
      isBinded = await BindStateStorage.load(mac);
    }
    ConnectionStatusController.instance.setBindedHint(isBinded);
    isConnected = libManager.isConnected &&
        (bluetoothManager.currentDevice?.macAddress == device.macAddress);
    if (mounted) setState(() {});

    // 已绑定且未连接：进入功能页自动回连
    if (isBinded && !isConnected && !_autoConnectStarted) {
      _autoConnectStarted = true;
      EasyLoading.show(status: '正在连接…');
      bluetoothManager.autoConnect(device: device);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext ctx, int index) {
        final fName = listNames[index];
        return ElevatedButton(
            onPressed: jumpFuntionViewCon(context, fName),
            child: Column(
              children: [
                Text(
                  fName,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ));
      },
      itemCount: listNames.length,
    );
  }

  void _updateInformation() {
    ConnectionStatusController.instance.setBindedHint(isBinded);
    if (mounted) setState(() {});
  }

  Future<void> _persistBoundDevice() async {
    final current = bluetoothManager.currentDevice ?? device;
    // 优先用当前连接设备的字段，名称可回退到入口 device
    if ((current.name == null || current.name!.isEmpty) &&
        (device.name?.isNotEmpty ?? false)) {
      current.name = device.name;
    }
    await BindStateStorage.upsert(current, isBinded: true);
  }

  bind() {
    EasyLoading.show();
    libManager.deviceBind
        .startBind(
            osVersion: 15,
            deviceInfo: (d) {},
            functionTable: (f) {})
        .listen((event) async {
      EasyLoading.dismiss();
      switch (event) {
        case BindStatus.failed:
          debugPrint('绑定失败');
          EasyLoading.showError(S.current.bindfailed);
          isBinded = false;
          break;
        case BindStatus.successful:
          debugPrint('绑定成功');
          isBinded = true;
          await _persistBoundDevice();
          EasyLoading.showSuccess(S.current.bindsuccess);
          break;
        case BindStatus.binded:
          debugPrint('该设备已绑定');
          isBinded = true;
          await _persistBoundDevice();
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
        case BindStatus.timeout:
        case BindStatus.agreeDeleteDeviceData:
        case BindStatus.denyDeleteDeviceData:
        case BindStatus.timeoutOnNewAccount:
        case BindStatus.needConfirmByApp:
        case BindStatus.accountNotMatch:
          break;
      }
      _updateInformation();
    });
  }

  unbind() {
    EasyLoading.show();
    final full = libManager.macAddressFull;
    final short = libManager.macAddress;
    final deviceMac = device.macAddress;
    final String mac = (full != null && full.isNotEmpty)
        ? full
        : (deviceMac != null && deviceMac.isNotEmpty)
            ? deviceMac
            : (short ?? '');
    libManager.deviceBind.unbind(macAddress: mac).then((res) async {
      debugPrint(res ? '解绑成功' : '解绑失败，请重试');
      EasyLoading.showSuccess(
          res ? S.current.unbindsuccess : S.current.unbindfailed);
      if (res) {
        isBinded = false;
        if (mac.isNotEmpty) {
          await BindStateStorage.remove(mac);
        }
        // 兼容历史 key 可能用不同 mac 格式
        if (deviceMac != null && deviceMac.isNotEmpty && deviceMac != mac) {
          await BindStateStorage.remove(deviceMac);
        }
        if (short != null && short.isNotEmpty && short != mac && short != deviceMac) {
          await BindStateStorage.remove(short);
        }
        _updateInformation();
      }
    });
  }

  /// 导出协议库 + 蓝牙库日志并分享到第三方应用
  shareSDKLog() async {
    EasyLoading.show(status: '导出日志…');
    try {
      final path = await libManager.cache.exportLog();
      final bleLogPath = await bluetoothManager.logPath();
      EasyLoading.dismiss();

      final files = <XFile>[];
      if (path != null && path.isNotEmpty) {
        files.add(XFile(path));
      }
      if (bleLogPath != null && bleLogPath.isNotEmpty) {
        files.add(XFile(bleLogPath));
      }
      if (files.isEmpty) {
        EasyLoading.showError('导出日志失败');
        return;
      }

      final params = ShareParams(
        text: '分享 SDK / 蓝牙日志',
        files: files,
      );
      final result = await SharePlus.instance.share(params);
      if (result.status == ShareResultStatus.success) {
        debugPrint('shareSDKLog success protocol=$path ble=$bleLogPath');
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('分享日志失败: $e');
      debugPrint('shareSDKLog error: $e');
    }
  }

  void _connectDevice() {
    EasyLoading.show(status: '正在连接…');
    if (isBinded) {
      bluetoothManager.autoConnect(device: device);
    } else {
      bluetoothManager.connect(device);
    }
  }

  _Fn? jumpFuntionViewCon(BuildContext context, String title) {
    if (title == S.current.deviceConnect) {
      return !isConnected ? _connectDevice : null;
    } else if (title == S.current.deviceDisconnect) {
      return isConnected
          ? () {
              bluetoothManager.cancelConnect();
            }
          : null;
    } else if (title == S.current.deviceBind) {
      return isConnected && !isBinded
          ? () {
              bind();
            }
          : null;
    } else if (title == S.current.deviceunbind) {
      return isConnected && isBinded
          ? () {
              unbind();
            }
          : null;
    } else if (title == S.current.alexa) {
      return isConnected && isBinded
          ? () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const AlexaTestHomePage(title: 'Alexa', did: 1)));
            }
          : null;
    } else if (title == S.current.syncfunction) {
      return isConnected && isBinded
          ? () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          FunctionSync(navTitle: S.current.syncfunction)));
            }
          : null;
    } else if (title == '照片表盘') {
      return isConnected && isBinded
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PhotoDialTestPage()),
              );
            }
          : null;
    } else if (title == '分享 SDK 日志') {
      return isConnected && isBinded
          ? () {
              shareSDKLog();
            }
          : null;
    }

    return isConnected && isBinded
        ? () {
            List<String>? unbindNames = typeMap[title];
            if (unbindNames != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FunctionGeneral(
                            listNames: unbindNames,
                            navTitle: title,
                          )));
            }
          }
        : null;
  }
}
