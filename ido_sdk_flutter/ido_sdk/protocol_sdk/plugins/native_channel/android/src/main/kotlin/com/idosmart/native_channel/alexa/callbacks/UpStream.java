package com.idosmart.native_channel.alexa.callbacks;

/**
 * @author tianwei
 * @date 2023/9/23
 * @time 15:35
 * 用途:上行流
 */
public interface UpStream {

    void startRecord(String url, String requestId, String event, UpstreamResultCallback<byte[], Throwable> callback);

    /**
     * 实时传输的分段数据
     *
     * @param data
     */
    void addVoiceData(byte[] data);

    /**
     * 结束录音
     */
    void endRecord();
}
