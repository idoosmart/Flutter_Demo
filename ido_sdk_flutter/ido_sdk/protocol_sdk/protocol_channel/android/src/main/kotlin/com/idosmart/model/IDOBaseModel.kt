package com.idosmart.model

import com.google.gson.FieldNamingPolicy
import com.google.gson.FieldNamingStrategy
import com.google.gson.GsonBuilder
import com.google.gson.JsonDeserializer
import com.google.gson.JsonSerializer
import com.google.gson.annotations.SerializedName
import java.io.Serializable
import java.lang.reflect.Field

internal class CustomFieldNamingStrategy : FieldNamingStrategy {
    override fun translateName(f: Field?): String {
        if (f?.name.equals("items")) {
            return "item";
        }
        return FieldNamingPolicy.LOWER_CASE_WITH_UNDERSCORES.translateName(f);
    }
}

interface IDOBaseModel : Serializable {
    fun toJsonString(): String
}

interface IDOBaseAdapterModel<T> : IDOBaseModel {
    fun getDeSerializer(): IDOBaseModelDeSerializer<T>? {
        return null
    }

    fun getFieldNamingStrategy(): FieldNamingStrategy? {
        return CustomFieldNamingStrategy()
    }

    override fun toJsonString(): String {
        val gsonBuilder = GsonBuilder()
        getDeSerializer()?.let {
            gsonBuilder.registerTypeAdapter(javaClass, it)
        }
        getFieldNamingStrategy()?.let {
            gsonBuilder.setFieldNamingStrategy(it)
        }
        val gson = gsonBuilder.create()
        return gson.toJson(this)
    }
}

interface IDOBase

interface IDOBaseModelDeSerializer<T> : JsonSerializer<T>, JsonDeserializer<T> {

}