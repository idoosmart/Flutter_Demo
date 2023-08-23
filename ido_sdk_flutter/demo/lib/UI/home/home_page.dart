import 'package:flutter/material.dart';
import 'package:flutter_bluetooth/ido_bluetooth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:protocol_lib/protocol_lib.dart';
import '../home/home_content.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    EasyLoading.instance
      ..maskType = EasyLoadingMaskType.black
      ..loadingStyle = EasyLoadingStyle.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demo"),
        leading: IconButton(
          icon: const Icon(Icons.stop_circle),
          onPressed: () => bluetoothManager.stopScan(),
        ),
      ),
      body: const SizedBox(
        height: double.infinity,
        child: HomeContent(),
      ),
      floatingActionButton: ElevatedButton(
        style: TextButton.styleFrom(backgroundColor: Colors.red),
        onPressed: () {
          bluetoothManager.startScan();
        },
        child: const Icon(
          Icons.refresh,
        ),
      ),
    );
  }
}
