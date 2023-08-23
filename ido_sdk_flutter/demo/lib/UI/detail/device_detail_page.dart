import 'package:flutter/material.dart';
import 'package:flutter_bluetooth/model/ido_bluetooth_device_model.dart';
import '../detail/device_detail_content.dart';

class DeviceDetailPage extends StatelessWidget {
  IDOBluetoothDeviceModel device;
  // const DeviceDetailPage({Key? key}) : super(key: key);
  DeviceDetailPage(this.device, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${device.name}"),),
      body: const DeviceDetailContent(),
    );
  }
}
