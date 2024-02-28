package com.idosmart.native_channel.alexa.downstream;


import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;

import com.idosmart.native_channel.alexa.utils.AlexaLogUtil;
import com.idosmart.native_channel.alexa.AlexaManager;
import com.idosmart.native_channel.alexa.callbacks.DownStream;
import com.idosmart.native_channel.alexa.callbacks.DownStreamResultCallback;
import com.idosmart.native_channel.alexa.utils.ClientUtil;
import com.idosmart.native_channel.pigeon_generate.api_alexa.ApiAlexaError;

import org.jetbrains.annotations.NotNull;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.util.Timer;
import java.util.TimerTask;

import okhttp3.CacheControl;
import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.Request;
import okhttp3.Response;
import okio.BufferedSource;


/**
 * @author tianwei
 * @date 2023/9/23
 * @time 15:35
 * 用途:建立下行通道流, 与AVS同步状态, 用来接收云启动的指令
 */
public class AlexaDownChannelService implements DownStream {

    private static final String TAG = "Alexa-DownChannel";
    private Call currentCall;
    private Handler runnableHandler;
    private PingTimerTask mPingTimerTask;
    private Timer updateTimer;
    private final int delayTime = 2 * 60 * 1000;
    private boolean isBleConnected = true;
    private boolean hasNetwork = true;
    private Response downChannelResponse;
    //是否需要重建下行流
    public static final String RE_CREATE_DOWNCHANNEL = "reCreateDownchannle";
    //是否需要同步通知状态
    public static final String IS_SYNC_NOTIFY_STATUS = "isSyncNotifyStatus";
    //通知离线状态
    public static final String OFFLINE_STATUS = "offLineStatus";
    //响应数据一致返回空，重建创建
    public static final String NEED_CREATE_DOWNCHANNEL = "needCreateDownchannle";
    //需要上传smart home 技能
    public static final String NEED_CREATE_SMARTHOME = "needCreateSmartHome";
    private static final String BOUNDARY = "--------abcde123";
    private static final String BOUNDARY_END = "--------abcde123--";
    private static final String CONTENT_TYPE = "Content-Type: application/json";
    private static final String ACTION_NET_CHANGE = "android.net.conn.CONNECTIVITY_CHANGE";
    private static AlexaDownChannelService mInstance;
    private AlexaManager alexaManager;
    private DownStreamResultCallback mDownStreamResultCallback;

    private AlexaDownChannelService() {
        runnableHandler = new Handler(Looper.getMainLooper());
        alexaManager = AlexaManager.getInstance();
    }

    public static AlexaDownChannelService getInstance() {
        if (mInstance == null) {
            synchronized (AlexaDownChannelService.class) {
                if (mInstance == null) {
                    mInstance = new AlexaDownChannelService();
                    log(" Launched downChannelService");
                }
            }
        }
        return mInstance;
    }

    @Override
    public void createDownStream(DownStreamResultCallback callback) {
        mDownStreamResultCallback = callback;
        createDownChannel();
    }

    @Override
    public void closeDownStream() {
        AlexaLogUtil.p("<<<close>>>", TAG);
        cancel();
    }

    private class PingTimerTask extends TimerTask {
        @Override
        public void run() {
            sendPingRequest();
        }
    }

    public void sendPingRequest() {
        if (!hasLogin()) {
            log("Alexa is not logged in");
            return;
        }
        if (TextUtils.isEmpty(alexaManager.getPingUrl())) {
            log("ping url is null");
            return;
        }
        final Request request = new Request.Builder().url(alexaManager.getPingUrl()).get().addHeader("Authorization", alexaManager.getToken()).build();

        ClientUtil.getTLS12OkHttpClient().newCall(request).enqueue(new Callback() {
            @Override
            public void onFailure(@NotNull Call call, @NotNull IOException e) {
                log(" ping-Failed-" + e.getMessage() + " ,reCreateDownChannel");
            }

            @Override
            public void onResponse(@NotNull Call call, @NotNull Response response) {
                log(" ping-Success");
            }
        });
    }

    private synchronized void startPing() {
        try {
            if (mPingTimerTask != null) {
                mPingTimerTask.cancel(); //将原任务从队列中移除(很重要，一定要移除)
                mPingTimerTask = null;
            }
            mPingTimerTask = new PingTimerTask();
            updateTimer = new Timer();
            //每2分钟发送一个ping帧给AVS，保持连接
            updateTimer.schedule(mPingTimerTask, delayTime, delayTime);
        } catch (Exception e) {
            e.printStackTrace();
        }
        log("startPing");
    }

    private void stopPing() {
        if (updateTimer != null) {
            updateTimer.cancel();
            updateTimer = null;
        }
        log("stopPing");
    }

    private boolean hasLogin() {
        return alexaManager.hasLogin();
    }

    private void cancel() {
        if (currentCall != null && !currentCall.isCanceled()) {
            currentCall.cancel();//取消抛IO异常
        }
    }

