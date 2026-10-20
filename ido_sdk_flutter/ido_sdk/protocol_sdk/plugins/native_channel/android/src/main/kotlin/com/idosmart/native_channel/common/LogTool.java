package com.idosmart.native_channel.common;

import android.util.Log;
import com.idosmart.native_channel.actions.ActionsToFlutterImpl;

public class LogTool {
    public static void p(String tag, String content) {
        //Log.d(tag, content);
        ActionsToFlutterImpl.INSTANCE.log(content);
    }

    public static void e(String tag, String content) {
        //Log.e(tag, content);
        ActionsToFlutterImpl.INSTANCE.log(content);
    }
}
