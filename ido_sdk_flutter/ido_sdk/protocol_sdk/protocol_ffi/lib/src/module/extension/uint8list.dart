import 'dart:typed_data';
import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart' as pkg_ffi;

extension Uint8ListBlobConversion on Uint8List {
  ffi.Pointer<ffi.Uint8> allocatePointer() {
    final blob = pkg_ffi.calloc<ffi.Uint8>(length);
    final blobBytes = blob.asTypedList(length);
    blobBytes.setAll(0, this);
    return blob;
  }
}
