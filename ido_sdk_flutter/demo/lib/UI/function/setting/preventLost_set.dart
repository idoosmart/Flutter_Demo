// 设置丢失提醒
// 设置显示模式
// 设置快捷方式


import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';
import '../../common/common.dart';
import '../../common/commonTool.dart';
import '../../common/Toast.dart';
import 'package:protocol_lib/protocol_lib.dart';
import 'dart:convert';

// 一些基础数据
Map<String,List<String>> pMap = {S.current.setpreventlost:[S.current.nopreventlost,
                                                          S.current.nearpreventlost,
                                                          S.current.middistancepreventlost,
                                                          S.current.fardistancepreventlost],

                                 S.current.setdisplaymode:[S.current.defaultmode,
                                                          S.current.crossscreen,
                                                           S.current.verticalscreen,
                                                           S.current.rotate180degrees,],
                                S.current.setshortcutmode:[S.current.invalid,
                                                            S.current.fastintothephotocontrol,
                                                            S.current.fastintosportmode,
                                                            S.current.fastintonodisturbmode,]
                                };

Map<String,String> sureMap = {S.current.setpreventlost:S.current.setpreventlostbutton,
                              S.current.setdisplaymode:S.current.setdisplaymode,
                              S.current.setshortcutmode:S.current.setshortcutmode,
                              };
// 选中的字段
String checkStr = '';
// 底部确定button的字段
String sureStr = '';

List<String> singleList = [];


class PreventLostSet extends StatelessWidget {
  final String navTitle;


  const PreventLostSet({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {

    singleList = pMap[navTitle]!;
    checkStr = singleList[0];
    sureStr = sureMap[navTitle]!;

    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),
      body: const PreventLostContent(),
    );
  }
}


class PreventLostContent extends StatefulWidget {
  const PreventLostContent({Key? key}) : super(key: key);

  @override
  State<PreventLostContent> createState() => _PreventLostContentState();
}

class _PreventLostContentState extends State<PreventLostContent> {

  Map<String,dynamic> jsonMap = {};

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

      itemCount: 6,
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

    else if (tInt == singleList.length + 1) {
      return commonUI.productionWidget(WidType.buttonInfo, [sureStr], (o) {
        
        executeCmd(o.toString());
        
      });
    }
    else {
      bool pt = false;
      if (singleList[tInt - 1] == checkStr) {
        pt = true;
      }
      return commonUI.productionWidget(WidType.textSingle, [singleList[tInt - 1],pt],
              (o) {
                checkStr = singleList[tInt - 1];
                _updateInformation();
              });
    }





    return const Text('test');
  }
  
  
// 执行相关的指令  
executeCmd(String typeStr) {
  int chIndex = singleList.indexOf(checkStr);
  jsonMap['mode'] = chIndex;
  print('-------executeCmd=$jsonMap');
  if (typeStr == S.current.setpreventlostbutton) {   // 设置丢失提醒

    TestCmd e = TestCmd(cmd: CmdEvtType.setLostFind, name: typeStr, json: jsonMap   );
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

  }
  else if (typeStr == S.current.setdisplaymode ) {   // 设置显示模式

    TestCmd e = TestCmd(cmd: CmdEvtType.setDisplayMode, name: typeStr, json: jsonMap   );
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
  }
  else if (typeStr == S.current.setshortcutmode ) {   // 设置快捷方式

    TestCmd e = TestCmd(cmd: CmdEvtType.setShortcut, name: typeStr, json: jsonMap   );
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
  }


}
  
  

}





