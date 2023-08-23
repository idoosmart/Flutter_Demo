// 设置日程提醒


import 'package:flutter/material.dart';
import 'package:event_bus/event_bus.dart';
import '../../../generated/l10n.dart';
import '../../common/common.dart';
import 'information_set_model.dart';
import '../../pickers/pickers.dart';
import '../../pickers/style/default_style.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'dart:async';
import '../../common/commonTool.dart';
import '../../common/Toast.dart';
import 'package:protocol_lib/protocol_lib.dart';
import 'dart:convert';


class CustomEvent {
  SchedulerReminderModel msgModel;
  CustomEvent(this.msgModel);
}
EventBus eventBus = new EventBus();


typedef OnSelect = void Function(Object o);


class SchedulerReminderSet extends StatelessWidget {
  final String navTitle;


  SchedulerReminderSet({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),



      body: const SchedulerReminderSetContent(),
    );
  }
}


class SchedulerReminderSetContent extends StatefulWidget {
  const SchedulerReminderSetContent({Key? key}) : super(key: key);

  @override
  State<SchedulerReminderSetContent> createState() => SchedulerReminderSetContentState();
}




class SchedulerReminderSetContentState extends State<SchedulerReminderSetContent> {

  SchedulerReminderSetModel _scheduleReminderSetModel =  SchedulerReminderSetModel();


  List<String> leftList = [S.current.connected,S.current.operation,
    S.current.versionnum, S.current.addschedule,
    S.current.setup, ];

  // 操作的选择列表
  List<String> opList = [S.current.invalid,S.current.add,S.current.delete,
    S.current.select,S.current.update];

  late StreamSubscription subscription;

  void _updateInformation() {
    setState(() {

      //_counter++;
    });
  }
  
  @override
  void initState() {

    //监听CustomEvent事件，刷新UI
    subscription = eventBus.on<CustomEvent>().listen((event) {
      print(event);
      setState(() {
        _scheduleReminderSetModel.schedulerList.add(event.msgModel);
      });
    });
    
    
    // TODO: implement initState
    super.initState();
  }
  
  
  @override
  void dispose() {
    
    subscription.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (BuildContext ctx, int index) {
        return createCell(index);
      },


      itemCount: leftList.length + _scheduleReminderSetModel.schedulerList.length ,
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
    else if (tInt == 1) {   // 操作
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt], opList[_scheduleReminderSetModel.operate] ], (o) {
        print('object=====');

        dealwithPointerUp( leftList[tInt] ,opList[_scheduleReminderSetModel.operate], (o) {

          _scheduleReminderSetModel.operate = int.parse(o.toString());
          _updateInformation();
        });
      });
    }
    else if (tInt == 2) {  // 版本号
      return commonUI.productionWidget(WidType.textTextField, [leftList[tInt],_scheduleReminderSetModel.version.toString()], (o) {
        print('object=====');



      });
    }
    else if (tInt == leftList.length + _scheduleReminderSetModel.schedulerList.length  - 1 || tInt == leftList.length + _scheduleReminderSetModel.schedulerList.length - 2) {
      return commonUI.productionWidget(WidType.buttonInfo, [leftList[tInt - _scheduleReminderSetModel.schedulerList.length]], (o) {
        if (o.toString() == S.current.addschedule) {   // 添加日程
          Navigator.push(context, MaterialPageRoute(builder: (context)=>  SchedulerReminder(navTitle: o.toString(),)  ));
        }
        else{  // 设置

          TestCmd e = TestCmd(cmd: CmdEvtType.setSchedulerReminderV3, name: o.toString(), json: _scheduleReminderSetModel.toMap()   );
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


        }

      });
    }
    else {

      SchedulerReminderModel conModel = _scheduleReminderSetModel.schedulerList[tInt - 3];
      String astr =  '${conModel.schdulerId}:${conModel.title}';
      return commonUI.productionWidget(WidType.textSingleShow, [astr], (o) { });
      
    }


    return const Text('test');
  }



  //处理相关的弹框需求
  Future<void> dealwithPointerUp(String tinStr, String conStr,OnSelect onSelect)
  async {
    if (tinStr == S.current.operation) {     // 操作
      Pickers.showSinglePicker(
        context,
        data: opList,
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

  }

}




class SchedulerReminder extends StatelessWidget {
  final String navTitle;


  const SchedulerReminder({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),
      body: const SchedulerReminderContent(),
    );
  }
}


class SchedulerReminderContent extends StatefulWidget {
  const SchedulerReminderContent({Key? key}) : super(key: key);

  @override
  State<SchedulerReminderContent> createState() => _SchedulerReminderContentState();
}

class _SchedulerReminderContentState extends State<SchedulerReminderContent> {

  SchedulerReminderModel _schedulerReminderModel = SchedulerReminderModel();

  // 状态码列表
  List<String> statusList = [S.current.invalid,S.current.deletestate,S.current.enablestate,];
  // 提醒类型列表
  List<String> reminderTypeList = [S.current.noremind,S.current.ontime,S.current.minutesinadvance5,
    S.current.minutesinadvance10,S.current.minutesinadvance30,S.current.hourinadvance1,
    S.current.dayinadvance1,];
  // 超过天数提醒类型
  List<String> futureTypeList = [S.current.sameday,S.current.dayinadvance1,S.current.dayinadvance2,
    S.current.dayinadvance3,S.current.weekinadvance1];




