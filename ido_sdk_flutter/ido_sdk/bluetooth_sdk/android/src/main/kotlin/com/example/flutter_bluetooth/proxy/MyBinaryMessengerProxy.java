package com.example.flutter_bluetooth.proxy;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCodec;

/**
 * @author tianwei
 * @date 2023/11/13
 * @time 15:53
 * 用途:代理channel的发送器
 */
public class MyBinaryMessengerProxy {
    public static class MyBinaryMessengerHandler implements InvocationHandler {
        private BinaryMessenger target;
        private MethodCodec codec;

        public MyBinaryMessengerHandler(BinaryMessenger binaryMessenger, MethodCodec codec) {
            this.target = binaryMessenger;
            this.codec = codec;
        }

        @Override
        public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
            Object result = method.invoke(target, args);
            return result;
        }
    }
}
