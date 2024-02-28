package com.idosmart.native_channel.alexa.callbacks;

/**
 * @author tianwei
 * @date 2023/9/23
 * @time 14:40
 * 用途: 下行流
 */
public interface DownStream {
    void createDownStream(DownStreamResultCallback callback);

    void closeDownStream();
}
