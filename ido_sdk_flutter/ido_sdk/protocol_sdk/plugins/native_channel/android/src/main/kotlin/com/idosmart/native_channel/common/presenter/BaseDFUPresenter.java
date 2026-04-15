package com.idosmart.native_channel.common.presenter;

import android.text.TextUtils;

import com.idosmart.native_channel.common.BleDFUConfig;
import com.idosmart.native_channel.nordic.NordicToFlutterImpl;
import com.idosmart.native_channel.pigeon_generate.api_nordic.NordicDFUState;


/**
 * Created by Zhouzj on 2017/12/26.
 *
 */

public class BaseDFUPresenter implements IBaseDFUPresenter {
    private long mStartTime = 0;
    private String mDeviceUniqueId;

    public BaseDFUPresenter(BleDFUConfig dfuConfig){
        if (dfuConfig != null && !TextUtils.isEmpty(dfuConfig.getDeviceId()) && !TextUtils.isEmpty(dfuConfig.getMacAddress())){
            mDeviceUniqueId = dfuConfig.getDeviceId() + dfuConfig.getMacAddress();
        }
    }

    @Override
    public void onPrepare() {
        mStartTime = System.currentTimeMillis();
        NordicToFlutterImpl.INSTANCE.onDFUStateChanged(NordicDFUState.PREPARE, "");
    }

    @Override
    public void onFailedByConfigParaError() {
        NordicToFlutterImpl.INSTANCE.onDFUStateChanged(NordicDFUState.FAILED, "Config parameter error");
    }

    @Override
    public void onFailedByOther() {
        NordicToFlutterImpl.INSTANCE.onDFUStateChanged(NordicDFUState.FAILED, "Unknown error");
    }


    @Override
    public void onCancel() {
        NordicToFlutterImpl.INSTANCE.onDFUStateChanged(NordicDFUState.CANCELLED, "");
    }

    @Override
    public void onSuccess() {
        mStartTime = 0;
        NordicToFlutterImpl.INSTANCE.onDFUStateChanged(NordicDFUState.COMPLETED, "");
    }


    @Override
    public void onProgress(int progress) {
        NordicToFlutterImpl.INSTANCE.onDFUProgress((double) progress, "");
    }

}
