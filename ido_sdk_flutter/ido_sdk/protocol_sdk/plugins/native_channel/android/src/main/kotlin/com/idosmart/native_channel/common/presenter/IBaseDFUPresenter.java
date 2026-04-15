package com.idosmart.native_channel.common.presenter;


/**
 * Created by Zhouzj on 2017/12/26.
 *
 */

public interface IBaseDFUPresenter {
    void onPrepare();
    void onFailedByConfigParaError();
    void onFailedByOther();
    void onCancel();
    void onSuccess();
    void onProgress(int progress);
}
