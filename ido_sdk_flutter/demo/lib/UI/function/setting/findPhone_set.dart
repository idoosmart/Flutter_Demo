// 设置寻找手机
// 设置左右手穿戴
// 设置v2天气预报
// 设置音乐开关


import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';
import '../../common/common.dart';
import '../../common/commonTool.dart';
import '../../common/Toast.dart';
import 'package:protocol_lib/protocol_lib.dart';
import 'dart:convert';


Map<String,List<String>> paraMap =
{ S.current.setfindphone:[S.current.connected,S.current.setfindphone,S.current.setfindphone],
  S.current.setleftrighthand:[S.current.connected,S.current.setleftrighthandswitch,S.current.setleftrighthandbutton],
  S.current.setweatherforecast:[S.current.connected,S.current.setweatherforecastswitch,S.current.setweatherforecastbutton],
  S.current.setonekeysos:[S.current.connected,S.current.onekeysosswitch,S.current.setonekeysosswitch],
  S.current.setmusicopenoff:[S.current.connected,S.current.setmusicopenoff,S.current.setmusicopenoff,S.current.musiccontrol],


};

List<String> paList = paraMap[S.current.setfindphone]!;


class FindPhoneSet extends StatelessWidget {
  final String navTitle;


  const FindPhoneSet({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {

    paList = paraMap[navTitle]!;

    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),
      body: const FindPhoneContent(),
    );
  }
}


class FindPhoneContent extends StatefulWidget {
  const FindPhoneContent({Key? key}) : super(key: key);

  @override
  State<FindPhoneContent> createState() => _FindPhoneContentState();
}

class _FindPhoneContentState extends State<FindPhoneContent> {

  Map<String,dynamic> jsonMap = {
  };


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

      itemCount: paList.length,
      //分割器构造器
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          color: Colors.blue,
        );
      },
    );
  }


  bool swFlag = true;
  Widget createCell(int tInt) {
    if (tInt == 0) {
      return commonUI.productionWidget(WidType.headTextInfo , [], (o) { });
    }
    else if (tInt == 1) {
      return commonUI.productionWidget(WidType.textSwitch, [paList[tInt],swFlag.toString()], (o) {
        String sValue = o.toString();
        sValue == 'true'?swFlag = true:swFlag = false;
        if (sValue == 'true') {
          swFlag = true;
        }
        else{
          swFlag = false;
        }

        _updateInformation();

      });
    }
    else {
      return commonUI.productionWidget(WidType.buttonInfo, [paList[tInt]],
              (o) {
        print('object=====$o');
        if (o.toString() == S.current.setfindphone) {   // 设置寻找手机
          print('object=====$jsonMap');

          swFlag?jsonMap['on_off'] = 0xAA:jsonMap['on_off'] = 0x55;

          TestCmd e = TestCmd(cmd: CmdEvtType.setFindPhone, name: o.toString(), json: jsonMap   );
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
        else if (o.toString() == S.current.setleftrighthandbutton){  // 设置左右手穿戴
          swFlag?jsonMap['hand'] = 1:jsonMap['hand'] = 0;
          print('=======${o.toString()}');
          TestCmd e = TestCmd(cmd: CmdEvtType.setHand, name: o.toString(), json: jsonMap   );
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
        else if (o.toString() == S.current.setweatherforecastbutton) {   // 设置v2天气开关
          swFlag?jsonMap['on_off'] = 1:jsonMap['on_off'] = 0;
          print('=======${o.toString()}');
          TestCmd e = TestCmd(cmd: CmdEvtType.setWeatherSwitch, name: o.toString(), json: jsonMap   );
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
        else if (o.toString() == S.current.setonekeysosswitch) {   // 设置一键呼叫
          swFlag?jsonMap['on_off'] = 1:jsonMap['on_off'] = 0;
          if (swFlag) {
            jsonMap['on_off'] = 170;
            jsonMap['phone_type'] = 0;
          } else {
            jsonMap['on_off'] = 85;
            jsonMap['phone_type'] = 0;
          }


          print('=======${o.toString()}');
          TestCmd e = TestCmd(cmd: CmdEvtType.setOnekeySOS, name: o.toString(), json: jsonMap   );
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
        else if (o.toString() == S.current.setmusicopenoff) {   // 设置音乐开关
          swFlag?jsonMap['on_off'] = 1:jsonMap['on_off'] = 0;
          if (swFlag) {
            jsonMap['on_off'] = 170;
            jsonMap['phone_type'] = 0;
          } else {
            jsonMap['on_off'] = 85;
            jsonMap['phone_type'] = 0;
          }


          print('=======${o.toString()}');
          TestCmd e = TestCmd(cmd: CmdEvtType.setMusicOnOff, name: o.toString(), json: jsonMap   );
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

        // todo  没有找到相关的命令
        else if (o.toString() == S.current.musiccontrol){



        }


      });


    }
    return const Text('test');
  }


}





