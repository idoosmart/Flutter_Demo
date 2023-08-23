// 设置v3心率模式

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


class HeartRateV3ModeSet extends StatelessWidget {
  final String navTitle;


  const HeartRateV3ModeSet({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),
      body: const HeartRateV3ModeContent(),
    );
  }
}


class HeartRateV3ModeContent extends StatefulWidget {
  const HeartRateV3ModeContent({Key? key}) : super(key: key);

  @override
  State<HeartRateV3ModeContent> createState() => _HeartRateV3ModeContentState();
}

class _HeartRateV3ModeContentState extends State<HeartRateV3ModeContent> {

  HeartRateV3SetModel _heartRateV3Model = HeartRateV3SetModel();
  // v3心率模式的种类
  List<String> v3HrModeList = [S.current.off,S.current.manualmode,S.current.automode,S.current.continuouslymonitor,];
  // 左边的标题
  List<String> leftList = [S.current.connected,
    S.current.setv3heartratemode,
    S.current.heartratetimerange,
    S.current.setintervalsecondlength,
    S.current.setstarttime,
    S.current.setendtime,
    S.current.setv3heartratemode,
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
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt],  v3HrModeList[_heartRateV3Model.heartRateV3Mode]  ], (o) {

        dealwithPointerUp(leftList[tInt], v3HrModeList[_heartRateV3Model.heartRateV3Mode], (o) {

          _heartRateV3Model.heartRateV3Mode = int.parse(o.toString());
          _updateInformation();
        });

      });
    }
    else if (tInt == 2 )
    {
      return commonUI.productionWidget(WidType.textSwitch, [leftList[tInt],_heartRateV3Model.hrIntervalTimeFlag.toString()],
              (o) {
                String sValue = o.toString();
                print('textSwitch----${sValue}');
                sValue == 'true'?_heartRateV3Model.hrIntervalTimeFlag = true:_heartRateV3Model.hrIntervalTimeFlag = false;
          });
    }
    else if (tInt == 3 )
    {
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt],_heartRateV3Model.secondIntervalDuration.toString()   ],
              (o) {
                dealwithPointerUp(leftList[tInt], _heartRateV3Model.secondIntervalDuration.toString(), (o) {

                  _heartRateV3Model.secondIntervalDuration = int.parse(o.toString());
                  _updateInformation();
                });
          });
    }
    else if (tInt == 4)
    {
      return commonUI.productionWidget(WidType.textTwoText, [leftList[tInt],_heartRateV3Model.startHour.toString(),_heartRateV3Model.startMinute.toString()],
              (o) {
            if (o.toString() == 'hour') {
              dealwithPointerUp('hour', _heartRateV3Model.startHour.toString(),
                      (o)
                  {
                    _heartRateV3Model.startHour = int.parse(o.toString());
                    _updateInformation();
                  });
            }
            else if (o.toString() == 'minute'){
              dealwithPointerUp('minute', _heartRateV3Model.startMinute.toString(),
                      (o)
                  {
                    _heartRateV3Model.startMinute = int.parse(o.toString());
                    _updateInformation();
                  });
            }
          });
    }
    else if (tInt == 5)
    {
      return commonUI.productionWidget(WidType.textTwoText, [leftList[tInt],_heartRateV3Model.stopHour.toString(),_heartRateV3Model.stopMinute.toString()],
              (o) {
            if (o.toString() == 'hour') {
              dealwithPointerUp('hour', _heartRateV3Model.stopHour.toString(),
                      (o)
                  {
                    _heartRateV3Model.stopHour = int.parse(o.toString());
                    _updateInformation();
                  });
            }
            else if (o.toString() == 'minute'){
              dealwithPointerUp('minute', _heartRateV3Model.stopMinute.toString(),
                      (o)
                  {
                    _heartRateV3Model.stopMinute = int.parse(o.toString());
                    _updateInformation();
                  });
            }
          });
    }
    else if (tInt == leftList.length - 1)
    {
      return commonUI.productionWidget(WidType.buttonInfo, [leftList[tInt] ], (o) {
        print('object=====');
        TestCmd e = TestCmd(cmd: CmdEvtType.setHeartMode, name: S.current.settargetcalorie_distance, json: _heartRateV3Model.toMap()   );
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
    else if (tinStr == S.current.setv3heartratemode) {   // 设置v3心率模式
      Pickers.showSinglePicker(
        context,
        data: v3HrModeList,
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
    else if (tinStr == S.current.setintervalsecondlength) {
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