    /**
     * 建立下行通道流,与AVS同步状态,用来接收云启动的指令
     */
    private void createDownChannel() {
        if (!hasLogin()) {
            log("Alexa is not logged in");
            returnError(-1, "Alexa is not logged in");
            return;
        }
        log("start createDownChannel");
        if (TextUtils.isEmpty(alexaManager.getDirectiveUrl())) {
            log("createDownChannel mDirectiveUrl is empty");
            returnError(-1, "empty directive url!");
            return;
        }

        if (downChannelResponse != null) {
            log("下行流已经创建成功，重新创建");
        }

        if (currentCall != null && !currentCall.isCanceled()) {
            currentCall.cancel();
            log("cancel Call");////取消抛IO异常
            return;
        }
        runnableHandler.postDelayed(timeoutRunnable, 30 * 1000);
        final Request request = new Request.Builder().url(alexaManager.getDirectiveUrl()).get().addHeader("Authorization", alexaManager.getToken()).cacheControl(new CacheControl.Builder().noCache().build()).build();

        currentCall = ClientUtil.getTLS12OkHttpClient().newCall(request);
        currentCall.enqueue(new Callback() {
            @Override
            public void onFailure(@NotNull Call call, @NotNull IOException e) {
                log(" DownChannel request failed =" + e.getMessage());
                handlerException();
            }

            @Override
            public void onResponse(@NotNull Call call, @NotNull Response response) {
                log(Thread.currentThread().getName() + ", DownChannel onResponse code=====" + response.code());
                runnableHandler.removeCallbacks(timeoutRunnable);
                if (response.code() == HttpURLConnection.HTTP_FORBIDDEN) {
//                                ResponseHandler.getInstance().eauthorizerAmazon();
                    returnError(403, "need login ");
                    return;
                } else if (response.code() == HttpURLConnection.HTTP_OK) {
//                                createSmartHome();
//                                syncNotifyStatus();
                    //TODO 创建技能、同步状态
                }
                if (response.body() == null) {
                    log("HandleDirectiveCallback= body null");
                    //TODO 没有body
                    return;
                }
                downChannelResponse = response;
                startPing();
                BufferedSource bufferedSource = response.body().source();
                try {
                    //                    while (true) {
//                        String line = "";
//                        try {
//                            if (bufferedSource.exhausted()) break;
//                            line = bufferedSource.readUtf8Line();
//                        } catch (IOException e) {
//                            e.printStackTrace();
//                            log(" HandleDirectiveCallback=IOException =" + e.getMessage());
//                            response.close();
//                            handlerException();
//                        }
//                        if (!TextUtils.isEmpty(line)) {
//                            log(" HandleDirectiveCallback=" + line);
//                            if (!TextUtils.equals(line, BOUNDARY) && !TextUtils.equals(line, CONTENT_TYPE)) {
//                                try {
////                                    Directive directive = ApiParser.getDirective(line);
////                                    if (directive != null) {
////                                        ResponseHandler.getInstance().handleDirective(directive);
////                                    } else {
////                                        AlexaLogUtil.d(TAG, "HandleDirectiveCallback==directive = null");
////                                    }
//                                } catch (Exception e) {
//                                    e.printStackTrace();
//                                    log(" HandleDirectiveCallback=parseException =" + e.getMessage());
//                                }
//                            }
//                        }
//                    }
                    StringBuilder buffer = new StringBuilder();
                    while (true) {
                        String line = "";
                        try {
                            if (bufferedSource.exhausted()) break;
                            line = bufferedSource.readUtf8Line();
                            buffer.append(line);
                        } catch (IOException e) {
                            e.printStackTrace();
                            log(" HandleDirectiveCallback=IOException =" + e.getMessage());
                            response.close();
                            handlerException();
                        }
//                        log("HandleDirectiveCallback, line = "+line);
                        if (!TextUtils.isEmpty(line)) {
                            if (!TextUtils.equals(line, BOUNDARY) && !TextUtils.equals(line, CONTENT_TYPE)) {
                                    String content = buffer.toString();
                                    log(" HandleDirectiveCallback, content = " + content);
                                    try {
                                        if (mDownStreamResultCallback != null) {
                                            mDownStreamResultCallback.onDownStreamData(content.getBytes());
                                        }
                                    } catch (Exception e) {
                                        log("HandleDirectiveCallback= error: " + e);
                                    } finally {
                                        try {
                                            buffer.delete(0, buffer.length());
                                        } catch (Exception ignored) {
                                        }
                                    }

                            }

                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    log("HandleDirectiveCallback, Exception = " + e);
                }
            }
        });
    }

    //下行流异常处理
    private void handlerException() {
        currentCall = null;
        downChannelResponse = null;
        runnableHandler.removeCallbacks(timeoutRunnable);
        runnableHandler.removeCallbacks(delayRecreateRunnable);
        runnableHandler.postDelayed(delayRecreateRunnable, 10 * 1000);
    }

    private void returnError(long code, String message) {
        if (mDownStreamResultCallback != null) {
            ApiAlexaError error = new ApiAlexaError(code, message, null);
            mDownStreamResultCallback.onDownStreamError(error);
        }
    }

    private synchronized void reCreateDownChannel() {
        runnableHandler.removeCallbacks(delayRecreateRunnable);
        downChannelResponse = null;
        if (hasNetwork) {
            createDownChannel();
        }
    }

    Runnable delayRecreateRunnable = new Runnable() {
        @Override
        public void run() {
            if (hasNetwork && isBleConnected && downChannelResponse == null) {
                log("create downChannel failed,reCreate");
                reCreateDownChannel();
            }
        }
    };

    Runnable timeoutRunnable = new Runnable() {
        @Override
        public void run() {
            log("create downChannel timeout");
            if (currentCall != null) {
                currentCall.cancel();
            }
        }
    };

    private static void log(String log) {
        AlexaLogUtil.printAndSave(log, TAG);
    }
}
