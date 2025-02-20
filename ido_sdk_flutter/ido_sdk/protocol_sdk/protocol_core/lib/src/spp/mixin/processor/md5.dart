import 'dart:io';

import 'package:crypto/crypto.dart';

String calculateMD5(File file) {
  return md5.convert(file.readAsBytesSync()).toString();
}
