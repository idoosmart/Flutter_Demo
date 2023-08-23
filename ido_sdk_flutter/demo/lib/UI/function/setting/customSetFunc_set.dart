// 定制设置功能

import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';
import '../../common/common.dart';
import '../../pickers/pickers.dart';
import '../../pickers/style/default_style.dart';


class CustomSetFunc extends StatelessWidget {
  // 数据源
  final List<String> listNames;
  // nav的名字
  final String navTitle;

  const CustomSetFunc({super.key, required this.listNames, required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createAppBar(),
      body: CustomSetFuncContent(listNames,navTitle),
    );


  }

  AppBar createAppBar() {
    if (navTitle == S.current.datamigration)
    {
      return AppBar(
        title: Text(navTitle),
        actions: [
          FloatingActionButton(
            onPressed: test(),
            child:  Text(S.current.selectedfiles),
          )
        ],
      );


    }
    else
    {
      return AppBar(
        title: Text(navTitle),
      );
    }
  }

  test() {}
}

class CustomSetFuncContent extends StatelessWidget {
  final String typeName;
  final List<String>? listNames;
  CustomSetFuncContent(this.listNames, this.typeName,{super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext ctx, int index) {
        if (index == 0) {
          return  Text(
            S.current.deviceConnected,
            style: const TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          );
        } else {
          final fName = listNames![index - 1];
          return ElevatedButton(
              child: Column(
                children: [
                  Text(
                    fName,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
              onPressed: () {jumpDetailCon(typeName, fName,context);}
          );
        }
      },
      itemCount: listNames!.length + 1,
      // itemExtent: 70,
    );
  }


// S.current.customsetfunc
  jumpDetailCon(String typeName,String conName,BuildContext context)
  {
    print('jumpDetailCon = ${typeName}==${conName}');
    //final nWidgets = setJumpMap[conName];
    Navigator.push(context, MaterialPageRoute(builder: (context)=>  CustomContentSet(navTitle: conName,)  ));
  }
}




Map<String,List<String>> paraMap =
{ S.current.setthenumberofstars:[S.current.connected,S.current.setthenumberofstars,S.current.setthenumberofstars],
  S.current.setmessagecontent:[S.current.connected,S.current.setmessagepush,S.current.setmessagepush],
  S.current.setusername:[S.current.connected,S.current.setusername,S.current.setusername],
  S.current.setusernumber:[S.current.connected,S.current.setusernumber,S.current.setusernumber],
  S.current.setweathercityname:[S.current.connected,S.current.setweathercityname,S.current.setweathercityname],
  S.current.synciotbutton:[S.current.connected,S.current.buttonname,S.current.addiotbutton],

  S.current.sendpromptmessage:[S.current.connected,S.current.setmessagepush,S.current.setmessagepush],
};

List<String> paList = paraMap[S.current.setthenumberofstars]!;


typedef OnSelect = void Function(Object o);

class CustomContentSet extends StatelessWidget {
  final String navTitle;


  const CustomContentSet({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {

    paList = paraMap[navTitle]!;

    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),
      body: const CustomDetailContent(),
    );
  }
}


class CustomDetailContent extends StatefulWidget {
  const CustomDetailContent({Key? key}) : super(key: key);

  @override
  State<CustomDetailContent> createState() => _CustomDetailContentState();
}

class _CustomDetailContentState extends State<CustomDetailContent> {



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

      itemCount: paList.length,
      //分割器构造器
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          color: Colors.blue,
        );
      },
    );
  }


  String tempStr = '1';

  Widget createCell(int tInt) {
    if (tInt == 0) {
      return commonUI.productionWidget(WidType.headTextInfo , [], (o) { });
    }
    else if (tInt == 1) {

      if (paList[tInt] == S.current.setthenumberofstars) {
        return commonUI.productionWidget(WidType.textOneText, [paList[tInt],tempStr], (o) {
          dealwithPointerUp(tempStr, (o) {
            tempStr = o.toString();
            _updateInformation();
          });
        });
      }
      else {
        return commonUI.productionWidget(WidType.textTextField, [paList[tInt],tempStr], (o) {


        });
      }
    }
    else {
      return commonUI.productionWidget(WidType.buttonInfo, [paList[tInt]],
              (o) {

            print('object=====${o}'); });
    }


  }



  //处理相关的弹框需求
  Future<void> dealwithPointerUp(String conStr,OnSelect onSelect)
  async {

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



