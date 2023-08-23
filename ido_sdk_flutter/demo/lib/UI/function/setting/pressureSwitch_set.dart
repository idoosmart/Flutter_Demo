// 设置压力开关

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


class PressureSwitchSet extends StatelessWidget {
  final String navTitle;


  const PressureSwitchSet({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),
      body: const PressureSwitchContent(),
    );
  }
}


class PressureSwitchContent extends StatefulWidget {
  const PressureSwitchContent({Key? key}) : super(key: key);

  @override
  State<PressureSwitchContent> createState() => _PressureSwitchContentState();
}

class _PressureSwitchContentState extends State<PressureSwitchContent> {

  PressureSwitchSetModel _pressureSwitchModel = PressureSwitchSetModel();


  List<String> leftList = [S.current.connected,
    S.current.setpressureswitch,
    S.current.setintervallength,
    S.current.highpressurethreshold,
    S.current.setstarttime,
    S.current.setendtime,
    S.current.setpressurereminderswitch,
    "space",
    S.current.monday,
    S.current.tuesday,
    S.current.wednesday,
    S.current.thursday,
    S.current.friday,
    S.current.saturday,
    S.current.sunday,
    S.current.setpressureswitch,
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
      return commonUI.productionWidget(WidType.textSwitch, [leftList[tInt], _pressureSwitchModel.pressureSwitchFlag.toString()], (o) {
        String sValue = o.toString();
        print('textSwitch----${sValue}');
        sValue == 'true'?_pressureSwitchModel.pressureSwitchFlag = true:_pressureSwitchModel.pressureSwitchFlag = false;
        _updateInformation();

      });
    }
    else if (tInt == 2 )
    {
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt],_pressureSwitchModel.intervalLength.toString()],
              (o) {

            dealwithPointerUp('', _pressureSwitchModel.intervalLength.toString(),
                    (o)
                {
                  _pressureSwitchModel.intervalLength = int.parse(o.toString());
                  _updateInformation();
                });


          });
    }
    else if (tInt == 3 )
    {
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt],_pressureSwitchModel.hightPressureReminder.toString()],
              (o) {

            dealwithPointerUp('', _pressureSwitchModel.hightPressureReminder.toString(),
                    (o)
                {
                  _pressureSwitchModel.hightPressureReminder = int.parse(o.toString());
                  _updateInformation();
                });


          });
    }
    else if (tInt == 4)
    {
      return commonUI.productionWidget(WidType.textTwoText, [leftList[tInt],_pressureSwitchModel.startHour.toString(),_pressureSwitchModel.startMinute.toString()],
              (o) {
            if (o.toString() == 'hour') {
              dealwithPointerUp('hour', _pressureSwitchModel.startHour.toString(),
                      (o)
                  {
                    _pressureSwitchModel.startHour = int.parse(o.toString());
                    _updateInformation();
                  });
            }
            else if (o.toString() == 'minute'){
              dealwithPointerUp('minute', _pressureSwitchModel.startMinute.toString(),
                      (o)
                  {
                    _pressureSwitchModel.startMinute = int.parse(o.toString());
                    _updateInformation();
                  });
            }
          });
    }
    else if (tInt == 5)
    {
      return commonUI.productionWidget(WidType.textTwoText, [leftList[tInt],_pressureSwitchModel.stopHour.toString(),_pressureSwitchModel.stopMinute.toString()],
              (o) {
            if (o.toString() == 'hour') {
              dealwithPointerUp('hour', _pressureSwitchModel.stopHour.toString(),
                      (o)
                  {
                    _pressureSwitchModel.stopHour = int.parse(o.toString());
                    _updateInformation();
                  });
            }
            else if (o.toString() == 'minute'){
              dealwithPointerUp('minute', _pressureSwitchModel.stopMinute.toString(),
                      (o)
                  {
                    _pressureSwitchModel.stopMinute = int.parse(o.toString());
                    _updateInformation();
                  });
            }
          });
    }
    else if (tInt == 6)
    {
      return commonUI.productionWidget(WidType.textSwitch, [leftList[tInt],_pressureSwitchModel.pressureReminderFlag.toString()], (o) {
        String sValue = o.toString();
        print('textSwitch----${sValue}');
        sValue == 'true'?_pressureSwitchModel.pressureReminderFlag = true:_pressureSwitchModel.pressureReminderFlag = false;
        _updateInformation();
      });
    }
    else if (tInt == 7)
    {
      return commonUI.productionWidget(WidType.spaceWidget, [], (o) { });
    }
    else if (tInt == leftList.length - 1)
    {
      return commonUI.productionWidget(WidType.buttonInfo, [leftList[tInt] ], (o) {
        print('object=====');
        TestCmd e = TestCmd(cmd: CmdEvtType.setStressSwitch, name: o.toString(), json: _pressureSwitchModel.toMap()   );
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
      if (_pressureSwitchModel.weekList.contains(leftList[tInt])) {
        pt = true;
      }

      return commonUI.productionWidget(WidType.textSingle, [leftList[tInt],pt],
              (o) {
            print('--------${o.toString()}');
            String chStr = o.toString();
            if (_pressureSwitchModel.weekList.contains(chStr)) {
              _pressureSwitchModel.weekList.remove(chStr);
            }
            else{
              _pressureSwitchModel.weekList.add(chStr);
            }
            _updateInformation();
          });
    }



    return const Text('test');
  }


  List<String> obainPressureList(){
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
    else{                                 //
      Pickers.showSinglePicker(
        context,
        data: obainPressureList(),
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






