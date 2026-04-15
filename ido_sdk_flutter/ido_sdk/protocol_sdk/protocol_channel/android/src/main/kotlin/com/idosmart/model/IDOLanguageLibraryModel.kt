//
//  IDOLanguageLibraryModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.FieldNamingPolicy
import com.google.gson.GsonBuilder
import com.google.gson.JsonDeserializationContext
import com.google.gson.JsonDeserializer
import com.google.gson.JsonElement
import com.google.gson.JsonParseException
import com.google.gson.JsonPrimitive
import com.google.gson.JsonSerializationContext
import com.google.gson.JsonSerializer
import java.lang.reflect.Type
import com.google.gson.annotations.JsonAdapter
import com.google.gson.annotations.SerializedName

///

// MARK: - IDOLanguageLibraryModel

open class IDOLanguageLibraryModel(
    useLang: Int,
    defaultLang: Int,
    fixedLang: Int,
    maxStorageLang: Int,
    items: List<IDOLanguageLibraryItem>?,
    itemsUser: List<IDOLanguageLibraryItem>?
) : IDOBaseModel {

    @SerializedName("version")
    private var version: Int = 0

    /// Currently used language
    @SerializedName("use_lang")
    var useLang: Int = useLang

    /// Default language
    @SerializedName("default_lang")
    var defaultLang: Int = defaultLang

    /// Number of fixed storage languages
    @SerializedName("fixed_lang")
    var fixedLang: Int = fixedLang

    /// Maximum storage languages
    @SerializedName("max_storage_lang")
    var maxStorageLang: Int = maxStorageLang
    @SerializedName("items_len")
    private var itemsLen: Int = items?.size ?: 0
    @SerializedName("user_len")
    private var userLen: Int = itemsUser?.size ?: 0

    @SerializedName("items")
    var items: List<IDOLanguageLibraryItem>? = items

    @SerializedName("items_user")
    var itemsUser: List<IDOLanguageLibraryItem>? = itemsUser




    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}


// MARK: - IDOLanguageLibraryItem
class IDOLanguageLibraryItem(languageType: IDOLanguageType, languageVersion: Int) {
    /// Language type
    @SerializedName("language_type")
    @JsonAdapter(LanEnumToIntConverter::class)
    var languageType: IDOLanguageType = languageType

    /// Language version number
    @SerializedName("language_version")
    var languageVersion: Int = languageVersion

}

private class LanEnumToIntConverter : JsonSerializer<IDOLanguageType>,
    JsonDeserializer<IDOLanguageType> {

    override fun serialize(
        src: IDOLanguageType,
        typeOfSrc: Type,
        context: JsonSerializationContext
    ): JsonElement {
        return JsonPrimitive(src.raw)
    }

    override fun deserialize(
        json: JsonElement,
        typeOfT: Type,
        context: JsonDeserializationContext
    ): IDOLanguageType {

        val value = json.asInt
        return IDOLanguageType.values().find { it.raw == value } ?: IDOLanguageType.invalid
    }
}

enum class IDOLanguageType(val raw: Int) {
    invalid(0),
    chinese(1),
    english(2),
    french(3),
    german(4),
    italian(5),
    spanish(6),
    japanese(7),
    polish(8),
    czech(9),
    romanian(10),
    lithuanian(11),
    dutch(12),
    slovenian(13),
    hungarian(14),
    russian(15),
    ukrainian(16),
    slovak(17),
    danish(18),
    croatian(19),
    indonesian(20),
    korean(21),
    hindi(22),
    portuguese(23),
    turkish(24),
    thai(25),
    vietnamese(26),
    burmese(27),
    filipino(28),
    traditionalChinese(29),
    greek(30),
    arabic(31),
    swedish(32),
    finnish(33),
    persian(34),
    norwegian(35),
    malay(36),
    brazilianPortuguese(37),
    bengali(38),
    khmer(39),
    serbian(40),
    bulgaria(41),
    hebrew(42);

    companion object {
        fun ofRaw(raw: Int): IDOLanguageType? {
            return IDOLanguageType.values().firstOrNull { it.raw == raw }
        }
    }
}
