// 恢复出厂

import 'package:flutter/material.dart';
import 'package:protocol_lib/protocol_lib.dart';

import '../../../generated/l10n.dart';
import '../../common/Toast.dart';
import '../../common/common.dart';

class FactoryResetSet extends StatelessWidget {
  final String navTitle;

  const FactoryResetSet({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),
      body: const FactoryResetContent(),
    );
  }
}

class FactoryResetContent extends StatefulWidget {
  const FactoryResetContent({super.key});

  @override
  State<FactoryResetContent> createState() => _FactoryResetContentState();
}

class _FactoryResetContentState extends State<FactoryResetContent> {
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
          WidType.textSingleShow, [S.current.factoryreset], (o) {});
    }
    return commonUI.productionWidget(
      WidType.buttonInfo,
      [S.current.factoryreset],
      (o) {
        _sendFactoryReset();
      },
    );
  }

  void _sendFactoryReset() {
    libManager.send(evt: CmdEvtType.factoryReset).listen((res) {
      debugPrint(
          '${S.current.factoryreset} ${CmdEvtType.factoryReset.evtType} 返回 code: ${res.code} json: ${res.json ?? 'NULL'}');

      if (!mounted) return;

      if (res.code == 0) {
        Toast.toast(context, msg: S.current.factoryresetsuccessfully);
      } else {
        Toast.toast(context, msg: S.current.factoryresetfailed);
      }
    });
  }
}
