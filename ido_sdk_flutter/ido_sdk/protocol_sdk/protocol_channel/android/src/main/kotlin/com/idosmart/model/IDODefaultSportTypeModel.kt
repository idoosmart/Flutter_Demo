package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.JsonAdapter
import com.google.gson.annotations.SerializedName
import com.google.gson.TypeAdapter
import com.google.gson.stream.JsonReader
import com.google.gson.stream.JsonWriter
import com.google.gson.stream.JsonToken

open class IDODefaultSportTypeModel(
    @SerializedName("default_show_num")
    val defaultShowNum: Int,

    @SerializedName("is_supports_sort")
    @JsonAdapter(BooleanIntAdapter::class)
    val isSupportsSort: Boolean,

    @SerializedName("max_show_num")
    val maxShowNum: Int,

    @SerializedName("min_show_num")
    val minShowNum: Int,

    @SerializedName("sport_type")
    @JsonAdapter(SportTypeListAdapter::class)
    val sportTypes: List<IDOSportType>
): IDOBaseModel {
    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
internal class BooleanIntAdapter : TypeAdapter<Boolean>() {
    override fun write(out: JsonWriter, value: Boolean?) {
        if (value == null) {
            out.nullValue()
            return
        }
        out.value(if (value) 1 else 0)
    }

    override fun read(reader: JsonReader): Boolean {
        return when (reader.peek()) {
            JsonToken.NUMBER -> {
                // 读取数字，1 为 true，其他为 false
                reader.nextInt() == 1
            }
            JsonToken.BOOLEAN -> {
                // 直接读取布尔值
                reader.nextBoolean()
            }
            JsonToken.STRING -> {
                // 处理字符串形式的 "1" 或 "0"
                reader.nextString().toIntOrNull() == 1
            }
            JsonToken.NULL -> {
                reader.nextNull()
                false
            }
            else -> {
                reader.skipValue()
                false
            }
        }
    }
}
internal class SportTypeListAdapter : TypeAdapter<List<IDOSportType>>() {
    override fun write(out: JsonWriter, value: List<IDOSportType>?) {
        if (value == null) {
            out.nullValue()
            return
        }
        out.beginArray()
        value.forEach { sportType ->
            out.value(sportType.raw)
        }
        out.endArray()
    }

    override fun read(reader: JsonReader): List<IDOSportType> {
        val sportTypes = mutableListOf<IDOSportType>()
        reader.beginArray()
        while (reader.hasNext()) {
            val id = reader.nextInt()
            IDOSportType.ofRaw(id)?.let { sportTypes.add(it) }
        }
        reader.endArray()
        return sportTypes
    }
}