//  设置经期提醒

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


class MenstruationRemind extends StatelessWidget {
  final String navTitle;


  MenstruationRemind({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),
      body: const MenstruationParameterContent(),
    );
  }
}


class MenstruationParameterContent extends StatefulWidget {
  const MenstruationParameterContent({Key? key}) : super(key: key);

  @override
  State<MenstruationParameterContent> createState() => _MenstruationParameterContentState();
}




class _MenstruationParameterContentState extends State<MenstruationParameterContent> {

  MenstruationReminderSetModel _menstruationReminderSetModel =  MenstruationReminderSetModel();

  List<String> leftList = [S.current.connected,
    S.current.startdatereminderdaysinadvance,
    S.current.ovulationdaysareremindeddaysinadvance,
    S.current.remindthetime,
    S.current.pregnancydaybeforeremind,
    S.current.pregnancydayendremind,
    S.current.menstrualdayendremind,
    S.current.setmenstruationremind,
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
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt],_menstruationReminderSetModel.startDateInt.toString()], (o) {
        dealwithPointerUp(S.current.setshowlongtime, _menstruationReminderSetModel.startDateInt.toString(), (o) {
          _menstruationReminderSetModel.startDateInt = int.parse(o.toString());
          _updateInformation();
        });
      });
    }
    else if (tInt == 2) {
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt] ,_menstruationReminderSetModel.ovulationDaySareremind.toString()],
              (o)
          {
            dealwithPointerUp(S.current.setshowlongtime, _menstruationReminderSetModel.ovulationDaySareremind.toString(), (o) {
              _menstruationReminderSetModel.ovulationDaySareremind = int.parse(o.toString());
              _updateInformation();
            });

          });
    }
    else if (tInt == 3) {
      return commonUI.productionWidget(WidType.textTwoText, [leftList[tInt] ,_menstruationReminderSetModel.reminderHour.toString(),_menstruationReminderSetModel.reminderMinute.toString()],
              (o)
          {
            if (o.toString() == 'hour') {
              dealwithPointerUp('hour', _menstruationReminderSetModel.reminderHour.toString(),
                      (o)
                  {
                    _menstruationReminderSetModel.reminderHour = int.parse(o.toString());
                    _updateInformation();
                  });
            }
            else if(o.toString() == 'minute'){
              dealwithPointerUp('minute', _menstruationReminderSetModel.reminderMinute.toString(),
                      (o)
                  {
                    _menstruationReminderSetModel.reminderMinute = int.parse(o.toString());
                    _updateInformation();
                  });
            }

          });
    }
    else if (tInt == 4){
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt] ,_menstruationReminderSetModel.pregnancydaybefore.toString()], (o) {
        dealwithPointerUp(S.current.setshowlongtime, _menstruationReminderSetModel.pregnancydaybefore.toString(), (o) {
          _menstruationReminderSetModel.pregnancydaybefore = int.parse(o.toString());
          _updateInformation();
        });

      });
    }
    else if (tInt == 5) {
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt] ,_menstruationReminderSetModel.pregnancydayend.toString()],
              (o)
          {
            dealwithPointerUp(S.current.setshowlongtime, _menstruationReminderSetModel.pregnancydayend.toString(), (o) {
              _menstruationReminderSetModel.pregnancydayend = int.parse(o.toString());
              _updateInformation();
            });

          });
    }
    else if (tInt == 6) {
      return commonUI.productionWidget(WidType.textTextField, [leftList[tInt] ,_menstruationReminderSetModel.menstrualdayend.toString()],
              (o)
          {
            dealwithPointerUp(S.current.setshowlongtime, _menstruationReminderSetModel.menstrualdayend.toString(), (o) {
              _menstruationReminderSetModel.menstrualdayend = int.parse(o.toString());
              _updateInformation();
            });

          });
    }
    else if (tInt == leftList.length - 1) {
      return commonUI.productionWidget(WidType.buttonInfo, [leftList[tInt] ], (o) {
        print('object=====');
        TestCmd e = TestCmd(cmd: CmdEvtType.setMenstruationRemind, name: o.toString(), json: _menstruationReminderSetModel.toMap()   );
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





  //处理相关的弹框需求
  Future<void> dealwithPointerUp(String tinStr,String conStr,OnSelect onSelect)
  async {
    if (tinStr == S.current.setshowlongtime) {   // 显示时长
      //int? type = await _showModalBottomSheet(SelectType.useridType);
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
    else if (tinStr == 'hour') {   //  小时
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

  }

}





