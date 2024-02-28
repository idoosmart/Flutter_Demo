package com.idosmart.native_channel.alexa.callbacks;

/**
 * @author tianwei
 * @date 2023/9/23
 * @time 15:37
 * 用途:上行流回调
 */
public interface UpstreamResultCallback<D, E> {
    void start(String requestId);

    void success(String requestId, D result);

    void failure(E error);

    void authorize();

    void complete();

    void startParse();

}
