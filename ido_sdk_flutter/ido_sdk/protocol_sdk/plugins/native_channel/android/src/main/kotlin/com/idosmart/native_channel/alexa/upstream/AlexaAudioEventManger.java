package com.idosmart.native_channel.alexa.upstream;

import com.idosmart.native_channel.alexa.utils.AlexaLogUtil;
import com.idosmart.native_channel.alexa.AlexaManager;
import com.idosmart.native_channel.alexa.callbacks.UpStream;
import com.idosmart.native_channel.alexa.callbacks.UpstreamResultCallback;
import com.idosmart.native_channel.alexa.requestbody.PipeBody;
import com.idosmart.native_channel.alexa.utils.ClientUtil;

import org.apache.commons.io.IOUtils;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.util.Queue;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import okhttp3.Call;
import okhttp3.Headers;
import okhttp3.MediaType;
import okhttp3.MultipartBody;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;
import okhttp3.ResponseBody;

/**
 * @author tianwei
 * @date 2023/9/23
 * @time 15:35
 * 用途:发送语音事件的管理类
 */
public class AlexaAudioEventManger implements UpStream {
    private static final String TAG = "AlexaAudioEventManger";
    private Call mCurrentCall;
    private PipeBody mPipeBody = new PipeBody();
    private boolean isEndOfRecording;

    private Queue<byte[]> chunkData = new LinkedBlockingQueue<>();
    private int writeSize = 0, pcmSize = 0;
    private Thread mThread;
    private static AlexaAudioEventManger instance;
    private AlexaManager alexaManager;

    private AlexaAudioEventManger() {
        alexaManager = AlexaManager.getInstance();
    }

    public static AlexaAudioEventManger getInstance() {
        if (instance == null) {
            instance = new AlexaAudioEventManger();
        }
        return instance;
    }


    @Override
    public void startRecord(String url, String requestId, String event, UpstreamResultCallback<byte[], Throwable> callback) {
        AlexaManager.getInstance().setEventUrl(url);
        AlexaAudioEventManger.getInstance().chunkSendRecordRequest(requestId, event, callback);
    }

    @Override
    public void addVoiceData(byte[] data) {
        if (!isEndOfRecording) {
            chunkData.add(data);
            pcmSize++;
        }
    }

    /**
     * 结束录音
     */
    @Override
    public void endRecord() {
        isEndOfRecording = true;
        AlexaLogUtil.printAndSave("收到 11 03 =" + chunkData.size() + "  pcmSize=" + pcmSize + " writeSize=" + writeSize, TAG);
        chunkData.clear();
    }

    public void cancelCall() {
        if (mCurrentCall != null && mCurrentCall.isExecuted()) {
            mCurrentCall.cancel();
        }
    }

    /**
     * 发送录音请求
     */
    public UpStream chunkSendRecordRequest(String requestId, String event, final UpstreamResultCallback<byte[], Throwable> callback) {
        cancelCall();
        isEndOfRecording = false;
        chunkData.clear();
        pcmSize = 0;
        mPipeBody = null;
        mPipeBody = new PipeBody();
        sendRecordRequest(requestId, event, mPipeBody, callback);
        if (mThread != null && mThread.isAlive()) {
            mThread.interrupt();
            AlexaLogUtil.d("Alexa", "mThread interrupt");
        }
        mThread = new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    writeSize = 0;
                    while (!(isEndOfRecording && chunkData.size() == 0)) {
                        if (chunkData.size() > 0) {
                            byte[] bytes = chunkData.poll();
                            if (bytes != null) {
                                mPipeBody.sink().write(bytes);
                                mPipeBody.sink().flush();
                                writeSize++;
                            }
                        }
                    }
                    AlexaLogUtil.d("Alexa", "mPipeBody.sink().close()");
                    mPipeBody.sink().close();
                    chunkData.clear();
                    if (callback != null) {
                        callback.startParse();
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    AlexaLogUtil.printAndSave("writeVoiceStream exception= " + e.getMessage(), TAG);
                    if (callback != null) {
                        callback.failure(e);
                    }
                }
            }
        });
        mThread.start();
        return this;
    }

    /**
     * 发送录音请求
     */
    private void sendRecordRequest(final String requestId, final String event, final PipeBody pipeBody, final UpstreamResultCallback<byte[], Throwable> callback) {
        if (!alexaManager.hasLogin()) {
            if (callback != null) {
                callback.failure(new Exception("no login"));
            }
            return;
        }
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    Request.Builder requestBuilder = new Request.Builder();
                    requestBuilder.url(alexaManager.getEventUrl());
                    requestBuilder.addHeader("Authorization", alexaManager.getToken());

                    AlexaLogUtil.d(TAG, "sendRecord event = " + event);
                    AlexaLogUtil.d(TAG, "sendRecord token = " + alexaManager.getToken());
                    if (callback != null) {
                        callback.start(requestId);
                    }
                    MultipartBody.Builder bodyBuilder = new MultipartBody.Builder()
                            .setType(MultipartBody.FORM)
                            .addFormDataPart("metadata", "metadata", RequestBody.create(MediaType.parse("application/json; charset=UTF-8"), event));
                    if (pipeBody != null) {
                        bodyBuilder.addFormDataPart("audio", "speech", pipeBody);
                    }
                    requestBuilder.post(bodyBuilder.build());
                    Request request = requestBuilder.build();

                    mCurrentCall = ClientUtil.getTLS12OkHttpClient().newCall(request);

                    try {
                        Response response = mCurrentCall.execute();
                        AlexaLogUtil.printAndSave("sendRecord result = " + response, TAG);
                        if (response.code() == HttpURLConnection.HTTP_NO_CONTENT) {
                            AlexaLogUtil.printAndSave("Received a 204 response code from Amazon, is this expected?", TAG);
                        } else if (response.code() == HttpURLConnection.HTTP_FORBIDDEN) {
                            AlexaLogUtil.printAndSave("Received a 403 response code from Amazon, need authorize", TAG);
                        }
                        ResponseBody body = response.body();
                        AlexaLogUtil.p("sendRecord = body = " + body, TAG);
                        if (body == null) {
                            if (callback != null) {
                                callback.failure(new Exception("ResponseBody is null"));
                            }
                            return;
                        }

                        byte[] bytes;
                        try {
                            bytes = IOUtils.toByteArray(body.byteStream());
                            String responseString = new String(bytes);
                            //AlexaLogUtil.p("sendRecord responseString = " + responseString, TAG); //有流数据，不适合打印到文件
                            if (callback != null) {
                                callback.success(requestId, bytes);
                            }
                        } catch (IOException exp) {
                            exp.printStackTrace();
                            AlexaLogUtil.e("Error copying bytes[]", TAG);
                            if (callback != null) {
                                callback.failure(exp);
                            }
                        }
                        body.close();


                    } catch (Exception exp) {
                        exp.printStackTrace();
                        if (callback != null) {
                            callback.failure(exp);
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    if (callback != null) {
                        callback.failure(e);
                    }
                }
            }
        }).start();
    }

    protected String getBoundary(Response response) {
        Headers headers = response.headers();
        String header = headers.get("content-type");
        String boundary = "";

        if (header != null) {
            Pattern pattern = Pattern.compile("boundary=(.*?);");
            Matcher matcher = pattern.matcher(header);
            if (matcher.find()) {
                boundary = matcher.group(1);
            }
        }
        return boundary;
    }

}
