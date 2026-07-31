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
    bluetoothManager.scanResult().listen((event) {
      if (!mounted) return;
      setState(() {
        devices = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (devices.isEmpty) {
      return const Center(
        child: Text('点击右下角刷新开始扫描'),
      );
    }
    return ListView.builder(
      itemBuilder: (BuildContext ctx, int index) {
        final device = devices[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            title: Text(
              device.name ?? '',
              style: const TextStyle(fontSize: 18),
            ),
            subtitle: Text(
              device.macAddress ?? '',
              style: const TextStyle(color: Colors.red, fontSize: 15),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => jumpDetail(device),
          ),
        );
      },
      itemCount: devices.length,
    );
  }

  jumpDetail(IDOBluetoothDeviceModel device) {
    print("jumpDetail ${device.name}, ${device.macAddress}");
    bluetoothManager.stopScan();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FunctionIndex(device)),
    );
  }
}
