package com.idosmart.native_channel.alexa.callbacks;

/**
 * @author tianwei
 * @date 2023/9/23
 * @time 15:37
 * 用途:上行流结果回调实现类
 */
public class ImplUpstreamResultCallback<D, E> implements UpstreamResultCallback<D, E> {
    @Override
    public void start(String requestId) {

    }

    @Override
    public void success(String requestId, D result) {

    }

    @Override
    public void failure(E error) {

    }

    @Override
    public void authorize() {

    }

    @Override
    public void complete() {

    }

    @Override
    public void startParse() {

    }
}