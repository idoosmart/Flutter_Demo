// 设置喝水提醒

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


class DrinkWaterReminderSet extends StatelessWidget {
  final String navTitle;


  const DrinkWaterReminderSet({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),
      body: const DrinkWaterReminderContent(),
    );
  }
}


class DrinkWaterReminderContent extends StatefulWidget {
  const DrinkWaterReminderContent({Key? key}) : super(key: key);

  @override
  State<DrinkWaterReminderContent> createState() => _DrinkWaterReminderContentState();
}

class _DrinkWaterReminderContentState extends State<DrinkWaterReminderContent> {

  DrinkWaterReminderSetModel _drinkRemindModel = DrinkWaterReminderSetModel();



  List<String> leftList = [S.current.connected,
    S.current.setdrinkwaterreminder,
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
    S.current.setdrinkwaterreminder,
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
      return commonUI.productionWidget(WidType.textSwitch, [leftList[tInt], _drinkRemindModel.drinkWaterReminderFlag.toString()], (o) {
        String sValue = o.toString();
        print('textSwitch----${sValue}');
        sValue == 'true'?_drinkRemindModel.drinkWaterReminderFlag = true:_drinkRemindModel.drinkWaterReminderFlag = false;
        _updateInformation();

      });
    }
    else if (tInt == 2 )
    {
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt],_drinkRemindModel.minuteInterval.toString()],
              (o) {

              dealwithPointerUp('', _drinkRemindModel.minuteInterval.toString(),
                      (o)
                  {
                    _drinkRemindModel.minuteInterval = int.parse(o.toString());
                    _updateInformation();
                  });


          });
    }
    else if (tInt == 3 )
    {
      return commonUI.productionWidget(WidType.textTwoText, [leftList[tInt],_drinkRemindModel.startHour.toString(),_drinkRemindModel.startMinute.toString()],
              (o) {
              if (o.toString() == 'hour') {
                dealwithPointerUp('hour', _drinkRemindModel.startHour.toString(),
                        (o)
                    {
                      _drinkRemindModel.startHour = int.parse(o.toString());
                      _updateInformation();
                    });
              }
              else if (o.toString() == 'minute'){
                dealwithPointerUp('minute', _drinkRemindModel.startMinute.toString(),
                        (o)
                    {
                      _drinkRemindModel.startMinute = int.parse(o.toString());
                      _updateInformation();
                    });
              }
          });
    }
    else if (tInt == 4)
    {
      return commonUI.productionWidget(WidType.textTwoText, [leftList[tInt],_drinkRemindModel.stopHour.toString(),_drinkRemindModel.stopMinute.toString()],
              (o) {
            if (o.toString() == 'hour') {
              dealwithPointerUp('hour', _drinkRemindModel.stopHour.toString(),
                      (o)
                  {
                    _drinkRemindModel.stopHour = int.parse(o.toString());
                    _updateInformation();
                  });
            }
            else if (o.toString() == 'minute'){
              dealwithPointerUp('minute', _drinkRemindModel.stopMinute.toString(),
                      (o)
                  {
                    _drinkRemindModel.stopMinute = int.parse(o.toString());
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
      return commonUI.productionWidget(WidType.buttonInfo, [leftList[tInt] ], (o) {


        TestCmd e = TestCmd(cmd: CmdEvtType.setDrinkWaterRemind, name: o.toString(), json: _drinkRemindModel.toMap()   );
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
      if (_drinkRemindModel.weekList.contains(leftList[tInt])) {
        pt = true;
      }

      return commonUI.productionWidget(WidType.textSingle, [leftList[tInt],pt],
              (o) {
            print('--------${o.toString()}');
            String chStr = o.toString();
            if (_drinkRemindModel.weekList.contains(chStr)) {
              _drinkRemindModel.weekList.remove(chStr);
            }
            else{
              _drinkRemindModel.weekList.add(chStr);
            }
            _updateInformation();
          });
    }



    return const Text('test');
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
        data: commonUI.obainCellTextString(SelectType.showTimeType),
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





