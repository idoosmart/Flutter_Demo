import 'dart:convert';
import 'dart:typed_data';

import 'string_extension.dart';

extension MapAlexaToUint8List on Map<String, dynamic> {
  Uint8List toData() {
    return jsonEncode(this).toData();
  }
  String toJsonString() {
    return jsonEncode(this);
  }
}
