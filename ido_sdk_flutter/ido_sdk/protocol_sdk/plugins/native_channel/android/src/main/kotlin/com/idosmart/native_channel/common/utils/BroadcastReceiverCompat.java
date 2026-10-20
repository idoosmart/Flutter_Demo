package com.idosmart.native_channel.common.utils;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.IntentFilter;
import android.os.Build;

import androidx.core.content.ContextCompat;

/**
 * Android 13+ 动态注册 BroadcastReceiver 兼容封装。
 * API 33 起须指定 RECEIVER_EXPORTED / RECEIVER_NOT_EXPORTED。
 */
public final class BroadcastReceiverCompat {

    private BroadcastReceiverCompat() {
    }

    public static void register(Context context, BroadcastReceiver receiver, IntentFilter filter) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            ContextCompat.registerReceiver(context, receiver, filter, ContextCompat.RECEIVER_NOT_EXPORTED);
        } else {
            context.registerReceiver(receiver, filter);
        }
    }

    public static void unregister(Context context, BroadcastReceiver receiver) {
        try {
            if (context != null && receiver != null) {
                context.unregisterReceiver(receiver);
            }
        } catch (Exception ignored) {
        }
    }
}
