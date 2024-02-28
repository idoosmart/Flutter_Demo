package com.example.flutter_bluetooth.utils;

import android.text.TextUtils;

import com.example.flutter_bluetooth.logger.Logger;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParseException;
import com.google.gson.JsonSerializationContext;
import com.google.gson.JsonSerializer;
import com.google.gson.reflect.TypeToken;

import java.lang.reflect.Type;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

/**
 * Gson解析工具
 */
public class GsonUtil {

    private static Gson gson = new Gson();

    /**
     * 把json转成List集合
     *
     * @param json
     * @param clazz
     * @param <T>
     * @return
     */
    public static <T> List<T> analysisJsonArrayToList(String json, Class<T[]> clazz) {
        if (TextUtils.isEmpty(json)) {
            return null;
        }
        T[] array = gson.fromJson(json, clazz);
        return Arrays.asList(array);
    }

    /**
     * 把json转成List集合
     *
     * @param json
     * @param clazz
     * @param <T>
     * @return
     */
    public static <T> List<T> analysisJsonObjectToList(String json, Class<T> clazz) {
        if (TextUtils.isEmpty(json)) {
            return null;
        }
        Type type = new TypeToken<ArrayList<JsonObject>>() {
        }.getType();
        ArrayList<JsonObject> jsonObjects = gson.fromJson(json, type);
        ArrayList<T> arrayList = new ArrayList<T>();
        for (JsonObject jsonObject : jsonObjects) {
            arrayList.add(gson.fromJson(jsonObject, clazz));
        }
        return arrayList;
    }

    /**
     * 把对象转成json
     *
     * @param obj
     * @return
     */
    public static String toJson(Object obj) {
        try {
            return gson.toJson(obj);
        } catch (Exception e) {
            Logger.e("toJson error: " + e + ", obj: " + obj);
        }
        return "";
    }

    /**
     * 解析json获取对象
     *
     * @param json
     * @return
     */
    public static <T> T analysisJsonToObject(String json, Class<T> clazz) {
        if (TextUtils.isEmpty(json)) {
            return null;
        }
        return gson.fromJson(json, clazz);
    }

}