  List<String> leftList = [S.current.connected,
    S.current.scheduleid,
    S.current.scheduletitle,
    S.current.schedulenote,
    S.current.dateinput,
    S.current.timeinput,
    S.current.statuscode,
    S.current.remindertype,
    S.current.futureremindtype,
    "space",
    S.current.monday,
    S.current.tuesday,
    S.current.wednesday,
    S.current.thursday,
    S.current.friday,
    S.current.saturday,
    S.current.sunday,
    S.current.addschedule,
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
    else if (tInt == 1) {   // 日程提醒id
      return commonUI.productionWidget(WidType.textTextField, [leftList[tInt], _schedulerReminderModel.schdulerId.toString()], (o) {

      });
    }
    else if (tInt == 2 )    // 标题
        {
      return commonUI.productionWidget(WidType.textTextField, [leftList[tInt],_schedulerReminderModel.title.toString(),'1'], (o) {
        _schedulerReminderModel.title = o.toString();

      });
    }
    else if (tInt == 3 )    // 备注
        {
      return commonUI.productionWidget(WidType.textTextField, [leftList[tInt],_schedulerReminderModel.remark.toString(),'1'],
              (o) {
            _schedulerReminderModel.remark = o.toString();
          });
    }
    else if (tInt == 4)    // 日期（年月日）
        {
      return commonUI.productionWidget(WidType.textDate, [leftList[tInt], _schedulerReminderModel.dateString ], (o) {
        _showDatePicker();
        _updateInformation();
      });
    }
    else if (tInt == 5)  // 时间（时分秒）
        {
      return commonUI.productionWidget(WidType.textThreeText, [leftList[tInt],_schedulerReminderModel.hour.toString(),
        _schedulerReminderModel.minute.toString(),_schedulerReminderModel.second.toString() ], (o) {
        final typeStr = o.toString();

        if (typeStr == 'hour') {
          dealwithPointerUp(typeStr, _schedulerReminderModel.hour.toString(), (o) {
            _schedulerReminderModel.hour = int.parse(o.toString());
            _updateInformation();
          });
        }
        else if (typeStr == 'minute'){
          dealwithPointerUp(typeStr, _schedulerReminderModel.minute.toString(), (o) {
            _schedulerReminderModel.minute = int.parse(o.toString());
            _updateInformation();
          });
        }
        else if (typeStr == 'second'){
          dealwithPointerUp(typeStr, _schedulerReminderModel.second.toString(), (o) {
            _schedulerReminderModel.second = int.parse(o.toString());
            _updateInformation();
          });
        }
      });
    }
    else if (tInt == 6)  // 状态码
        {
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt],statusList[_schedulerReminderModel.stateCode]], (o) {
        dealwithPointerUp(leftList[tInt], statusList[_schedulerReminderModel.stateCode], (o) {
          _schedulerReminderModel.stateCode = int.parse(o.toString());
          _updateInformation();
        });
      });
    }
    else if (tInt == 7)  // 提醒类型
        {
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt],reminderTypeList[_schedulerReminderModel.remindType]], (o) {
        dealwithPointerUp(leftList[tInt], reminderTypeList[_schedulerReminderModel.remindType], (o) {
          _schedulerReminderModel.remindType = int.parse(o.toString());
          _updateInformation();
        });
      });
    }
    else if (tInt == 8)  // 超过天数提醒类型
        {
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt],futureTypeList[_schedulerReminderModel.exceedRemindType]], (o) {
        dealwithPointerUp(leftList[tInt], futureTypeList[_schedulerReminderModel.exceedRemindType], (o) {
          _schedulerReminderModel.exceedRemindType = int.parse(o.toString());
          _updateInformation();
        });
      });
    }
    else if (tInt == 9)  // space
        {
      return commonUI.productionWidget(WidType.spaceWidget, [], (o) { });
    }
    else if (tInt == leftList.length - 1)
    {
      // 添加日程
      return commonUI.productionWidget(WidType.buttonInfo, [leftList[tInt] ], (o) {
        print('object=====');
        eventBus.fire(CustomEvent(_schedulerReminderModel));
        Navigator.pop(context);
      });
    }
    else
    {
      bool pt = false;
      if (_schedulerReminderModel.weekList.contains(leftList[tInt])) {
        pt = true;
      }

      return commonUI.productionWidget(WidType.textSingle, [leftList[tInt],pt],
              (o) {
            print('--------${o.toString()}');
            String chStr = o.toString();
            if (_schedulerReminderModel.weekList.contains(chStr)) {
              _schedulerReminderModel.weekList.remove(chStr);
            }
            else{
              _schedulerReminderModel.weekList.add(chStr);
            }
            _updateInformation();
          });
    }



    return const Text('test');
  }


// 显示时间的方法
  void _showDatePicker(){
    String fstr = _schedulerReminderModel.dateString;
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

          _schedulerReminderModel.dateString = '$year-$month-$day';


        });
      },
    );

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
    else if (tinStr == 'second') {  // 秒
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
    else if (tinStr == S.current.statuscode) {  // 状态码
      Pickers.showSinglePicker(
        context,
        data: statusList,
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
    else if (tinStr == S.current.remindertype) {  // 提醒类型
      Pickers.showSinglePicker(
        context,
        data: reminderTypeList,
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
    else if (tinStr == S.current.futureremindtype) {  // 超过天数提醒类型
      Pickers.showSinglePicker(
        context,
        data: futureTypeList,
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


  }


}




