// 设置闹钟提醒

import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';
import '../../common/common.dart';



class AlarmRemindSet extends StatelessWidget {
  final String navTitle;

  const AlarmRemindSet({super.key, required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(navTitle),
      ),
      body: const AlarmRemindContent(),
    );
  }
}


class AlarmRemindContent extends StatefulWidget {
  const AlarmRemindContent({Key? key}) : super(key: key);

  @override
  State<AlarmRemindContent> createState() => _AlarmRemindContentState();
}

class _AlarmRemindContentState extends State<AlarmRemindContent> {

  void _updateInformation() {
    setState(() {

      //_counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (BuildContext ctx, int index) {
        return createCell(index,context);
      },

      itemCount: 2,
      //分割器构造器
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          color: Colors.blue,
        );
      },
    );
  }




  Widget createCell(int tInt ,BuildContext context) {
    if (tInt == 0) {
      return commonUI.productionWidget(WidType.headTextInfo , [], (o) { });
    }

    else if (tInt == 1) {
      return commonUI.productionWidget(WidType.buttonInfo, [S.current.addalarm],
              (o) {

                print('---');

                // Toast.show(context, msg: '111', duration: 1, toastPosition: ToastPosition.center, border:const Border() );
                // Fluttertoast.showToast(msg: '11');


              });
    }




    return const Text('test');
  }

}





