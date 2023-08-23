// 主界面控件排序


import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';
import '../../common/common.dart';
import '../../common/commonTool.dart';
import '../../common/Toast.dart';
import 'package:protocol_lib/protocol_lib.dart';
import 'dart:convert';


class MainUISortSet extends StatelessWidget {
  final String navTitle;

  const MainUISortSet({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),
      body: const MainUISortSetContent(),
    );
  }
}


class MainUISortSetContent extends StatefulWidget {
  const MainUISortSetContent({Key? key}) : super(key: key);

  @override
  State<MainUISortSetContent> createState() => _MainUISortSetContentState();
}

class _MainUISortSetContentState extends State<MainUISortSetContent> {

  List<String> leftList = [S.current.connected,S.current.mainUISort];

  void _updateInformation() {
    setState(() {

      //_counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (BuildContext ctx, int index) {
        return createCell(index,context);
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




  Widget createCell(int tInt ,BuildContext context) {
    if (tInt == 0) {
      return commonUI.productionWidget(WidType.headTextInfo , [], (o) { });
    }

    else if (tInt == 1) {
      // 非法数据
      return commonUI.productionWidget(WidType.buttonInfo, [leftList[tInt]],
              (o) {

                Map<String,dynamic> jsonMap = {
                  "version":0,
                  "operate":2,
                  "all_num":3,
                  "items":[
                    1,
                    2,
                    3
                  ],
                  "location_x":1,
                  "location_y":1,
                  "size_type":2,
                  "widgets_type":1
                };

                TestCmd e = TestCmd(cmd: CmdEvtType.setMainUISortV3, name: o.toString(), json: jsonMap   );
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




    return const Text('test');
  }

}





