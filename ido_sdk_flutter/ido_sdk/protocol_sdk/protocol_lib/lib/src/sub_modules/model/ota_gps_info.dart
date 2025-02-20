class OTAGpsInfo {
  ///	晶振偏移
  late int tcxoOffset = 0;
  /// 经度
  late int longitude = 0;
  /// 纬度
  late int latitude = 0;
  /// 海拔高度
  late int altitude = 0;

  OTAGpsInfo({required int tcxoOffset, required double longitude, required double latitude, required double altitude}) {
    tcxoOffset = tcxoOffset;
    this.longitude = (longitude * 1000000).toInt(); // （乘以 10^6）
    this.latitude = (latitude * 1000000).toInt(); //（乘以 10^6）
    this.altitude = (altitude * 10).toInt(); //（乘以 10）
  }

  String toJson() {
    // 晶振偏移未用到，暂时不忽略
    //return '{"tcxo_offset":$tcxoOffset,"longitude":$longitude,"latitude":$latitude,"altitude":$altitude}';
    return '{"longitude":$longitude,"latitude":$latitude,"altitude":$altitude}';
  }
}