package com.example.flutter_bluetooth.dfu.nodic.task;


import com.example.flutter_bluetooth.dfu.BleDFUConstants;
import com.example.flutter_bluetooth.logger.Logger;

import java.util.Timer;
import java.util.TimerTask;

public class TempProgressUpdateTask {

    private static TempProgressUpdateTask task;
    private boolean isDoing = false;

    /**
     * 秒 统计
     */
    private int secondCount = 0;
    private int progress = 0;

    private Timer mTimer;
    private TimerTask mTimerTask;

    private ITempProgressListener iTempProgressListener;

    public static TempProgressUpdateTask getTask(){
        if (task == null) {
            task = new TempProgressUpdateTask();
        }
        return task;
    }

    public void start(ITempProgressListener listener){

        if (isDoing){
            return;
        }

        Logger.p(BleDFUConstants.LOG_TAG, "[TempProgressUpdateTask] start ,listener = " + listener);

        secondCount = 0;
        isDoing = true;
        iTempProgressListener = listener;
        startTimer();
    }

    private void startTimer(){
        stopTimer();

        Logger.p(BleDFUConstants.LOG_TAG, "[TempProgressUpdateTask] startTimer");
        mTimer = new Timer();
        mTimerTask = new TimerTask() {
            @Override
            public void run() {
                updateProgress();
            }
        };
        mTimer.schedule(mTimerTask, 0, 1000);
    }

    private void stopTimer(){
        Logger.p(BleDFUConstants.LOG_TAG, "[TempProgressUpdateTask] stopTimer");
        if (mTimerTask != null){
            mTimerTask.cancel();
        }
        if (mTimer != null) {
            mTimer.cancel();
        }
    }

    public void stop(){
        if (!isDoing){
//            Logger.p(BleDFUConstants.LOG_TAG, "[TempProgressUpdateTask] stop, idDoing = " + false);
            return;
        }
        Logger.p(BleDFUConstants.LOG_TAG, "[TempProgressUpdateTask] stop");
        stopTimer();
        release();
    }

    private void release(){
        Logger.p(BleDFUConstants.LOG_TAG, "[TempProgressUpdateTask] release");
        isDoing = false;
        iTempProgressListener = null;
        secondCount = 0;

    }


    private void updateProgress(){
        int temp = 0;
        secondCount ++;
        if (secondCount == 5){
            temp = 1;//5
        }else if (secondCount == 10){
            temp = 2;//10
        }else if (secondCount == 20){
            temp = 3;//15
        }else if (secondCount == 35){
            temp = 4;//20
        }else if (secondCount == 55){
            temp = 5;//25
        }else if (secondCount == 80){
            temp = 6;//30
        }else if (secondCount == 110){
            temp = 7;//35
        }else if (secondCount == 145){
            temp = 8;//40
        }else if (secondCount == 185){
            temp = 9;//45
        }else if (secondCount == 230){
            temp = 10;//50
        }else {
            temp = progress;
        }
        if (iTempProgressListener != null && isDoing && temp != progress){
            progress = temp;
            iTempProgressListener.onTempProgress(progress);
            Logger.p(BleDFUConstants.LOG_TAG, "[TempProgressUpdateTask] updateProgress , secondCount = " + secondCount + ", tmpProgress=" + progress);
        }


    }

    public interface ITempProgressListener{
        void onTempProgress(int progress);
    }

}
