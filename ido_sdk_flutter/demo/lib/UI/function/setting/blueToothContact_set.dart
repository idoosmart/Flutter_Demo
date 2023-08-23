// 设置蓝牙联系人


import 'package:flutter/material.dart';
import 'package:event_bus/event_bus.dart';
import '../../../generated/l10n.dart';
import '../../common/common.dart';
import 'information_set_model.dart';
import 'dart:async';
import '../../common/commonTool.dart';
import '../../common/Toast.dart';
import 'package:protocol_lib/protocol_lib.dart';
import 'dart:convert';


class CustomEvent {
  BlueToothContactModel msgModel;
  CustomEvent(this.msgModel);
}
EventBus eventBus = EventBus();


typedef OnSelect = void Function(Object o);


class BlueToothContactSet extends StatelessWidget {
  final String navTitle;


  BlueToothContactSet({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),



      body: const BlueToothContactSetContent(),
    );
  }
}


class BlueToothContactSetContent extends StatefulWidget {
  const BlueToothContactSetContent({Key? key}) : super(key: key);

  @override
  State<BlueToothContactSetContent> createState() => BlueToothContactSetContentState();
}




class BlueToothContactSetContentState extends State<BlueToothContactSetContent> {

  BlueToothContactSetModel _blueToothContactSetModel =  BlueToothContactSetModel();


  List<String> leftList = [S.current.connected,S.current.versionnum,
    S.current.pleaseaddcontact, S.current.setup, ];



  late StreamSubscription subscription;

  void _updateInformation() {
    setState(() {

      //_counter++;
    });
  }

  @override
  void initState() {

    //监听CustomEvent事件，刷新UI
    subscription = eventBus.on<CustomEvent>().listen((event) {
      print(event);
      setState(() {
        _blueToothContactSetModel.contactList.add(event.msgModel);
      });
    });


    // TODO: implement initState
    super.initState();
  }


  @override
  void dispose() {

    subscription.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (BuildContext ctx, int index) {
        return createCell(index);
      },


      itemCount: leftList.length + _blueToothContactSetModel.contactList.length ,
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

    else if (tInt == 1) {  // 版本号
      return commonUI.productionWidget(WidType.textTextField, [leftList[tInt],_blueToothContactSetModel.version.toString()], (o) {
        print('object=====');

      });
    }
    else if (tInt == leftList.length + _blueToothContactSetModel.contactList.length  - 1 || tInt == leftList.length + _blueToothContactSetModel.contactList.length - 2) {
      return commonUI.productionWidget(WidType.buttonInfo, [leftList[tInt - _blueToothContactSetModel.contactList.length]], (o) {
        if (o.toString() == S.current.pleaseaddcontact) {   // 请添加联系人
          Navigator.push(context, MaterialPageRoute(builder: (context)=>  BlueToothContact(navTitle: o.toString(),)  ));
        }
        else{

          TestCmd e = TestCmd(cmd: CmdEvtType.setSyncContact, name: o.toString(), json: _blueToothContactSetModel.toMap()   );
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

      });
    }
    else {

      BlueToothContactModel conModel = _blueToothContactSetModel.contactList[tInt - 2];
      String astr =  '${conModel.nameStr}:${conModel.phoneNumber}';
      return commonUI.productionWidget(WidType.textSingleShow, [astr], (o) { });

    }

    return const Text('test');
  }


}




class BlueToothContact extends StatelessWidget {
  final String navTitle;


  const BlueToothContact({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),
      body: const BlueToothContactContent(),
    );
  }
}


class BlueToothContactContent extends StatefulWidget {
  const BlueToothContactContent({Key? key}) : super(key: key);

  @override
  State<BlueToothContactContent> createState() => _BlueToothContactContentState();
}

class _BlueToothContactContentState extends State<BlueToothContactContent> {

  BlueToothContactModel _blueToothContactModel = BlueToothContactModel();

  List<String> leftList = [S.current.connected,
    S.current.name,
    S.current.phone,
    S.current.setup,
  ];



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
    else if (tInt == 1) {   // 姓名
      return commonUI.productionWidget(WidType.textTextField, [leftList[tInt],  _blueToothContactModel.nameStr,'1'], (o) {
        _blueToothContactModel.nameStr = o.toString();
      });
    }
    else if (tInt == 2 )    // 手机
        {
      return commonUI.productionWidget(WidType.textTextField, [leftList[tInt],_blueToothContactModel.phoneNumber], (o) {
        _blueToothContactModel.phoneNumber = o.toString();
      });
    }

    else if (tInt == leftList.length - 1)
    {
      // 添加日程
      return commonUI.productionWidget(WidType.buttonInfo, [leftList[tInt] ], (o) {
        print('object=====');
        eventBus.fire(CustomEvent(_blueToothContactModel));
        Navigator.pop(context);
      });
    }




    return const Text('test');
  }





}




