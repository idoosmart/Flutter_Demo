import 'dart:async';

extension IDOCompleterExtension<T> on Completer<T> {
  void completeSafe(T value) {
    if (isCompleted) {
      return;
    }
    complete(value);
  }
}