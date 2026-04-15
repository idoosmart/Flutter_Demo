package com.idosmart.bluetooth.bt.spp;

public interface ISPPConnectStateListener {
    void onStart(String deviceAddress);
    void onSuccess(String deviceAddress);
    void onFailed(String deviceAddress);
    void onBreak(String deviceAddress);
}
