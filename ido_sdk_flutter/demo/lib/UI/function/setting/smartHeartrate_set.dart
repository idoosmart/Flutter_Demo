// 设置智能心率

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


class SmartHeartRate extends StatelessWidget {
  final String navTitle;


  SmartHeartRate({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),
      body: const SmartHeartRateContent(),
    );
  }
}


class SmartHeartRateContent extends StatefulWidget {
  const SmartHeartRateContent({Key? key}) : super(key: key);

  @override
  State<SmartHeartRateContent> createState() => _SmartHeartRateContentState();
}




class _SmartHeartRateContentState extends State<SmartHeartRateContent> {

  SmartHeartRateSetModel _smartHeartRateSetModel =  SmartHeartRateSetModel();
  
  List<String> leftList = [S.current.connected,S.current.smartheartratemodel,
    S.current.notifyflag,S.current.highheartratereminderswitch,
    S.current.heartratetoohighthreshold,S.current.heartratetoolowthreshold,
    S.current.lowheartratealertthreshold,S.current.setup,];

  // 通知类型的选择队列
  List<String> notiTypeList = [S.current.invalid,S.current.allownotifyflag,
    S.current.silencenotifyflag,S.current.closenotifyflag,];


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
      return commonUI.productionWidget(WidType.textSwitch, [leftList[tInt],_smartHeartRateSetModel.smartheartratemodelFlag.toString()], (o) {
        String sValue = o.toString();
        print('textSwitch----${sValue}');
        sValue == 'true'?_smartHeartRateSetModel.smartheartratemodelFlag = true:_smartHeartRateSetModel.smartheartratemodelFlag = false;
        _updateInformation();

      });
    }
    else if (tInt == 2) {
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt] , notiTypeList[_smartHeartRateSetModel.notifyType] ],
              (o) {
            print('setshowlongtime====');
            dealwithPointerUp(leftList[tInt], notiTypeList[_smartHeartRateSetModel.notifyType],
                    (o) {
                  print('------${o}');
                  _smartHeartRateSetModel.notifyType = int.parse(o.toString());
                  _updateInformation();
                });
          }
      );
    }
    else if (tInt == 3) {
      return commonUI.productionWidget(WidType.textSwitch, [leftList[tInt],_smartHeartRateSetModel.highheartratereminderFlag.toString()], (o) {
        String sValue = o.toString();
        print('textSwitch----${sValue}');
        sValue == 'true'?_smartHeartRateSetModel.highheartratereminderFlag = true:_smartHeartRateSetModel.highheartratereminderFlag = false;
        _updateInformation();

      });
    }
    else if (tInt == 4) {
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt] ,_smartHeartRateSetModel.heartratetoohighthreshold.toString()],
              (o)
          {

              dealwithPointerUp('', _smartHeartRateSetModel.heartratetoohighthreshold.toString(),
                      (o)
                  {
                    _smartHeartRateSetModel.heartratetoohighthreshold = int.parse(o.toString());
                    _updateInformation();
                  });



          });
    }
    else if (tInt == 5) {
      return commonUI.productionWidget(WidType.textSwitch, [leftList[tInt],_smartHeartRateSetModel.lowheartratereminderFlag.toString()],
              (o)
          {
            String sValue = o.toString();
            print('textSwitch----${sValue}');
            sValue == 'true'?_smartHeartRateSetModel.lowheartratereminderFlag = true:_smartHeartRateSetModel.lowheartratereminderFlag = false;
            _updateInformation();
          });
    }
    else if (tInt == 6) {
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt] ,_smartHeartRateSetModel.heartratetoolowthreshold.toString()],
              (o)
          {

            dealwithPointerUp('', _smartHeartRateSetModel.heartratetoolowthreshold.toString(),
                    (o)
                {
                  _smartHeartRateSetModel.heartratetoolowthreshold = int.parse(o.toString());
                  _updateInformation();
                });



          });
    }

    else if (tInt == 7) {
      return commonUI.productionWidget(WidType.buttonInfo, [leftList[tInt]], (o) {
        print('object=====');

        TestCmd e = TestCmd(cmd: CmdEvtType.setHeartRateModeSmart, name: o.toString(), json: _smartHeartRateSetModel.toMap()   );
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
    if (tinStr == S.current.notifyflag) {    // 通知类型
      Pickers.showSinglePicker(
        context,
        data: notiTypeList,
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
    else {
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


  }

}





