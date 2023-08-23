// 设置服药记录

// setUpMedicationRecord


import 'package:flutter/material.dart';
import 'package:event_bus/event_bus.dart';
import '../../../generated/l10n.dart';
import '../../common/common.dart';
import 'information_set_model.dart';
import '../../pickers/pickers.dart';
import '../../pickers/style/default_style.dart';
import 'dart:async';


class CustomEvent {
  MedicationReminderModel msgModel;
  CustomEvent(this.msgModel);
}
EventBus eventBus = EventBus();


typedef OnSelect = void Function(Object o);


class MedicationRecordSet extends StatelessWidget {
  final String navTitle;


  const MedicationRecordSet({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),



      body: const MedicationRecordSetContent(),
    );
  }
}


class MedicationRecordSetContent extends StatefulWidget {
  const MedicationRecordSetContent({Key? key}) : super(key: key);

  @override
  State<MedicationRecordSetContent> createState() => MedicationRecordSetContentState();
}




class MedicationRecordSetContentState extends State<MedicationRecordSetContent> {

  final MedicationReminderSetModel _medicationReminderSetModel =  MedicationReminderSetModel();


  List<String> leftList = [S.current.connected,S.current.AddMedicationReminder,
    S.current.setUpMedicationReminder,];



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
        _medicationReminderSetModel.medicationReminderList.add(event.msgModel);
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


      itemCount: leftList.length + _medicationReminderSetModel.medicationReminderList.length ,
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

    else if (tInt == leftList.length + _medicationReminderSetModel.medicationReminderList.length  - 1 || tInt == leftList.length +  _medicationReminderSetModel.medicationReminderList.length - 2) {
      return commonUI.productionWidget(WidType.buttonInfo, [leftList[tInt -  _medicationReminderSetModel.medicationReminderList.length]], (o) {
        if (o.toString() == S.current.AddMedicationReminder) {   // 添加服药提醒
          Navigator.push(context, MaterialPageRoute(builder: (context)=>  MedicationRecord(navTitle: o.toString(),)  ));
        }


      });
    }
    else {

      MedicationReminderModel conModel = _medicationReminderSetModel.medicationReminderList[tInt - 1];
      String weekStr = '';
      for(int i = 0;i< conModel.weekList.length;i++){
        weekStr += conModel.weekList[i];
      }
      print('=====$weekStr');
      String astr =  '${S.current.medicationReminder}\n ${S.current.time} ${conModel.startHour}:${conModel.startMinute}\n ${S.current.repeat}:$weekStr';
      print('=====$astr');

      return commonUI.productionWidget(WidType.textSingleShow, [astr], (o) { });

    }

    return const Text('test');
  }

}




class MedicationRecord extends StatelessWidget {
  final String navTitle;

  const MedicationRecord({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),
      body: const MedicationRecordContent(),
    );
  }
}


class MedicationRecordContent extends StatefulWidget {
  const MedicationRecordContent({Key? key}) : super(key: key);

  @override
  State<MedicationRecordContent> createState() => _MedicationRecordContentState();
}

class _MedicationRecordContentState extends State<MedicationRecordContent> {

  MedicationReminderModel _medicationReminderModel = MedicationReminderModel();


