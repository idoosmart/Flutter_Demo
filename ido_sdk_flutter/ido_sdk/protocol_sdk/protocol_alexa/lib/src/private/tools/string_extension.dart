import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart' as crypto;

const _kAlphabet =
    'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM0123456789';

extension StringAlexaExtension on String {
  String md5({bool toUpperCase = true}) {
    final str = crypto.md5.convert(utf8.encode(this)).toString();
    return toUpperCase ? str.toUpperCase() : str;
  }

  Uint8List toData() {
    return Uint8List.fromList(utf8.encode(this));
  }

  static String randomString({int len = 9}) {
    return List.generate(
        len, (index) => _kAlphabet[Random().nextInt(_kAlphabet.length)]).join();
  }
}
