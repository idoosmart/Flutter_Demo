// 运动子项数据排列


import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';
import '../../common/common.dart';
import 'information_set_model.dart';
import '../../pickers/pickers.dart';
import '../../pickers/style/default_style.dart';


typedef OnSelect = void Function(Object o);


class SportParamSort extends StatelessWidget {
  final String navTitle;


  SportParamSort({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),
      body: const SportParamSortContent(),
    );
  }
}


class SportParamSortContent extends StatefulWidget {
  const SportParamSortContent({Key? key}) : super(key: key);

  @override
  State<SportParamSortContent> createState() => SportParamSortContentState();
}




class SportParamSortContentState extends State<SportParamSortContent> {

  SportParamSortSetModel _sportParamModel =  SportParamSortSetModel();


  List<String> leftList = [S.current.connected,S.current.sporttype,
    S.current.currentsportindex, S.current.setup,];


  
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
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt],_sportParamModel.sportType.toString()], (o) {
        print('object=====');

        dealwithPointerUp(_sportParamModel.sportType.toString(), (o) {

          _sportParamModel.sportType = int.parse(o.toString());
          _updateInformation();
        });
      });
    }
    else if (tInt == 2) {
      return commonUI.productionWidget(WidType.textOneText, [leftList[tInt],_sportParamModel.showIndex.toString()], (o) {
        print('object=====');

        dealwithPointerUp(_sportParamModel.showIndex.toString(), (o) {
          _sportParamModel.showIndex = int.parse(o.toString());
          _updateInformation();
        });


      });
    }
    else if (tInt == leftList.length - 1) {
      return commonUI.productionWidget(WidType.buttonInfo, [leftList[tInt]], (o) { print('object====='); });
    }


    return const Text('test');
  }



  //处理相关的弹框需求
  Future<void> dealwithPointerUp(String conStr,OnSelect onSelect)
  async {
    
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





