
import 'package:protocol_lib/protocol_lib.dart';

import '../private/logger/logger.dart';

part 'inner/indicator_point_impl.dart';

abstract class IndicatorPoint {
  factory IndicatorPoint() => _IndicatorPoint();
  setIndicator();
  clearIndicator();
}