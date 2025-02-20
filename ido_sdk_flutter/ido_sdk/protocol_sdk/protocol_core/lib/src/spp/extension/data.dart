import 'dart:typed_data';

extension ByteDataExt on ByteData {
  int getUint16Little(int byteOffset) {
    return getUint16(byteOffset, Endian.little);
  }

  int getUint32Little(int byteOffset) {
    return getUint32(byteOffset, Endian.little);
  }

  int oneByte(int byteOffset) {
    return getUint8(byteOffset);
  }

  int twoBytes(int byteOffset) {
    return getUint16Little(byteOffset);
  }

  int fourBytes(int byteOffset) {
    return getUint32Little(byteOffset);
  }
}

extension IntExt on int {
  Uint8List oneByte() {
    final byteData = ByteData(1);
    byteData.setUint8(0, this);
    return byteData.buffer.asUint8List();
  }

  Uint8List twoBytes() {
    final byteData = ByteData(2);
    byteData.setUint16(0, this, Endian.little);
    return byteData.buffer.asUint8List();
  }

  Uint8List fourBytes() {
    final byteData = ByteData(4);
    byteData.setUint32(0, this, Endian.little);
    return byteData.buffer.asUint8List();
  }

  String get toHexString =>toRadixString(16).padLeft(2,'0');
}

extension StringExt on String {
  Uint8List bytes() {
    return Uint8List.fromList(codeUnits);
  }
}
