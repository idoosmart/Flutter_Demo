// 设置APP通知状态


import 'package:flutter/material.dart';
import 'package:event_bus/event_bus.dart';
import '../../../generated/l10n.dart';
import '../../common/common.dart';
import 'information_set_model.dart';
import '../../pickers/pickers.dart';
import '../../pickers/style/default_style.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'dart:async';



class CustomEvent {
  AppNotifyStatusModel msgModel;
  CustomEvent(this.msgModel);
}
EventBus eventBus = EventBus();


typedef OnSelect = void Function(Object o);


class AppNotifyStatusSet extends StatelessWidget {
  final String navTitle;


  AppNotifyStatusSet({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),



      body: const AppNotifyStatusSetContent(),
    );
  }
}


class AppNotifyStatusSetContent extends StatefulWidget {
  const AppNotifyStatusSetContent({Key? key}) : super(key: key);

  @override
  State<AppNotifyStatusSetContent> createState() => AppNotifyStatusSetContentState();
}




class AppNotifyStatusSetContentState extends State<AppNotifyStatusSetContent> {

  AppNotifyStatusSetModel _appNotifyStatusSetModel =  AppNotifyStatusSetModel();


  List<String> leftList = [S.current.connected,S.current.operation,
    S.current.versionnum,S.current.addappnotify,
    S.current.setup, ];



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
        _appNotifyStatusSetModel.notifyList.add(event.msgModel);
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


      itemCount: leftList.length + _appNotifyStatusSetModel.notifyList.length ,
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
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt], S.current.add ], (o) {
        print('object=====');


      });
    }
    else if (tInt == 2) {  // 版本号
      return commonUI.productionWidget(WidType.textTextField, [leftList[tInt],_appNotifyStatusSetModel.version.toString()], (o) {
        print('object=====');
        _appNotifyStatusSetModel.version = int.parse(o.toString());

      });
    }
    else if (tInt == leftList.length + _appNotifyStatusSetModel.notifyList.length  - 1 || tInt == leftList.length + _appNotifyStatusSetModel.notifyList.length - 2) {
      return commonUI.productionWidget(WidType.buttonInfo, [leftList[tInt - _appNotifyStatusSetModel.notifyList.length]], (o) {
        if (o.toString() == S.current.addappnotify) {   // 添加App通知
          Navigator.push(context, MaterialPageRoute(builder: (context)=>  AppNotifyStatus(navTitle: o.toString(),)  ));
        }


      });
    }
    else {

      AppNotifyStatusModel conModel = _appNotifyStatusSetModel.notifyList[tInt - 3];
      String astr =  conModel.eventType.toString();
      return commonUI.productionWidget(WidType.textSingleShow, [astr], (o) { });

    }


    return const Text('test');
  }



  // //处理相关的弹框需求
  // Future<void> dealwithPointerUp(String tinStr, String conStr,OnSelect onSelect)
  // async {
  //   if (tinStr == S.current.operation) {     // 操作
  //     Pickers.showSinglePicker(
  //       context,
  //       data: opList,
  //       selectData: conStr,
  //       pickerStyle: DefaultPickerStyle(),
  //       onConfirm: (p, position) {
  //         onSelect(position);
  //       },
  //       onChanged: (p, position) {
  //         print('longer >>> 返回数据下标：$position');
  //         print('数据发生改变：$p');
  //       },
  //     );
  //   }
  //
  // }

}




class AppNotifyStatus extends StatelessWidget {
  final String navTitle;


  const AppNotifyStatus({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),
      body: const AppNotifyStatusContent(),
    );
  }
}


class AppNotifyStatusContent extends StatefulWidget {
  const AppNotifyStatusContent({Key? key}) : super(key: key);

  @override
  State<AppNotifyStatusContent> createState() => _AppNotifyStatusContentState();
}

class _AppNotifyStatusContentState extends State<AppNotifyStatusContent> {

  AppNotifyStatusModel _appNotifyStatusModel = AppNotifyStatusModel();

  // 通知状态
  List<String> notiStatusList = [S.current.allownotifyflag,S.current.silencenotifyflag,S.current.closenotifyflag,];

  List<String> leftList = [S.current.connected,
    S.current.eventtype,
    S.current.notificationstatus,
    S.current.setup,
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
    else if (tInt == 1) {   // 事件类型
      return commonUI.productionWidget(WidType.textTextField, [leftList[tInt], _appNotifyStatusModel.eventType.toString()], (o) {
        _appNotifyStatusModel.eventType = int.parse(o.toString());
      });
    }
    else if (tInt == 2 )    // 通知状态
        {
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt], notiStatusList[_appNotifyStatusModel.notifyStatus]  ], (o) {
        dealwithPointerUp(leftList[tInt],  notiStatusList[_appNotifyStatusModel.notifyStatus] , (o) {


        });
      });
    }

    else if (tInt == leftList.length - 1)
    {
      // 添加日程
      return commonUI.productionWidget(WidType.buttonInfo, [leftList[tInt] ], (o) {
        print('object=====');
        eventBus.fire(CustomEvent(_appNotifyStatusModel));
        Navigator.pop(context);
      });
    }




    return const Text('test');
  }






  //处理相关的弹框需求
  Future<void> dealwithPointerUp(String tinStr,String conStr,OnSelect onSelect)
  async {
   if (tinStr == S.current.notificationstatus) {  // 通知状态
      Pickers.showSinglePicker(
        context,
        data: notiStatusList,
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




