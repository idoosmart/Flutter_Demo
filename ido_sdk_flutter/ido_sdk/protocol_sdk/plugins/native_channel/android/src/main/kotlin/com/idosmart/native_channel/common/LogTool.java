package com.idosmart.native_channel.common;

import android.util.Log;

public class LogTool {
    public static void p(String tag, String content) {
        Log.d(tag, content);
    }

    public static void e(String tag, String content) {
        Log.e(tag, content);
    }
}
