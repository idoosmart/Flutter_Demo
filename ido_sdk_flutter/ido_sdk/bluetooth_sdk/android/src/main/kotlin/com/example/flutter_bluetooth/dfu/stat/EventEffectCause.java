package com.example.flutter_bluetooth.dfu.stat;

import com.google.gson.Gson;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by asus on 2017/12/1.
 */

public class EventEffectCause {
    private Map<String, Integer> effectCauseMap = new HashMap<>();

    public void addCause(String cause){
//        if (effectCauseMap.containsKey(cause)){
//            int times = effectCauseMap.get(cause) + 1;
//            effectCauseMap.put(cause, times);
//        }else {
//            effectCauseMap.put(cause, 1);
//        }
    }

    public String getResult(){
        if (effectCauseMap.size() == 0){
            return "null";
        }
        return new Gson().toJson(effectCauseMap);
    }

    public void clear(){
        effectCauseMap.clear();
    }

}