  List<String> leftList = [S.current.connected,
    S.current.takeMedicineReminderSwitch,
    S.current.setintervallength,
    S.current.setstarttime,
    S.current.setendtime,
    S.current.nodisturbSwitch,
    S.current.nodisturbStartTime,
    S.current.nodisturbStopTime,
    "space",
    S.current.monday,
    S.current.tuesday,
    S.current.wednesday,
    S.current.thursday,
    S.current.friday,
    S.current.saturday,
    S.current.sunday,
    S.current.editorTakeMedicineReminder,
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
    else if (tInt == 1) {   // 吃药提醒开关
      return commonUI.productionWidget(WidType.textSwitch, [leftList[tInt], _medicationReminderModel.takeMedicineReminderSwitch.toString()], (o) {
        String sValue = o.toString();
        print('textSwitch----${sValue}');
        sValue == 'true'?_medicationReminderModel.takeMedicineReminderSwitch = true:_medicationReminderModel.takeMedicineReminderSwitch = false;
        _updateInformation();
      });
    }
    else if (tInt == 2 )    // 设置分钟间隔时长
        {
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt],_medicationReminderModel.setMinuteIntervallength.toString()], (o) {
        dealwithPointerUp(leftList[tInt], _medicationReminderModel.setMinuteIntervallength.toString(), (o) {
          _medicationReminderModel.setMinuteIntervallength = int.parse(o.toString());
          _updateInformation();
        });

      });
    }
    else if (tInt == 3 )    // 设置开始时间
        {
      return commonUI.productionWidget(WidType.textTwoText, [leftList[tInt],_medicationReminderModel.startHour.toString(),_medicationReminderModel.startMinute.toString()],
              (o) {
            if (o.toString() == 'hour') {
              dealwithPointerUp(o.toString(), _medicationReminderModel.startHour.toString(), (o) {
                _medicationReminderModel.startHour = int.parse(o.toString());
                _updateInformation();
              });
            }
            else if (o.toString() == 'minute'){
              dealwithPointerUp(o.toString(), _medicationReminderModel.startMinute.toString(), (o) {
                _medicationReminderModel.startMinute = int.parse(o.toString());
                _updateInformation();
              });
            }

          });
    }
    else if (tInt == 4)    // 设置结束时间
        {
      return commonUI.productionWidget(WidType.textTwoText, [leftList[tInt],_medicationReminderModel.stopHour.toString(),_medicationReminderModel.stopMinute.toString()],
              (o) {
            if (o.toString() == 'hour') {
              dealwithPointerUp(o.toString(), _medicationReminderModel.stopHour.toString(), (o) {
                _medicationReminderModel.stopHour = int.parse(o.toString());
                _updateInformation();
              });
            }
            else if (o.toString() == 'minute'){
              dealwithPointerUp(o.toString(), _medicationReminderModel.stopMinute.toString(), (o) {
                _medicationReminderModel.stopMinute = int.parse(o.toString());
                _updateInformation();
              });
            }

          });
    }
    else if (tInt == 5)  // 勿扰开关
        {
      return commonUI.productionWidget(WidType.textSwitch, [leftList[tInt],_medicationReminderModel.nodisturbSwitch.toString(),], (o) {
        String sValue = o.toString();
        print('textSwitch----${sValue}');
        sValue == 'true'?_medicationReminderModel.nodisturbSwitch = true:_medicationReminderModel.nodisturbSwitch = false;
        _updateInformation();
      });
    }
    else if (tInt == 6)  // 勿扰开始时间
        {
      return commonUI.productionWidget(WidType.textTwoText, [leftList[tInt],_medicationReminderModel.nodisturbStartHour.toString(),_medicationReminderModel.nodisturbStartMinute.toString()],
              (o) {
            if (o.toString() == 'hour') {
              dealwithPointerUp(o.toString(), _medicationReminderModel.nodisturbStartHour.toString(), (o) {
                _medicationReminderModel.nodisturbStartHour = int.parse(o.toString());
                _updateInformation();
              });
            }
            else if (o.toString() == 'minute'){
              dealwithPointerUp(o.toString(), _medicationReminderModel.nodisturbStartMinute.toString(), (o) {
                _medicationReminderModel.nodisturbStartMinute = int.parse(o.toString());
                _updateInformation();
              });
            }

          });
    }

    else if (tInt == 7)  // 勿扰结束时间
        {
      return commonUI.productionWidget(WidType.textTwoText, [leftList[tInt],_medicationReminderModel.nodisturbStopHour.toString(),_medicationReminderModel.nodisturbStopMinute.toString()],
              (o) {
            if (o.toString() == 'hour') {
              dealwithPointerUp(o.toString(), _medicationReminderModel.nodisturbStopHour.toString(), (o) {
                _medicationReminderModel.nodisturbStopHour = int.parse(o.toString());
                _updateInformation();
              });
            }
            else if (o.toString() == 'minute'){
              dealwithPointerUp(o.toString(), _medicationReminderModel.nodisturbStopMinute.toString(), (o) {
                _medicationReminderModel.nodisturbStopMinute = int.parse(o.toString());
                _updateInformation();
              });
            }

          });
    }

    else if (tInt == 8)  // space
        {
      return commonUI.productionWidget(WidType.spaceWidget, [], (o) { });
    }
    else if (tInt == leftList.length - 1)
    {
      // 编辑吃药提醒
      return commonUI.productionWidget(WidType.buttonInfo, [leftList[tInt] ], (o) {
        print('object=====');
        eventBus.fire(CustomEvent(_medicationReminderModel));
        Navigator.pop(context);
      });
    }
    else
    {
      bool pt = false;
      if (_medicationReminderModel.weekList.contains(leftList[tInt])) {
        pt = true;
      }

      return commonUI.productionWidget(WidType.textSingle, [leftList[tInt],pt],
              (o) {
            print('--------${o.toString()}');
            String chStr = o.toString();
            if (_medicationReminderModel.weekList.contains(chStr)) {
              _medicationReminderModel.weekList.remove(chStr);
            }
            else{
              _medicationReminderModel.weekList.add(chStr);
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
    else if (tinStr == S.current.setintervallength) {  //  设置分钟间隔时长
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




