package com.example.flutter_bluetooth.proxy;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.UiThread;

import com.example.flutter_bluetooth.logger.Logger;
import com.example.flutter_bluetooth.utils.Constants;
import com.example.flutter_bluetooth.utils.GsonUtil;

import java.nio.ByteBuffer;

import io.flutter.Log;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.FlutterException;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodCodec;
import io.flutter.plugin.common.StandardMethodCodec;

/**
 * @author tianwei
 * @date 2023/11/13
 * @time 16:06
 * 用途:
 */
public class MyMethodChannel extends MethodChannel {
    private static final String TAG = "MyMethodChannel";
    /**
     * 消息发送器{@link io.flutter.embedding.engine.dart.DartMessenger}
     */
    private final BinaryMessenger messenger;
    private final String name;
    private final MethodCodec codec;

    public MyMethodChannel(@NonNull BinaryMessenger messenger, @NonNull String name) {
        this(messenger, name, StandardMethodCodec.INSTANCE);
    }

    public MyMethodChannel(@NonNull BinaryMessenger messenger, @NonNull String name, @NonNull MethodCodec codec) {
        super(messenger, name, codec);
        this.messenger = messenger;
        this.name = name;
        this.codec = codec;
    }

    @Override
    public void invokeMethod(@NonNull String method, @Nullable Object arguments) {
        super.invokeMethod(method, arguments);
    }

    /**
     * 最终调用{@link io.flutter.embedding.engine.dart.DartMessenger#send(String, ByteBuffer, BinaryMessenger.BinaryReply)}
     * @param method the name String of the method.
     * @param arguments the arguments for the invocation, possibly null.
     * @param callback a {@link Result} callback for the invocation result, or null.
     */
    @Override
    public void invokeMethod(@NonNull String method, @Nullable Object arguments, @Nullable Result callback) {
        if (Constants.ResponseMethod.DEVICE_STATE.equals(method)) {
            try {
                Logger.p(TAG, "发送蓝牙状态：" + method + ", 参数：" + GsonUtil.toJson(arguments));
            } catch (Exception e) {
                Logger.p(TAG, "发送蓝牙状态：" + method + " 异常：" + e);
            }
        }
        messenger.send(
                name,
                codec.encodeMethodCall(new MethodCall(method, arguments)),
                callback == null ? null : new IncomingResultHandler(callback));
    }

    private final class IncomingResultHandler implements BinaryMessenger.BinaryReply {
        private final Result callback;

        IncomingResultHandler(Result callback) {
            this.callback = callback;
        }

        @Override
        @UiThread
        public void reply(ByteBuffer reply) {
            try {
                if (reply == null) {
                    callback.notImplemented();
                } else {
                    try {
                        callback.success(codec.decodeEnvelope(reply));
                    } catch (FlutterException e) {
                        callback.error(e.code, e.getMessage(), e.details);
                    }
                }
            } catch (RuntimeException e) {
                Log.e(TAG + name, "Failed to handle method call result", e);
            }
        }
    }
}
