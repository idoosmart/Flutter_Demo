// 设置心率区间

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


class HeartIntervalSet extends StatelessWidget {
  final String navTitle;


  const HeartIntervalSet({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),
      body: const HeartIntervalContent(),
    );
  }
}


class HeartIntervalContent extends StatefulWidget {
  const HeartIntervalContent({Key? key}) : super(key: key);

  @override
  State<HeartIntervalContent> createState() => _HeartIntervalContentState();
}

class _HeartIntervalContentState extends State<HeartIntervalContent> {

  HeartIntervalSetModel _heartIntervalModel = HeartIntervalSetModel();



  List<String> leftList = [S.current.connected,
    S.current.burnFat,
    S.current.aerobicExercise,
    S.current.extremeExercise,
    S.current.maxHeartRate,
    S.current.warmup,
    S.current.anaerobicExercise,
    S.current.minheartrate,
    S.current.setstarttime,
    S.current.setendtime,
    S.current.setmaxhrremindswitch,
    S.current.setminhrremindswitch,
    S.current.setHeartRateIntervalButton,
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
    else if (tInt == 1)   // 燃烧脂肪
    {
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt], _heartIntervalModel.burnFat.toString()], (o) {
        dealwithPointerUp(S.current.burnFat, _heartIntervalModel.burnFat.toString(), (o) {
          _heartIntervalModel.burnFat = int.parse(o.toString());
          _updateInformation();
        });
      });
    }
    else if (tInt == 2)  // 有氧锻炼
    {
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt],_heartIntervalModel.aerobic.toString()], (o)
      {
        dealwithPointerUp(S.current.aerobicExercise, _heartIntervalModel.aerobic.toString(), (o) {
          _heartIntervalModel.aerobic = int.parse(o.toString());
          _updateInformation();
        });

      });
    }
    else if (tInt == 3 )  // 极限锻炼
    {
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt],_heartIntervalModel.limitValue.toString()], (o)
      {
        dealwithPointerUp(S.current.burnFat, _heartIntervalModel.aerobic.toString(), (o) {
          _heartIntervalModel.limitValue = int.parse(o.toString());
          _updateInformation();
        });
      });
    }
    else if (tInt == 4 )  // 最大心率
    {
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt],_heartIntervalModel.userMaxHr.toString()],
              (o) {
            dealwithPointerUp('tinStr', _heartIntervalModel.userMaxHr.toString(), (o) {
              _heartIntervalModel.userMaxHr = int.parse(o.toString());
              _updateInformation();
            });
          });
    }
    else if (tInt == 5)  // 热身运动
    {
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt],_heartIntervalModel.warmUp.toString()],
              (o) {
                dealwithPointerUp('', _heartIntervalModel.warmUp.toString(), (o) {
                  _heartIntervalModel.warmUp = int.parse(o.toString());
                  _updateInformation();
                });
          });
    }
    else if (tInt == 6) {  // 无氧运动
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt],_heartIntervalModel.anaerobic.toString() ],
              (o) {
                dealwithPointerUp('tinStr', _heartIntervalModel.anaerobic.toString(), (o) {
                  _heartIntervalModel.anaerobic = int.parse(o.toString());
                  _updateInformation();
                });
            });
    }
    else if (tInt == 7)  // 最小心率
        {
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt],_heartIntervalModel.minHr.toString()],
              (o) {
                dealwithPointerUp('tinStr', _heartIntervalModel.minHr.toString(), (o) {
                  _heartIntervalModel.minHr = int.parse(o.toString());
                  _updateInformation();
                });
          });
    }
    else if (tInt == 8)  // 设置开始时间
        {
      return commonUI.productionWidget(WidType.textTwoText, [leftList[tInt],_heartIntervalModel.startHour.toString(),_heartIntervalModel.startMinute.toString()],
              (o) {
                if (o.toString() == 'hour') {
                  dealwithPointerUp('hour', _heartIntervalModel.startHour.toString(),
                          (o)
                      {
                        _heartIntervalModel.startHour = int.parse(o.toString());
                        _updateInformation();
                      });
                }
                else if(o.toString() == 'minute'){
                  dealwithPointerUp('minute', _heartIntervalModel.startMinute.toString(),
                          (o)
                      {
                        _heartIntervalModel.startMinute = int.parse(o.toString());
                        _updateInformation();
                      });
                }
          });
    }
    else if (tInt == 9)  // 设置结束时间
        {
      return commonUI.productionWidget(WidType.textTwoText, [leftList[tInt],_heartIntervalModel.stopHour.toString(),_heartIntervalModel.stopMinute.toString(),],
              (o) {
                if (o.toString() == 'hour') {
                  dealwithPointerUp('hour', _heartIntervalModel.stopHour.toString(),
                          (o)
                      {
                        _heartIntervalModel.stopHour = int.parse(o.toString());
                        _updateInformation();
                      });
                }
                else if(o.toString() == 'minute'){
                  dealwithPointerUp('minute', _heartIntervalModel.stopMinute.toString(),
                          (o)
                      {
                        _heartIntervalModel.stopMinute = int.parse(o.toString());
                        _updateInformation();
                      });
                }
          });
    }
    else if (tInt == 10)  // 设置最大心率的提醒开关
        {
      return commonUI.productionWidget(WidType.textSwitch, [leftList[tInt],_heartIntervalModel.maxHrRemind.toString()],
              (o) {
                String sValue = o.toString();
                print('textSwitch----${sValue}');
                sValue == 'true'?_heartIntervalModel.maxHrRemind = true:_heartIntervalModel.maxHrRemind = false;
                _updateInformation();
          });
    }
    else if (tInt == 11)  // 设置最小心率的提醒开关
        {
      return commonUI.productionWidget(WidType.textSwitch, [leftList[tInt],_heartIntervalModel.minHrRemind.toString()],
              (o) {
                String sValue = o.toString();
                print('textSwitch----${sValue}');
                sValue == 'true'?_heartIntervalModel.minHrRemind = true:_heartIntervalModel.minHrRemind = false;
                _updateInformation();
          });
    }

    else
    {

      return commonUI.productionWidget(WidType.buttonInfo, [leftList[tInt]], (o) {

        Map<String,dynamic> jsonMap = {};
        TestCmd e = TestCmd(cmd: CmdEvtType.setHeartRateInterval, name: o.toString() , json: jsonMap   );
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




// 生成相对应的内容
  static List<String> obainHeartIntervalCellTextString()
  {
    List<String> list = [];

    for(int i= 50;i<=300;i++)
    {
      list.add(i.toString());
    }

    return list;
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
        data: obainHeartIntervalCellTextString(),
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





