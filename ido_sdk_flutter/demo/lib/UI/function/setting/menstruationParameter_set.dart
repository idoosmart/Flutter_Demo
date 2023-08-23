// 设置经期参数

import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
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


class MenstruationParameter extends StatelessWidget {
  final String navTitle;


  MenstruationParameter({super.key, required this.navTitle});

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

  MenstruationParameterSetModel _menstruationParaSetModel =  MenstruationParameterSetModel();

  List<String> leftList = [S.current.connected,S.current.menstrualswitch,
                            S.current.menstruallength,S.current.menstrualcycle,
                            S.current.recentlymenstrual,S.current.intervalbetweenovulationdays,
                            S.current.daybeforemenstrual,S.current.dayaftermenstrual,
                            S.current.setmenstruationparameter,];


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
      return commonUI.productionWidget(WidType.textSwitch, [leftList[tInt],_menstruationParaSetModel.menstrualSwitch.toString()], (o) {
        String sValue = o.toString();
        print('textSwitch----${sValue}');
        sValue == 'true'?_menstruationParaSetModel.menstrualSwitch = true:_menstruationParaSetModel.menstrualSwitch = false;
        _updateInformation();

      });

    }
    else if (tInt == 2) {
      return commonUI.productionWidget(WidType.textTextField, [leftList[tInt] ,_menstruationParaSetModel.menstrualLength.toString()],
              (o)
          {
              _menstruationParaSetModel.menstrualLength = int.parse(o.toString());
          });
    }
    else if (tInt == 3) {
      return commonUI.productionWidget(WidType.textTextField, [leftList[tInt] ,_menstruationParaSetModel.menstrualCycle.toString()],
              (o)
          {
            _menstruationParaSetModel.menstrualCycle = int.parse(o.toString());
          });
    }
    else if (tInt == 4){
      return commonUI.productionWidget(WidType.textDate, [leftList[tInt] ,_menstruationParaSetModel.recentlyMenstrual], (o)
      {
          _showDatePicker();
      });
    }
    else if (tInt == 5) {
      return commonUI.productionWidget(WidType.textTextField, [leftList[tInt] ,_menstruationParaSetModel.intervalDays.toString()],
              (o)
          {
            _menstruationParaSetModel.intervalDays = int.parse(o.toString());
          });
    }
    else if (tInt == 6) {
      return commonUI.productionWidget(WidType.textTextField, [leftList[tInt] ,_menstruationParaSetModel.dayBeforeMenstrual.toString()],
              (o)
          {
            _menstruationParaSetModel.dayBeforeMenstrual = int.parse(o.toString());
          });
    }
    else if (tInt == 7) {
      return commonUI.productionWidget(WidType.textTextField, [leftList[tInt] ,_menstruationParaSetModel.dayAfterMenstrual.toString()],
              (o)
          {
            _menstruationParaSetModel.dayAfterMenstrual = int.parse(o.toString());
          });
    }
    else if (tInt == leftList.length - 1) {
      return commonUI.productionWidget(WidType.buttonInfo, [leftList[tInt] ], (o) {
        print('object=====');
        TestCmd e = TestCmd(cmd: CmdEvtType.setMenstruation, name: o.toString(), json: _menstruationParaSetModel.toMap()   );
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


  // 显示时间的方法
  void _showDatePicker(){


    String fstr = _menstruationParaSetModel.recentlyMenstrual;
    DateTime _dateTime = DateTime.parse(fstr);
    DatePicker.showDatePicker(
      context,
      //onMonthChangeStartWithFirstDate: true,

      // 如果报错提到 DateTimePickerTheme 有问题，点开这个类的原文件作如下修改。
      // 移除'with DiagnosticableMixin'或者将'DiagnosticableMixin'改成'Diagnosticable'.
      pickerTheme: DateTimePickerTheme(
          showTitle: true,
          confirm: Text(S.current.confirm, style: const TextStyle(color: Colors.red)),
          cancel: Text(S.current.cancel,style:const TextStyle(color:Colors.cyan))
      ),

      minDateTime: DateTime.parse("1923-01-01"),
      maxDateTime: DateTime.parse("2023-01-01"),

      initialDateTime: _dateTime,


      // 显示日期
      dateFormat: "yyyy-MMMM-dd",

      // 显示日期与时间
      //dateFormat:'yyyy年M月d日',  // show TimePicker
      pickerMode: DateTimePickerMode.date,  // show TimePicker


      locale: DateTimePickerLocale.zh_cn,

      onChange: (dateTime, List<int> index) {
        setState(() {
          // 初始及修改保存后的时间
          _dateTime = dateTime;
        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          // 初始及修改保存后的时间
          _dateTime = dateTime;

          String year = dateTime.year.toString();
          String month = dateTime.month.toString();
          String day = dateTime.day.toString();
          if(dateTime.month < 10)
          {
            month = "0$month";
          }
          if(dateTime.day < 10)
          {
            day = "0$day";
          }

          _menstruationParaSetModel.recentlyMenstrual = '$year-$month-$day';


        });
      },
    );

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





