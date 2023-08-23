import 'dart:convert';
import 'dart:typed_data';

extension ListAlexaToUint8List on List<String> {
  Uint8List toData() {
    final bytes = <int>[];
    forEach((e) {
      bytes.addAll(utf8.encode(e));
    });
    return Uint8List.fromList(bytes);
  }
}
