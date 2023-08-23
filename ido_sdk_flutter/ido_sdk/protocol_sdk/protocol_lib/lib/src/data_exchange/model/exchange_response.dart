import 'base_exchange_model.dart';

/// 数据交换响应
class ExchangeResponse<T> {
  ///错误码
  int code = -1;
  ///交换数据模型
  IDOBaseExchangeModel? model;
}