package com.example.flutter_bluetooth.ble.callback;

import com.example.flutter_bluetooth.dfu.ConnectFailedReason;

/**
 * 设备连接状态的监听回调
 * <br/>
 * The callback for device connect state
 */
public interface ConnectCallBack {
    /**
     * 开始连接
     * <br/>
     * Start connect
     */
    void onConnectStart();

    /**
     * 连接中
     * <br/>
     * Connecting
     */
    void onConnecting();

    /**
     * 自动重连过程中，重连的次数
     *
     * @param count
     */
    void onRetry(int count);

    /**
     * 连接成功
     * <br/>
     * connect success
     */
    void onConnectSuccess();

    /**
     * 连接失败
     * <br/>
     * connect failed
     */
    void onConnectFailed(ConnectFailedReason failedReason);

    /**
     * 连接被断开
     * <br/>
     * connect break
     */
    void onConnectBreak();

    /**
     * 设备处于DFU模式
     * <br/>
     * device in dfu mode
     */
    void onInDfuMode();
}