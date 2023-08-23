// 设置洗手提醒


import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';
import '../../common/common.dart';
import 'information_set_model.dart';
import '../../pickers/pickers.dart';
import '../../pickers/style/default_style.dart';
import '../../common/commonTool.dart';
import '../../common/Toast.dart';
import 'package:protocol_lib/protocol_lib.dart';
import 'dart:convert';


typedef OnSelect = void Function(Object o);


class WashHandReminderSet extends StatelessWidget {
  final String navTitle;


  const WashHandReminderSet({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),
      body: const WashHandReminderContent(),
    );
  }
}


class WashHandReminderContent extends StatefulWidget {
  const WashHandReminderContent({Key? key}) : super(key: key);

  @override
  State<WashHandReminderContent> createState() => _WashHandReminderContentState();
}

class _WashHandReminderContentState extends State<WashHandReminderContent> {

  WashHandReminderSetModel _washHandRemindModel = WashHandReminderSetModel();



  List<String> leftList = [S.current.connected,
    S.current.setwashhandreminderswitch,
    S.current.setintervallength,
    S.current.setstarttime,
    S.current.setendtime,
    "space",
    S.current.monday,
    S.current.tuesday,
    S.current.wednesday,
    S.current.thursday,
    S.current.friday,
    S.current.saturday,
    S.current.sunday,
    S.current.setwashhandreminder,
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
    else if (tInt == 1) {
      return commonUI.productionWidget(WidType.textSwitch, [leftList[tInt], _washHandRemindModel.washHandReminderFlag.toString()], (o) {
        String sValue = o.toString();
        print('textSwitch----${sValue}');
        sValue == 'true'?_washHandRemindModel.washHandReminderFlag = true:_washHandRemindModel.washHandReminderFlag = false;
        _updateInformation();

      });
    }
    else if (tInt == 2 )
    {
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt],_washHandRemindModel.intervalLength.toString()],
              (o) {

            dealwithPointerUp(leftList[tInt], _washHandRemindModel.intervalLength.toString(),
                    (o)
                {
                  _washHandRemindModel.intervalLength = int.parse(o.toString());
                  _updateInformation();
                });


          });
    }
    else if (tInt == 3 )
    {
      return commonUI.productionWidget(WidType.textTwoText, [leftList[tInt],_washHandRemindModel.startHour.toString(),_washHandRemindModel.startMinute.toString()],
              (o) {
            if (o.toString() == 'hour') {
              dealwithPointerUp('hour', _washHandRemindModel.startHour.toString(),
                      (o)
                  {
                    _washHandRemindModel.startHour = int.parse(o.toString());
                    _updateInformation();
                  });
            }
            else if (o.toString() == 'minute'){
              dealwithPointerUp('minute', _washHandRemindModel.startMinute.toString(),
                      (o)
                  {
                    _washHandRemindModel.startMinute = int.parse(o.toString());
                    _updateInformation();
                  });
            }
          });
    }
    else if (tInt == 4)
    {
      return commonUI.productionWidget(WidType.textTwoText, [leftList[tInt],_washHandRemindModel.stopHour.toString(),_washHandRemindModel.stopMinute.toString()],
              (o) {
            if (o.toString() == 'hour') {
              dealwithPointerUp('hour', _washHandRemindModel.stopHour.toString(),
                      (o)
                  {
                    _washHandRemindModel.stopHour = int.parse(o.toString());
                    _updateInformation();
                  });
            }
            else if (o.toString() == 'minute'){
              dealwithPointerUp('minute', _washHandRemindModel.stopMinute.toString(),
                      (o)
                  {
                    _washHandRemindModel.stopMinute = int.parse(o.toString());
                    _updateInformation();
                  });
            }
          });
    }

    else if (tInt == 5)
    {
      return commonUI.productionWidget(WidType.spaceWidget, [], (o) { });
    }
    else if (tInt == leftList.length - 1)
    {
      return commonUI.productionWidget(WidType.buttonInfo, [leftList[tInt] ], (o) {    //设置洗手提醒
        print('object=====');

        TestCmd e = TestCmd(cmd: CmdEvtType.setHandWashingReminder, name: o.toString(), json: _washHandRemindModel.toMap()   );
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
    else
    {
      bool pt = false;
      if (_washHandRemindModel.weekList.contains(leftList[tInt])) {
        pt = true;
      }

      return commonUI.productionWidget(WidType.textSingle, [leftList[tInt],pt],
              (o) {
            print('--------${o.toString()}');
            String chStr = o.toString();
            if (_washHandRemindModel.weekList.contains(chStr)) {
              _washHandRemindModel.weekList.remove(chStr);
            }
            else{
              _washHandRemindModel.weekList.add(chStr);
            }
            _updateInformation();
          });
    }



    return const Text('test');
  }

  // 获取分钟间隔的数组
  List<String> obainMinuteInterList(){
    List<String> reList = [];
    for(int i = 1; i <= 100; i++)
    {
      reList.add(i.toString());
    }
    return reList;
  }


  //处理相关的弹框需求
  Future<void> dealwithPointerUp(String tinStr,String conStr,OnSelect onSelect)
  async {
    if (tinStr == 'hour') {   //  小时
      Pickers.showSinglePicker(
        context,
        data: commonUI.obainCellTextString(SelectType.hourType),
        selectData: conStr,
        pickerStyle: DefaultPickerStyle(),
        onConfirm: (p, position) {
          onSelect(p);
        },
        onChanged: (p, position) {
          print('longer >>> 返回数据下标：$position');
          print('数据发生改变：$p');
        },
      );
    }
    else if (tinStr == 'minute') {   //  分钟
      Pickers.showSinglePicker(
        context,
        data: commonUI.obainCellTextString(SelectType.minuteType),
        selectData: conStr,
        pickerStyle: DefaultPickerStyle(),
        onConfirm: (p, position) {
          onSelect(p);
        },
        onChanged: (p, position) {
          print('longer >>> 返回数据下标：$position');
          print('数据发生改变：$p');
        },
      );
    }

    else {
      Pickers.showSinglePicker(
        context,
        data: obainMinuteInterList(),
        selectData: conStr,
        pickerStyle: DefaultPickerStyle(),
        onConfirm: (p, position) {
          onSelect(p);
        },
        onChanged: (p, position) {
          print('longer >>> 返回数据下标：$position');
          print('数据发生改变：$p');
        },
      );

    }

  }


}





