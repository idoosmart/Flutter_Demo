package com.example.flutter_bluetooth.bt.spp;

/**
 * @author tianwei
 * @date 2022/12/16
 * @time 14:13
 * 用途: spp数据监听
 */
public interface ISPPDataListener {
    /**
     * 接收到spp数据
     *
     * @param data
     * @param deviceAddress
     */
    void onSPPReceive(byte[] data, String deviceAddress);

    /**
     * spp数据写完成
     * @param deviceAddress
     */
    void onSPPSendOneDataComplete(String deviceAddress);
}
