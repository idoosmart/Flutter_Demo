// 设置抬腕识别
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


class HandUpIdentify extends StatelessWidget {
  final String navTitle;


  HandUpIdentify({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),
      body: const HandUpIdentifyContent(),
    );
  }
}


class HandUpIdentifyContent extends StatefulWidget {
  const HandUpIdentifyContent({Key? key}) : super(key: key);

  @override
  State<HandUpIdentifyContent> createState() => _HandUpIdentifyContentState();
}




class _HandUpIdentifyContentState extends State<HandUpIdentifyContent> {

  final HandUpIdentifySetModel _identifySetModel =  HandUpIdentifySetModel(false,3,false,23,0,23,59);


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

      itemCount: 7,
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
      return commonUI.productionWidget(WidType.textSwitch, [S.current.sethandupswitch,_identifySetModel.hFidFlag.toString()], (o) {
        String sValue = o.toString();
        print('textSwitch----${sValue}');
        sValue == 'true'?_identifySetModel.hFidFlag = true:_identifySetModel.hFidFlag = false;
        _updateInformation();

      });
    }
    else if (tInt == 2) {
      return commonUI.productionWidget(WidType.textOneText, [S.current.setshowlongtime,_identifySetModel.showtime.toString()],
              (o) {
                  print('setshowlongtime====');
                  dealwithPointerUp(S.current.setshowlongtime, _identifySetModel.showtime.toString(),
                          (o) {
                            print('------${o}');
                            _identifySetModel.showtime = int.parse(o.toString());
                            _updateInformation();
                          });
              }
      );
    }
    else if (tInt == 3) {
      return commonUI.productionWidget(WidType.textSwitch, [S.current.settimerange,_identifySetModel.tqFlag.toString()], (o) {
        String sValue = o.toString();
        print('textSwitch----${sValue}');
        sValue == 'true'?_identifySetModel.tqFlag = true:_identifySetModel.tqFlag = false;
        _updateInformation();

      });
    }
    else if (tInt == 4) {
      return commonUI.productionWidget(WidType.textTwoText, [S.current.setstarttime,_identifySetModel.startTimeHour.toString(),_identifySetModel.startTimeMinute.toString()],
              (o)
          {
              if (o.toString() == 'hour') {
                dealwithPointerUp('hour', _identifySetModel.startTimeHour.toString(),
                        (o)
                    {
                      _identifySetModel.startTimeHour = int.parse(o.toString());
                      _updateInformation();
                    });
              }
              else if(o.toString() == 'minute'){
                dealwithPointerUp('minute', _identifySetModel.startTimeMinute.toString(),
                        (o)
                    {
                      _identifySetModel.startTimeMinute = int.parse(o.toString());
                      _updateInformation();
                    });
              }

          });
    }
    else if (tInt == 5) {
      return commonUI.productionWidget(WidType.textTwoText, [S.current.setendtime,_identifySetModel.endTimeHour.toString(),_identifySetModel.endTimeMinute.toString()],
              (o)
          {
            if (o.toString() == 'hour') {
              dealwithPointerUp('hour', _identifySetModel.endTimeHour.toString(),
                      (o)
                  {
                    _identifySetModel.endTimeHour = int.parse(o.toString());
                    _updateInformation();
                  });
            }
            else if(o.toString() == 'minute'){
              dealwithPointerUp('minute', _identifySetModel.endTimeMinute.toString(),
                      (o)
                  {
                    _identifySetModel.endTimeMinute = int.parse(o.toString());
                    _updateInformation();
                  });
            }


          });
    }
    else if (tInt == 6) {
      return commonUI.productionWidget(WidType.buttonInfo, [S.current.sethandupbutton], (o) {

        print('=======${o.toString()}');
        TestCmd e = TestCmd(cmd: CmdEvtType.setUpHandGesture, name: o.toString(), json:  _identifySetModel.toMap()  );
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





