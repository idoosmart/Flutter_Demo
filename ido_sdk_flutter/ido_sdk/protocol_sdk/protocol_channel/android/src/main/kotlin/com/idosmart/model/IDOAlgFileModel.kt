package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

open class IDOAlgFileModel(
    errorCode: Int,
    items: List<IDOAlgFileItem>?,
    itemsNum: Int,
    operate: Int,
    version: Int = 0

) : IDOBaseModel {
    @SerializedName("error_code")
    var errorCode: Int = errorCode;

    @SerializedName("items")
    var items: List<IDOAlgFileItem>? = items

    @SerializedName("operate")
    var operate: Int = operate;

    @SerializedName("items_num")
    var itemsNum: Int = itemsNum;

    @SerializedName("version")
    private var version: Int = version;


    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}

open class IDOAlgFileItem(
    quantityComplete: Int,
    totalQuantity: Int,
    type: Int
) : IDOBaseModel {
    @SerializedName("quantity_complete")
    var quantityComplete: Int = quantityComplete

    @SerializedName("total_quantity")
    var totalQuantity: Int = totalQuantity

    @SerializedName("type")
    var type: Int = type


    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }

}