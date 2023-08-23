import 'dart:typed_data';
import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart' as pkg_ffi;

extension Int8ListBlobConversion on Int8List {
  ffi.Pointer<ffi.Int8> allocatePointer() {
    final blob = pkg_ffi.calloc<ffi.Int8>(length);
    final blobBytes = blob.asTypedList(length);
    blobBytes.setAll(0, this);
    return blob;
  }
}