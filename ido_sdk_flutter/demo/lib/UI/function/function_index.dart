// 功能列表首页

import 'dart:async';

import 'package:demo/UI/function/control/function_sync.dart';
import 'package:flutter/material.dart';
import '../alexa/home_page.dart';
import 'function_general.dart';
import '../../generated/l10n.dart';
import 'package:flutter_bluetooth/ido_bluetooth.dart';
import 'package:protocol_lib/protocol_lib.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

typedef _Fn = void Function();

class FunctionIndex extends StatelessWidget {
  IDOBluetoothDeviceModel device;
  // DeviceDetailPage(this.device, {Key? key}) : super(key: key);

  FunctionIndex(this.device, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //print( '${S.current.setup}');

    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.functionlist),
      ),
      body: FunctionContent(),
    );
  }
}

class FunctionContent extends StatefulWidget {
  FunctionContent({super.key});

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
    S.current.alexa
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

  String deviceConnectState =
      IDOBluetoothDeviceStateType.disconnected.toString();

  bool isBinded = false;
  bool isConnected = false;
  StreamSubscription? _streamSubscriptionBleState;
  StreamSubscription? _streamSubscriptionLibStatus;

  @override
  void dispose() {
    debugPrint("page disponse");
    _streamSubscriptionBleState?.cancel();
    _streamSubscriptionLibStatus?.cancel();
    bluetoothManager.cancelConnect();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    _streamSubscriptionBleState = bluetoothManager.deviceState().listen((event) async {
      print('ble deviceState:${event.state.toString()}');
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
        await libManager.markConnectedDeviceSafe(
            uniqueId: device.uuid ?? event.macAddress!,
            otaType: otaType,
            isBinded: isBinded);
        isConnected = libManager.isConnected;
        EasyLoading.dismiss();
        // debugPrint('end markConnectedDevice');
      } else if (event.state == IDOBluetoothDeviceStateType.disconnected) {
        // debugPrint('begin markDisconnectedDevice');
        await libManager.markDisconnectedDevice();
        isConnected = libManager.isConnected;
        EasyLoading.dismiss();
        // debugPrint('end markDisconnectedDevice');
      }

      print(event.toJson());
      deviceConnectState = event.state.toString();
      _updateInformation();
    });

    _streamSubscriptionLibStatus = libManager.listenStatusNotification((status) async {
      if (status == IDOStatusNotification.fastSyncCompleted) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext ctx, int index) {
        if (index == 0) {
          return SizedBox(height: 55,
              child: Text(
            deviceConnectState,
            style: const TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ));
        } else {
          final fName = listNames[index - 1];
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
        }
      },
      itemCount: listNames.length + 1,
      // itemExtent: 70,
    );
  }

  void _updateInformation() {
    setState(() { });
  }

  bind() {
    EasyLoading.show();
    libManager.deviceBind
        .startBind(
            osVersion: 15,
            deviceInfo: (d) {
              //debugPrint('设备信息：$d');
            },
            functionTable: (f) {})
        .listen((event) {
      EasyLoading.dismiss();
      switch (event) {
        case BindStatus.failed:
          debugPrint('绑定失败');
          EasyLoading.showError(S.current.bindfailed);
          isBinded = true;
          break;
        case BindStatus.successful:
          debugPrint('绑定成功');
          isBinded = true;
          EasyLoading.showSuccess(S.current.bindsuccess);
          break;
        case BindStatus.binded:
          debugPrint('该设备已绑定');
          isBinded = true;
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
      _updateInformation();
    });
  }

  unbind() {
    EasyLoading.show();
    libManager.deviceBind.unbind(macAddress: libManager.macAddress).then((res) {
      debugPrint(res ? '解绑成功' : '解绑失败，请重试');
      EasyLoading.showSuccess(
          res ? S.current.unbindsuccess : S.current.unbindfailed);
      if (res) {
        isBinded = false;
        _updateInformation();
      }
    });
  }

  _Fn? jumpFuntionViewCon(BuildContext context, String title) {
    print('jumpFuntionViewCon==$title');

    final device =
        context.findAncestorWidgetOfExactType<FunctionIndex>()?.device;
    if (title == S.current.deviceConnect) {
      // 连接
      return !isConnected ? () {
        EasyLoading.show();
        bluetoothManager.connect(device);
      } : null;
    } else if (title == S.current.deviceDisconnect) {
      return isConnected ? () {
        bluetoothManager.cancelConnect();
      } : null;
    } else if (title == S.current.deviceBind) {
      return isConnected && !isBinded ? () {
        bind();
      } : null;
    } else if (title == S.current.deviceunbind) {
      return isConnected && isBinded ? () {
        unbind();
      } : null;
    } else if (title == S.current.alexa) {
      // alexa
      return isConnected && isBinded ? () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                const AlexaTestHomePage(title: 'Alexa', did: 1)));
      } : null;
    }else if (title == S.current.syncfunction) {
      // sync data
      return isConnected && isBinded ? () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                FunctionSync(navTitle: S.current.syncfunction)));
      } : null;
    }

    return isConnected && isBinded ? () {
      List<String>? unbindNames = typeMap[title];
      if (unbindNames != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FunctionGeneral(
                  listNames: unbindNames!,
                  navTitle: title,
                )));
      }
    } : null;
  }
}
