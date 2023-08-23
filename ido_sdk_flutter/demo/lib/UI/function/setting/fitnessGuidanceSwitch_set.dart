// 健身指导开关


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


class FitnessGuidanceSwitchSet extends StatelessWidget {
  final String navTitle;


  const FitnessGuidanceSwitchSet({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),
      body: const FitnessGuidanceSwitchContent(),
    );
  }
}


class FitnessGuidanceSwitchContent extends StatefulWidget {
  const FitnessGuidanceSwitchContent({Key? key}) : super(key: key);

  @override
  State<FitnessGuidanceSwitchContent> createState() => _FitnessGuidanceSwitchContentState();
}

class _FitnessGuidanceSwitchContentState extends State<FitnessGuidanceSwitchContent> {

  FitnessGuidanceSwitchSetModel _fitnessGuidanceSwitchSetModel = FitnessGuidanceSwitchSetModel();

  List<String> leftList = [S.current.connected,
    S.current.fitnessguidanceswitch,
    S.current.setstarttime,
    S.current.setendtime,
    S.current.notifyflag,
    S.current.setTargetStep,
    S.current.monday,
    S.current.tuesday,
    S.current.wednesday,
    S.current.thursday,
    S.current.friday,
    S.current.saturday,
    S.current.sunday,
    S.current.setup,
  ];

  // 通知类型的选择数组
  List<String> notiList = [S.current.invalid,S.current.allownotifyflag,
  S.current.silencenotifyflag, S.current.closenotifyflag];



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
      return commonUI.productionWidget(WidType.textSwitch, [leftList[tInt], _fitnessGuidanceSwitchSetModel.fitnessGuidanceSwitchFlag.toString()], (o) {
        String sValue = o.toString();
        print('textSwitch----${sValue}');
        sValue == 'true'?_fitnessGuidanceSwitchSetModel.fitnessGuidanceSwitchFlag = true:_fitnessGuidanceSwitchSetModel.fitnessGuidanceSwitchFlag = false;
        _updateInformation();

      });
    }
    else if (tInt == 2 )
    {
      return commonUI.productionWidget(WidType.textTwoText, [leftList[tInt],_fitnessGuidanceSwitchSetModel.startHour.toString(),_fitnessGuidanceSwitchSetModel.startMinute.toString()],
              (o) {
            if (o.toString() == 'hour') {
              dealwithPointerUp('hour', _fitnessGuidanceSwitchSetModel.startHour.toString(),
                      (o)
                  {
                    _fitnessGuidanceSwitchSetModel.startHour = int.parse(o.toString());
                    _updateInformation();
                  });
            }
            else if(o.toString() == 'minute'){
              dealwithPointerUp('minute', _fitnessGuidanceSwitchSetModel.startMinute.toString(),
                      (o)
                  {
                    _fitnessGuidanceSwitchSetModel.startMinute = int.parse(o.toString());
                    _updateInformation();
                  });
            }
          });
    }
    else if (tInt == 3 )
    {
      return commonUI.productionWidget(WidType.textTwoText, [leftList[tInt],_fitnessGuidanceSwitchSetModel.endHour.toString(),_fitnessGuidanceSwitchSetModel.endMinute.toString()],
              (o) {
            if (o.toString() == 'hour') {
              dealwithPointerUp('hour', _fitnessGuidanceSwitchSetModel.endHour.toString(),
                      (o)
                  {
                    _fitnessGuidanceSwitchSetModel.endHour = int.parse(o.toString());
                    _updateInformation();
                  });
            }
            else if(o.toString() == 'minute'){
              dealwithPointerUp('minute', _fitnessGuidanceSwitchSetModel.endMinute.toString(),
                      (o)
                  {
                    _fitnessGuidanceSwitchSetModel.endMinute = int.parse(o.toString());
                    _updateInformation();
                  });
            }
          });
    }
    else if (tInt == 4)
    {
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt], notiList[_fitnessGuidanceSwitchSetModel.notifyType] ], (o) {
        dealwithPointerUp(leftList[tInt], notiList[_fitnessGuidanceSwitchSetModel.notifyType], (o) {
          _fitnessGuidanceSwitchSetModel.notifyType = int.parse(o.toString());
          _updateInformation();
        });
      });
    }
    else if (tInt == 5)
    {
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt], _fitnessGuidanceSwitchSetModel.targetStep.toString() ], (o) {
        dealwithPointerUp(leftList[tInt], _fitnessGuidanceSwitchSetModel.targetStep.toString(), (o) {
          _fitnessGuidanceSwitchSetModel.targetStep = int.parse(o.toString());
          _updateInformation();
        });
      });
    }
    else if (tInt == leftList.length - 1)
    {
      return commonUI.productionWidget(WidType.buttonInfo, [leftList[tInt] ], (o) {
        print('object=====');
        TestCmd e = TestCmd(cmd: CmdEvtType.setFitnessGuidance, name: o.toString() , json: _fitnessGuidanceSwitchSetModel.toMap()   );
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
      if (_fitnessGuidanceSwitchSetModel.weekList.contains(leftList[tInt])) {
        pt = true;
      }

      return commonUI.productionWidget(WidType.textSingle, [leftList[tInt],pt],
              (o) {
            print('--------${o.toString()}');
            String chStr = o.toString();
            if (_fitnessGuidanceSwitchSetModel.weekList.contains(chStr)) {
              _fitnessGuidanceSwitchSetModel.weekList.remove(chStr);
            }
            else{
              _fitnessGuidanceSwitchSetModel.weekList.add(chStr);
            }
            _updateInformation();
          });
    }



    return const Text('test');
  }


  // 设置目标步数
  List<String>  obainCellTextString() {
    List<String> targetStepList = [];
    for(int i = 10000;i <= 100000;i = i + 10000){
      targetStepList.add(i.toString());
    }
    return targetStepList;
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
    else if(tinStr == S.current.notifyflag){  // 通知类型
      Pickers.showSinglePicker(
        context,
        data: notiList,
        selectData: conStr,
        pickerStyle: DefaultPickerStyle(),
        onConfirm: (p, position) {
          onSelect(position);
        },
        onChanged: (p, position) {
          print('longer >>> 返回数据下标：$position');
          print('数据发生改变：$p');
        },
      );
    }
    else if(tinStr == S.current.setTargetStep){  // 设置目标步数
      Pickers.showSinglePicker(
        context,
        data: obainCellTextString(),
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





