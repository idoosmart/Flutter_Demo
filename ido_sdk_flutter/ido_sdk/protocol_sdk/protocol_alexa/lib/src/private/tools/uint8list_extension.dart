import 'dart:convert';
import 'dart:typed_data';

extension Uint8ListExt on Uint8List {
  /// 数据分割
  List<Uint8List> split(String separator) {
    // 将分隔符字符串转换为字节数据
    final separatorBytes = Uint8List.fromList(separator.codeUnits);

    // 存储结果列表
    final result = <Uint8List>[];

    var start = 0;

    // 查找分隔符在 Uint8List 中的位置
    for (var i = 0; i < length - separatorBytes.length + 1; i++) {
      var found = true;

      // 检查当前位置是否是分隔符的起始位置
      for (var j = 0; j < separatorBytes.length; j++) {
        if (this[i + j] != separatorBytes[j]) {
          found = false;
          break;
        }
      }

      // 如果找到分隔符，将从上一个分隔符到当前分隔符之间的数据作为一个子列表添加到结果列表中
      if (found) {
        result.add(sublist(start, i));
        start = i + separatorBytes.length;
        i += separatorBytes.length - 1;
      }
    }

    // 添加最后一个子列表
    if (start < length) {
      result.add(sublist(start));
    }

    return result;
  }

  /// 清除前后字符
  Uint8List trim(String char) {
    if (char.length > length) {
      return this;
    }

    var start = 0;
    var end = length - 1;
    final charByte = Uint8List.fromList(utf8.encode(char));

    while (start <= end &&
        __listEquals(sublist(start, start + charByte.length), charByte)) {
      start += charByte.length;
    }

    while (end >= start + charByte.length &&
        __listEquals(sublist(end - charByte.length + 1, end + 1), charByte)) {
      end -= charByte.length;
    }

    return sublist(start, end + 1);
  }

  /// 查找字符串所在的区间
  /// reverse 是否返回查找 默认为false
  Range? rangeOf(String char, [bool reverse = false]) {
    if (char.length > length) {
      return null;
    }

    final charByte = Uint8List.fromList(utf8.encode(char));
    var start = -1;

    if (reverse) {
      for (var i = length - charByte.length; i >= 0; i--) {
        if (__listEquals(sublist(i, i + charByte.length), charByte)) {
          start = i;
          break;
        }
      }
    } else {
      for (var i = 0; i < length - charByte.length; i++) {
        if (__listEquals(sublist(i, i + charByte.length), charByte)) {
          start = i;
          break;
        }
      }
    }

    if (start >= 0) {
      return Range(start, start + charByte.length);
    }
    return null;
  }

  /// 获取指定区间数据
  Uint8List? sublistWithRange(Range range) {
    if (range.start < 0 ||
        range.end < 0 ||
        range.end <= range.start ||
        range.end > length) {
      return null;
    }
    return sublist(range.start, range.end);
  }

  /// 根据字符串获取区间数据
  Uint8List? sublistWithString(String begin, String end, {bool reverse = true}) {
    final rangeBegin = rangeOf(begin);
    final rangeEnd = rangeOf(end, reverse);
    if (rangeBegin == null ||
        rangeEnd == null ||
        rangeBegin.start >= rangeEnd.end) {
      return null;
    }
    return sublist(rangeBegin.end, rangeEnd.start);
  }

  /// 比对两数组
  bool __listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) {
      return b == null;
    }
    if (b == null || a.length != b.length) {
      return false;
    }
    if (identical(a, b)) {
      return true;
    }
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) {
        return false;
      }
    }
    return true;
  }

  /// 判断给定的 Uint8List 数据是否为有效的 PCM 格式
  bool isValidPCM(Uint8List data, {int bitDepth = 16, int numChannels = 2}) {
    // PCM 数据至少需要 bitDepth/8 * numChannels 字节
    if (data.length < (bitDepth ~/ 8) * numChannels) {
      return false;
    }

    // 对于 16 位深度的 PCM 数据，每个采样都是 2 字节
    if (bitDepth == 16) {
      // 数据长度必须是 2 的整数倍
      if (data.length % 2 != 0) {
        return false;
      }
    } else if (bitDepth == 8) {
      // 对于 8 位深度的 PCM 数据，每个采样都是 1 字节
      // 无需额外检查，因为 data.length 已经是正整数
    } else {
      // 不支持的位深度
      return false;
    }

    // 检查声道数是否有效
    if (numChannels < 1) {
      return false;
    }

    return true;
  }
}

class Range {
  int start = 0;
  int end;
  Range(this.start, this.end);

  @override
  String toString() {
    return 'Range{start: $start, end: $end}';
  }
}
