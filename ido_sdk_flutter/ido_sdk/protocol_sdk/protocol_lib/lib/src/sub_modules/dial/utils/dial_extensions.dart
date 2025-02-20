import 'dart:ui';

extension DailStringExt on String {
  String get assetsPath => 'packages/device_dial/assets/images/$this';

  bool isLocalDial() {
    return contains('local_');
  }

  ///转换为固件需要的颜色格式
  //#FF3333 转换为 0xFFFF3333
  String converToARGB() {
    if (length == 7) {
      return replaceAll('#', '0xFF');
    }
    return replaceAll('#', '0x');
  }

  Color parseColor() {
    final hexColor = replaceAll("#", "");
    int colorValue = int.parse(hexColor, radix: 16);
    return Color(colorValue).withOpacity(1.0);
  }

  ///转换RGB值为16进制的值
  int convertHexColorStringToInt() {
    var hexColor = this;
    if (length == 9) {
      hexColor = toUpperCase().replaceAll("#FF", "");
    }

    return int.parse(hexColor, radix: 16);
  }

}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

