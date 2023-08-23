
import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';


class FunctionControl extends StatelessWidget {
  // nav的名字
  final String navTitle;

  const FunctionControl({super.key,  required this.navTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text(navTitle),
      ),
      body: FunctionControlContent(navTitle),
    );
  }
}



class FunctionControlContent extends StatefulWidget {

  final String typeName;

  FunctionControlContent(this.typeName,{super.key});

  @override
  State<FunctionControlContent> createState() => _FunctionControlContentState(this.typeName);
}

class _FunctionControlContentState extends State<FunctionControlContent> {

  final String typeName;

  _FunctionControlContentState(this.typeName);


  Map<String, List<String>> typeMap = {S.current.photocontrol:[S.current.turnonthecamera,S.current.turnoffcamera],
    S.current.musiccontrol:[S.current.settingmusicopen,S.current.setmusicend],
    S.current.notificationcontrol:[S.current.openANCSnotification,S.current.closeANCSnotification],
    S.current.recoverycontrol:[S.current.settingdefaultconfiguration],
    S.current.rebootcontrol:[S.current.rebootdevice],
    S.current.factoryreset:[S.current.factoryreset],
    S.current.audiorecordcontrol:[S.current.audiorecordcontrol,S.current.alexatest],
  };

  @override
  Widget build(BuildContext context) {

    List<String> dataList = typeMap[typeName]!;

    return ListView.builder(
      itemBuilder: (BuildContext ctx, int index) {

          return ElevatedButton(
              child: Column(
                children: [
                  Text(
                    dataList[index],
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
              onPressed: () {  }
          );

      },
      itemCount: dataList.length,
      // itemExtent: 70,
    );
  }
}

