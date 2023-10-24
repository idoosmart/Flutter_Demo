part of '../identity_log_report.dart';

class _IdentityLogReport implements IdentityLogReport {
  String? lastVolume;

  //每小时上传一次
  void userInactivityReport({required int inactiveTimeInSeconds}) async {
    String uuid = DataBox.kUUID;
    final map = {
      "event": {
        "header": {
          "namespace": "System",
          "name": "UserInactivityReport",
          "messageId": uuid
        },
        "payload": {"inactiveTimeInSeconds": inactiveTimeInSeconds}
      }
    };

    logger?.v('commonUpdateReport alexaIdleMoreThan1hNotify , jsonStr: ${map}');

    Uint8List userInactivityReportByte = map.toData();

    if (Auth().accessToken != null) {
      final rs = await ServiceManager().sendEventPart(
          accessToken: Auth().accessToken!, dataBody: userInactivityReportByte, label: 'userInactivityReport');

      logger?.v('userInactivity commonUpdateReport error = ${rs.toString()}');
    }else{
      logger?.v('userInactivity commonUpdateReport error = token = null');
    }
  }

  //固件版本上报
  void userSoftwareInfoReport() async {

    String firmwareVersionStr = libManager.deviceInfo.getDeviceOtaVersion();
    String firmwareVersionStrV = firmwareVersionStr.replaceAll(".", ""); // 去除小数点

    if (firmwareVersionStrV != null && int.parse(firmwareVersionStrV) > 0){
      String uuid = DataBox.kUUID;

      final map = {
        "event": {
          "header": {
            "namespace": "System",
            "name": "SoftwareInfo",
            "messageId": uuid
          },
          "payload": {"firmwareVersion": firmwareVersionStrV}
        }
      };

      logger?.v('commonUpdateReport firmwareRebootNotify --> ${firmwareVersionStrV} , jsonStr: ${map}');

      Uint8List softwareInfoByte = map.toData();

      if (Auth().accessToken != null) {
        final rs = await ServiceManager().sendEventPart(
            accessToken: Auth().accessToken!, dataBody: softwareInfoByte, label: 'userSoftwareInfoReport');
        logger?.v('softwareVersion commonUpdateReport error = ${rs.toString()}');
      }else{
        logger?.v('softwareVersion commonUpdateReport error = token = null');
      }

    }else{
      logger?.v('commonUpdateReport firmwareRebootNotify --> ${firmwareVersionStr} ');
    }
  }

  //固件音量变化上报
  void volumeChangedInfoReport({required String volumeJsonStr}) async {

     final volumeMap = jsonDecode(volumeJsonStr!);
     int volume = volumeMap['value'];

    if (lastVolume != null ) {
      if (lastVolume!.length > 0 && int.parse(lastVolume!) != volume) {
        volumeChangedInfoReportToAlexa(volume: volume);
      }
    }else if (lastVolume == null){
        volumeChangedInfoReportToAlexa(volume: volume);
    }
    lastVolume = volume.toString();
    if (volume == 0){
      lastVolume = "0";
    }
  }

  //固件音量变化上报
  void volumeChangedInfoReportToAlexa({required int volume}) async {

    String uuid = DataBox.kUUID;
    final map = {
      "event": {
        "header": {
          "namespace": "Speaker",
          "name": "VolumeChanged",
          "messageId": uuid
        },
        "payload": {"volume": (volume), "muted": (0)}
      }
    };

    logger?.v('commonUpdateReport alexaFirmwareVolume = ${volume} , jsonStr: ${map}');

    Uint8List volumeChangedByte = map.toData();

    if (Auth().accessToken != null) {
      final rs = await ServiceManager().sendEventPart(
          accessToken: Auth().accessToken!, dataBody: volumeChangedByte, label: 'volumeChangedInfoReport');

      logger?.v('volume commonUpdateReport error = ${rs.toString()}');
    }else{
      logger?.v('volume commonUpdateReport error = token = null');
    }

  }

}
