package com.example.flutter_bluetooth.utils;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;

import com.example.flutter_bluetooth.Config;


/**
 * Created by asus on 2017/9/27.
 */

public class CommonUtils {

    /**
     * 保证所有的回调，都是在主线程执行的
     */
    private static Handler mainHandler = new Handler(Looper.getMainLooper());

    public static void runOnMainThread(Runnable runnable) {
        if (Looper.myLooper() == Looper.getMainLooper()) {
            runnable.run();
        } else {
            getMainHandler().post(runnable);
        }
    }

    /**
     * 在极端情况下，可能会被回收，所以在这里重新初始化一下
     */
    private static Handler getMainHandler() {
        if (mainHandler == null) {
            mainHandler = new Handler(Looper.getMainLooper());
        }
        return mainHandler;
    }

    public static Context getAppContext() {
        return Config.getApplication().getApplicationContext();
    }

    public static void copy(byte[] from, byte[] to) {
        if (from == null || to == null) {
            return;
        }

        int lenFrom = from.length;
        int lenTo = to.length;
        lenFrom = lenFrom < lenTo ? lenFrom : lenTo;
        for (int i = 0; i < lenFrom; i++) {
            to[i] = from[i];
        }
    }
}
