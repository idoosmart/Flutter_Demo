///
/// @author davy
/// @date 2025/6/19 16:13
/// @description:
///
typedef IDOBluetoothBindStateDelegate = bool Function(String macAddress);


typedef IDOBluetoothBindStateAsyncDelegate = Future<bool> Function(String macAddress);

/// 拦截自动连接
typedef IDOBluetoothAutoConnectInterceptor = Future<bool> Function(String macAddress);
