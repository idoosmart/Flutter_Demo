//
//  IDODownloadLanguageModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///

//private object GsonTester {
//    @JvmStatic
//    fun main(args: Array<String>) {
//        val builder = GsonBuilder()
//        val gson: Gson = builder.create()
//        var jsonString = "{\"use_lang\":1,\"default_lang\":1,\"fixed_lang\":1,\"max_storage_lang\":1,\"lang_array\":[{\"type\":1},{\"type\":2},{\"type\":3},{\"type\":4}]}"
//        val student: IDODownloadLanguageModel =
//            gson.fromJson(jsonString, IDODownloadLanguageModel::class.java)
//        println(student)
//        jsonString = gson.toJson(student)
//        println(jsonString)
//    }
//}

open class IDODownloadLanguageModel(
    useLang: Int,
    defaultLang: Int,
    fixedLang: Int,
    maxStorageLang: Int,
    langArray: List<IDODownloadLanguageType>
) : IDOBaseModel {

    /// Current used language
    @SerializedName("use_lang")
    var useLang: Int = useLang

    /// Default language
    @SerializedName("default_lang")
    var defaultLang: Int = defaultLang

    /// Number of fixed stored languages
    @SerializedName("fixed_lang")
    var fixedLang: Int = fixedLang

    /// Maximum stored languages
    @SerializedName("max_storage_lang")
    var maxStorageLang: Int = maxStorageLang

    /// List of stored language values
    @SerializedName("lang_array")
    var langArray: List<IDODownloadLanguageType> = langArray


    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}

// MARK: - IDOLangArray
open class IDODownloadLanguageType(type: Int) {
    /// Stored language values, ended by 0
    @SerializedName("type")
    var type: Int = type
}
