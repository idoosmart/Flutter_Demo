// 设置个人信息
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'information_set_model.dart';
import '../../../generated/l10n.dart';
import '../../pickers/pickers.dart';
import '../../pickers/style/default_style.dart';
import '../../common/common.dart';
import '../../common/commonTool.dart';
import '../../common/Toast.dart';
import 'package:protocol_lib/protocol_lib.dart';
import 'dart:convert';




class InformationSet extends StatelessWidget {
  final String navTitle;

  const InformationSet({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),
      body: const InformationContent(),
    );
  }
}



class InformationContent extends StatefulWidget {
  const InformationContent({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _InformationContentState();
  }
}




enum SelectType { useridType, heightType, weightType }

class _InformationContentState extends State<InformationContent> {
  InformationSetModel _infoModel = InformationSetModel('-1','2000-01-01',true,175,65);

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

    itemCount: 8,
    //分割器构造器
    separatorBuilder: (BuildContext context, int index) {
      return const Divider(
        color: Colors.blue,
      );
    },
  );
}


// 生成相对应的内容
List<String> obainCellTextString(SelectType type)
{
  List<String> list = [];

  if (type == SelectType.useridType)
  {
    for(int i= 1;i<=100;i++)
    {
      list.add(i.toString());
    }
  }
  else if (type == SelectType.heightType)
  {
    for(int i= 100;i<=249;i++)
    {
      list.add(i.toString());
    }
  }
  else if (type == SelectType.weightType)
  {
    for(int i= 20;i<=199;i++)
    {
      list.add(i.toString());
    }
  }

  return list;
}






  
  
// 显示时间的方法
  void _showDatePicker(){
    String fstr = _infoModel.birthday;
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

          _infoModel.birthday = '$year-$month-$day';


        });
      },
    );

  }


//处理相关的弹框需求
Future<void> dealwithPointerUp(String conStr)
async {
  if(conStr == S.current.userid)           // userid
  {
    //int? type = await _showModalBottomSheet(SelectType.useridType);

    Pickers.showSinglePicker(
      context,
      data: obainCellTextString(SelectType.useridType),
      selectData: _infoModel.userId,
      pickerStyle: DefaultPickerStyle(),
      onConfirm: (p, position) {
        print('longer >>> 返回数据下标：$position');
        setState(() {
          _infoModel.userId = p;
        });
      },
      onChanged: (p, position) {
        print('longer >>> 返回数据下标：$position');
        print('数据发生改变：$p');
      },
    );


  }
  else if(conStr == S.current.birthday)    //生日
  {
     _showDatePicker();
  }
  else if(conStr == S.current.height)      //身高
  {
    Pickers.showSinglePicker(
      context,
      data: obainCellTextString(SelectType.heightType),
      selectData: _infoModel.height.toString(),
      pickerStyle: DefaultPickerStyle(),
      onConfirm: (p, position) {
        print('longer >>> 返回数据下标：$position');
        setState(() {
          _infoModel.height = int.parse(p);
        });
      },
      onChanged: (p, position) {
        print('longer >>> 返回数据下标：$position');
        print('数据发生改变：$p');
      },
    );
  }
  else if(conStr == S.current.weight)      //体重
  {
    Pickers.showSinglePicker(
      context,
      data: obainCellTextString(SelectType.weightType),
      selectData: _infoModel.weight.toString(),
      pickerStyle: DefaultPickerStyle(),
      onConfirm: (p, position) {
        print('longer >>> 返回数据下标：$position');
        setState(() {
          _infoModel.weight = int.parse(p);
        });
      },
      onChanged: (p, position) {
        print('longer >>> 返回数据下标：$position');
        print('数据发生改变：$p');
      },
    );
  }
}


  Widget createCell(int tInt) {
    if (tInt == 0) {
      return commonUI.productionWidget(WidType.headTextInfo , [], (o) { });
    }
    else if (tInt == 1) {
      return  Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Text(
          S.current.settingTheUserInformationheight),
      );
    }
    else if (tInt == 2) {
      return commonUI.productionWidget(WidType.textOneText, [S.current.userid, _infoModel.userId],
              (o) {
                dealwithPointerUp(o.toString());
              });
    }
    else if (tInt == 3) {
      return commonUI.productionWidget(WidType.textDate, [S.current.birthday, _infoModel.birthday],
              (o) {
                dealwithPointerUp(o.toString());
              });
    }
    else if (tInt == 4) {
      String gd = _infoModel.sexFlag?'1':'0';
      return commonUI.productionWidget(WidType.textGender, [S.current.gender,gd],
              (o) {
                if (o.toString() == '1')
                {
                  _infoModel.sexFlag = true;
                }
                else
                {
                  _infoModel.sexFlag = false;
                }
                _updateInformation();
              });

    }
    else if (tInt == 5) {
      return commonUI.productionWidget(WidType.textOneText, [S.current.height, _infoModel.height.toString() ],
              (o) {
            dealwithPointerUp(o.toString());
          });
    }
    else if (tInt == 6) {
      return commonUI.productionWidget(WidType.textOneText, [S.current.weight, _infoModel.weight.toString() ],
              (o) {
            dealwithPointerUp(o.toString());
          });

    }
    else if (tInt == 7) {

      return commonUI.productionWidget(WidType.buttonInfo, [S.current.setuserbutton],
              (o) {

        Map<String,dynamic> jsonMap = _infoModel.toMap();

        TestCmd e = TestCmd(cmd: CmdEvtType.setUserInfo, name: S.current.setuserbutton, json: jsonMap   );
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








}


