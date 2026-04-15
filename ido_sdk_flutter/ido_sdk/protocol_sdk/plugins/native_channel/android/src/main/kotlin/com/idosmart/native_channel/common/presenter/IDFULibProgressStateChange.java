package com.idosmart.native_channel.common.presenter;

/**
 * Created by zhouzj on 2018/6/14.
 */

public interface IDFULibProgressStateChange {
    void onStart(DFULibProgressStateChangePresenter.IDFULibProgressStateTimeOutListener listener);
    void onStateChange();
    void onEnd();
}
