import 'package:flutter/material.dart';
import 'package:flutter_bluetooth/ido_bluetooth.dart';
import '../function/function_index.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List<IDOBluetoothDeviceModel> devices = [];

  @override
  void initState() {
    super.initState();
    // 扫描设备
    bluetoothManager.scanResult().listen((event) {
      setState(() {
        devices = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext ctx, int index) {
        final device = devices[index];
        return ElevatedButton(
          child:  Column(
            children: [
              Text(
                "${device.name}" ,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                device.macAddress ?? "",
                style: const TextStyle(color: Colors.red, fontSize: 15),
              ),
            ],
          ),
          onPressed: ()=>jumpDetail(device),
        );
      },
      itemCount: devices.length,
      // itemExtent: 70,
    );
  }

  jumpDetail(IDOBluetoothDeviceModel device){
    print("jumpDetail ${device.name}, ${device.macAddress}");
    Navigator.push(context, MaterialPageRoute(builder: (context)=>FunctionIndex(device)));
  }
}
