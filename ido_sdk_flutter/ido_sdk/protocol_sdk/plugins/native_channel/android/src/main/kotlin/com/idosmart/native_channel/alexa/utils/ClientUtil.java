package com.idosmart.native_channel.alexa.utils;


import java.util.concurrent.TimeUnit;

import okhttp3.ConnectionPool;
import okhttp3.OkHttpClient;

/**
 * Create a singleton OkHttp client that, hopefully, will someday be able to make sure all connections are valid according to AVS's strict
 * security policy--this will hopefully fix the Connection Reset By Peer issue.
 * <p>
 * Created by willb_000 on 6/26/2016.
 */
public class ClientUtil {
    private static OkHttpClient mClient;
    private static final long CONNECTION_POOL_TIMEOUT_MILLISECONDS = 60 * 60 * 1000;
    private static OkHttpClient okHttpClient = null;
    private static long TIME_OUT = 30 * 1000;

    public static OkHttpClient getTLS12OkHttpClient() {
        if (mClient == null) {
            ConnectionPool connectionPool = new ConnectionPool(10, CONNECTION_POOL_TIMEOUT_MILLISECONDS, TimeUnit.MILLISECONDS);
            OkHttpClient.Builder  client = new OkHttpClient.Builder().connectTimeout(0, TimeUnit.MILLISECONDS)  // 0 => no timeout.
                        .readTimeout(0, TimeUnit.MILLISECONDS)
                        .writeTimeout(30, TimeUnit.SECONDS)
                        .connectionPool(connectionPool)
                        /*.sslSocketFactory(SSLSocketClient.getSSLSocketFactory(), SSLSocketClient.getX509TrustManager())
                          .hostnameVerifier(SSLSocketClient.getHostnameVerifier());
                         .addInterceptor(loggingInterceptor)
                     .protocols(Collections.singletonList(Protocol.HTTP_1_1))*/;
            mClient = client.build();
        }
        return mClient;
    }

    public static OkHttpClient getOkHttpClient(){
        if(okHttpClient == null) {
            okHttpClient = new OkHttpClient.Builder()
                    .connectTimeout(TIME_OUT, TimeUnit.SECONDS)//设置连接超时时间
                    .readTimeout(TIME_OUT, TimeUnit.SECONDS)//设置读取超时时间
                    .writeTimeout(TIME_OUT, TimeUnit.SECONDS)
                    .build();
        }
        return okHttpClient;
    }


}
