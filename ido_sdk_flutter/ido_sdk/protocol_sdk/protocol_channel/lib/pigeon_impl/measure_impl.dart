import 'package:protocol_lib/protocol_lib.dart';
import '../pigeon_generate/measure.g.dart';

class MeasureImpl extends Measure {
  final _delegate = MeasureDelegate();

  MeasureImpl() {
    _listenMeasure();
  }

  void _listenMeasure() {
    libManager.measure.listenProcessMeasureData().listen((event) {
      _delegate.listenMeasureResult(event.toMeasureResult());
    });
  }

  @override
  Future<MeasureResult> getMeasureData(MeasureType type) async {
    final res = await libManager.measure.getMeasureData(type.toIDOMeasureType());
    return res.toMeasureResult();
  }

  @override
  Future<bool> startMeasure(MeasureType type) {
    return libManager.measure.startMeasure(type.toIDOMeasureType());
  }

  @override
  Future<bool> stopMeasure(MeasureType type) {
    return libManager.measure.stopMeasure(type.toIDOMeasureType());
  }
}

extension MeasureTypeExt on MeasureType {
  IDOMeasureType toIDOMeasureType() {
    return IDOMeasureType.values[index];
  }
}

extension IDOMeasureStatusExt on IDOMeasureStatus {
  MeasureStatus toMeasureStatus() {
    return MeasureStatus.values[index];
  }
}

extension IDOMeasureResultExt on IDOMeasureResult {
  MeasureResult toMeasureResult() {
    return MeasureResult(
      status: status.toMeasureStatus(),
      systolicBp: systolicBp,
      diastolicBp: diastolicBp,
      value: value,
      oneClickHr: oneClickHr,
      oneClickStress: oneClickStress,
      oneClickSpo2: oneClickSpo2,
      temperatureValue: temperatureValue,
    );
  }
}
