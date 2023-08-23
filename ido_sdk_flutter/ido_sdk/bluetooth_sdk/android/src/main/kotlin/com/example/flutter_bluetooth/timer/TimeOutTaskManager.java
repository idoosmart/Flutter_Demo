package com.example.flutter_bluetooth.timer;


import android.util.Log;

import com.example.flutter_bluetooth.logger.Logger;

import java.util.ConcurrentModificationException;
import java.util.HashMap;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

/**
 * Created by zhouzj on 2018/1/15.
 */

public class TimeOutTaskManager {
    private static final String TAG = "TimeOutTaskManager";

    private static int taskId = 0;
    private static Map<Integer, TimeOutTimer> timeOutTimerMap = new HashMap<>();

    public static int startTask(ITimeOut iTimeOut, long delay) {
        purgeTask();
        taskId++;
        TimeOutTimer timeOutTimer = new TimeOutTimer(iTimeOut, delay, taskId);
        timeOutTimerMap.put(taskId, timeOutTimer);

        timeOutTimer.start();
        return taskId;
    }

    public static boolean stopTask(int taskId) {
        if (!timeOutTimerMap.containsKey(taskId)) {
            return false;
        }

        TimeOutTimer timeOutTimer = timeOutTimerMap.get(taskId);
        if (timeOutTimer == null) {
            return false;
        }
        timeOutTimer.stop();
        timeOutTimerMap.remove(taskId);

        Log.d(TAG, "task queue size is " + timeOutTimerMap.size());
        return true;
    }

    private static void purgeTask() {
        Map<Integer, TimeOutTimer> timeOutTimerMapCopy = new HashMap<>();
        try {
            timeOutTimerMapCopy.putAll(timeOutTimerMap);
        } catch (ConcurrentModificationException e) {
            Logger.e( "purgeTask error, ignore, handle next.");
            return;
        }

        for (Map.Entry<Integer, TimeOutTimer> entrySet : timeOutTimerMapCopy.entrySet()) {
            TimeOutTimer timeOutTimer = entrySet.getValue();
            if (timeOutTimer == null) {
                continue;
            }
            if (timeOutTimer.getState() == TimeOutTimer.STATE_FINISHED) {
                timeOutTimerMap.remove(timeOutTimer.getTaskId());
            }
        }

        Log.d(TAG, "after purge, task queue size is " + timeOutTimerMap.size());

    }


    private static class TimeOutTimer extends Timer {
        public static int STATE_READY = 0;
        public static int STATE_FINISHED = 1;
        private TimerTask timerTask;
        private ITimeOut iTimeOut;
        private int taskId;
        private long delay;
        private int taskState = STATE_READY;

        private TimeOutTimer(ITimeOut iTimeOut, long delay, int taskId) {
            this.iTimeOut = iTimeOut;
            this.delay = delay;
            this.taskId = taskId;
        }

        public void stop() {
            taskState = STATE_FINISHED;
            if (timerTask != null) {
                timerTask.cancel();
                timerTask = null;
            }
            purge();
            cancel();
            Log.d(TAG, "task stop, id = " + taskId);
        }

        public void start() {
            Log.d(TAG, "task start, id = " + taskId);
            timerTask = new TimerTask() {
                @Override
                public void run() {
                    Log.d(TAG, "task is fire, id = " + taskId);
                    if (taskState == STATE_FINISHED) {
                        return;
                    }
                    taskState = STATE_FINISHED;

                    if (iTimeOut != null) {
                        iTimeOut.onTimeOut();
                    }

                    purgeTask();
                }
            };
            schedule(timerTask, delay);
        }

        public int getState() {
            return taskState;
        }

        public int getTaskId() {
            return taskId;
        }
    }

    public interface ITimeOut {
        void onTimeOut();
    }
}
