// 设置启动参数
// 设置表盘参数

import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';
import '../../common/common.dart';
import 'information_set_model.dart';
import '../../common/commonTool.dart';
import '../../common/Toast.dart';
import 'package:protocol_lib/protocol_lib.dart';
import 'dart:convert';


typedef OnSelect = void Function(Object o);


class HotStartInfo extends StatelessWidget {
  final String navTitle;


  HotStartInfo({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),
      body: const HotStartInfoContent(),
    );
  }
}


class HotStartInfoContent extends StatefulWidget {
  const HotStartInfoContent({Key? key}) : super(key: key);

  @override
  State<HotStartInfoContent> createState() => HotStartInfoContentState();
}




class HotStartInfoContentState extends State<HotStartInfoContent> {

  HotStartInfoSetModel _hotStartInfoModel =  HotStartInfoSetModel();


  List<String> leftList = [S.current.connected,S.current.crystaloscillationoffset,
                            S.current.longitude, S.current.latitude,
                            S.current.height, S.current.sethotstartinformation,];






  void _updateInformation() {
    setState(() {

      //_counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (BuildContext ctx, int index) {
        return createCell(index);
      },

      itemCount: leftList.length,
      //分割器构造器
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          color: Colors.blue,
        );
      },
    );
  }



  Widget createCell(int tInt) {
    if (tInt == 0) {
      return commonUI.productionWidget(WidType.headTextInfo , [], (o) { });
    }
    else if (tInt == leftList.length - 1) {
      return commonUI.productionWidget(WidType.buttonInfo, [leftList[tInt]], (o) {
        TestCmd e = TestCmd(cmd: CmdEvtType.setHotStartParam, name: o.toString(), json: _hotStartInfoModel.toMap()   );
        libManager
            .send(evt: e.cmd, json: jsonEncode(e.json ?? {}))
            .listen((res) {
          debugPrint(
              '${e.name} ${e.cmd.evtType} 返回 code: ${res.code} json: ${res.json ?? 'NULL'}');

          if (res.code == 0) {

            //默认是显示在中间的
            Toast.toast(context,msg: "设置成功");

          }
          else{

            //默认是显示在中间的
            Toast.toast(context,msg: "设置失败");
          }

        });

      });
    }
    else  {
      List<String> dataList = [_hotStartInfoModel.crystalOscillationOffset.toString(),
                              _hotStartInfoModel.longitude.toString(),
                              _hotStartInfoModel.latitude.toString(),
                              _hotStartInfoModel.height.toString()];

      return commonUI.productionWidget(WidType.textTextField, [leftList[tInt],dataList[tInt - 1]], (o) {
        print('object=====${o.toString()}');
        if (leftList[tInt] == S.current.crystaloscillationoffset) {
          _hotStartInfoModel.crystalOscillationOffset = int.parse(o.toString());
        }
        else if (leftList[tInt] == S.current.longitude) {
          _hotStartInfoModel.longitude = int.parse(o.toString());
        }
        else if (leftList[tInt] == S.current.latitude) {
          _hotStartInfoModel.latitude = int.parse(o.toString());
        }
        else if (leftList[tInt] == S.current.height) {
          _hotStartInfoModel.height = int.parse(o.toString());
        }

      });
    }

    return const Text('test');
  }






}





