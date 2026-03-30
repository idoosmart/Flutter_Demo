// 重启设备

import 'package:flutter/material.dart';
import 'package:protocol_lib/protocol_lib.dart';

import '../../../generated/l10n.dart';
import '../../common/Toast.dart';
import '../../common/common.dart';

class RebootDeviceSet extends StatelessWidget {
  final String navTitle;

  const RebootDeviceSet({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),
      body: const RebootDeviceContent(),
    );
  }
}

class RebootDeviceContent extends StatefulWidget {
  const RebootDeviceContent({super.key});

  @override
  State<RebootDeviceContent> createState() => _RebootDeviceContentState();
}

class _RebootDeviceContentState extends State<RebootDeviceContent> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (BuildContext ctx, int index) {
        return _createCell(index);
      },
      itemCount: 3,
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          color: Colors.blue,
        );
      },
    );
  }

  Widget _createCell(int index) {
    if (index == 0) {
      return commonUI.productionWidget(WidType.headTextInfo, [], (o) {});
    }
    if (index == 1) {
      return commonUI.productionWidget(
          WidType.textSingleShow, [S.current.rebootdevice], (o) {});
    }
    return commonUI.productionWidget(
      WidType.buttonInfo,
      [S.current.rebootdevice],
      (o) {
        _sendReboot();
      },
    );
  }

  void _sendReboot() {
    libManager.send(evt: CmdEvtType.reboot).listen((res) {
      debugPrint(
          '${S.current.rebootdevice} ${CmdEvtType.reboot.evtType} 返回 code: ${res.code} json: ${res.json ?? 'NULL'}');

      if (!mounted) return;

      if (res.code == 0) {
        Toast.toast(context, msg: S.current.successfulrestartofequipment);
      } else {
        Toast.toast(context, msg: S.current.failuretorestartequipment);
      }
    });
  }
}
