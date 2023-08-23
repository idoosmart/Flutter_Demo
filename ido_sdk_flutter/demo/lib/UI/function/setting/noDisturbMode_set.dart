// 设置勿扰模式

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


class NoDisturbModeSet extends StatelessWidget {
  final String navTitle;


  const NoDisturbModeSet({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),
      body: const NoDisturbModeContent(),
    );
  }
}


class NoDisturbModeContent extends StatefulWidget {
  const NoDisturbModeContent({Key? key}) : super(key: key);

  @override
  State<NoDisturbModeContent> createState() => _NoDisturbModeContentState();
}

class _NoDisturbModeContentState extends State<NoDisturbModeContent> {

  NoDisturbModeSetModel _noDisturbModeModel = NoDisturbModeSetModel();



  List<String> leftList = [S.current.connected,
    S.current.setnodisturbmodeswitch,
    S.current.setstarttime,
    S.current.setendtime,
    S.current.settimerange,
    "space",
    S.current.monday,
    S.current.tuesday,
    S.current.wednesday,
    S.current.thursday,
    S.current.friday,
    S.current.saturday,
    S.current.sunday,
    S.current.setnodisturbmode,
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
      return commonUI.productionWidget(WidType.textSwitch, [leftList[tInt], _noDisturbModeModel.noDisturbModeFlag.toString()], (o) {
        String sValue = o.toString();
        print('textSwitch----${sValue}');
        sValue == 'true'?_noDisturbModeModel.noDisturbModeFlag = true:_noDisturbModeModel.noDisturbModeFlag = false;
        _updateInformation();

      });
    }
    else if (tInt == 2 )
    {
      return commonUI.productionWidget(WidType.textTwoText, [leftList[tInt],_noDisturbModeModel.startHour.toString(),_noDisturbModeModel.startMinute.toString()],
              (o) {
            if (o.toString() == 'hour') {
              dealwithPointerUp('hour', _noDisturbModeModel.startHour.toString(),
                      (o)
                  {
                    _noDisturbModeModel.startHour = int.parse(o.toString());
                    _updateInformation();
                  });
            }
            else if(o.toString() == 'minute'){
              dealwithPointerUp('minute', _noDisturbModeModel.startMinute.toString(),
                      (o)
                  {
                    _noDisturbModeModel.startMinute = int.parse(o.toString());
                    _updateInformation();
                  });
            }
          });
    }
    else if (tInt == 3 )
    {
      return commonUI.productionWidget(WidType.textTwoText, [leftList[tInt],_noDisturbModeModel.endHour.toString(),_noDisturbModeModel.endMinute.toString()],
              (o) {
            if (o.toString() == 'hour') {
              dealwithPointerUp('hour', _noDisturbModeModel.endHour.toString(),
                      (o)
                  {
                    _noDisturbModeModel.endHour = int.parse(o.toString());
                    _updateInformation();
                  });
            }
            else if(o.toString() == 'minute'){
              dealwithPointerUp('minute', _noDisturbModeModel.endMinute.toString(),
                      (o)
                  {
                    _noDisturbModeModel.endMinute = int.parse(o.toString());
                    _updateInformation();
                  });
            }
          });
    }
    else if (tInt == 4)
    {
      return commonUI.productionWidget(WidType.textSwitch, [leftList[tInt], _noDisturbModeModel.timeRegionFlag.toString()], (o) {
        String sValue = o.toString();
        print('textSwitch----${sValue}');
        sValue == 'true'?_noDisturbModeModel.timeRegionFlag = true:_noDisturbModeModel.timeRegionFlag = false;
        _updateInformation();

      });
    }
    else if (tInt == 5)
    {
      return commonUI.productionWidget(WidType.spaceWidget, [], (o) { });
    }
    else if (tInt == leftList.length - 1)
    {
      return commonUI.productionWidget(WidType.buttonInfo, [leftList[tInt] ], (o) {
        print('object=====');


        TestCmd e = TestCmd(cmd: CmdEvtType.setNotDisturb, name: o.toString(), json: _noDisturbModeModel.toMap()   );
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
      if (_noDisturbModeModel.weekList.contains(leftList[tInt])) {
        pt = true;
      }

      return commonUI.productionWidget(WidType.textSingle, [leftList[tInt],pt],
              (o) {
            print('--------${o.toString()}');
            String chStr = o.toString();
            if (_noDisturbModeModel.weekList.contains(chStr)) {
              _noDisturbModeModel.weekList.remove(chStr);
            }
            else{
              _noDisturbModeModel.weekList.add(chStr);
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


  }


}





