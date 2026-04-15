package com.idosmart.pigeon_implement

import com.google.gson.GsonBuilder
import com.idosmart.pigeongen.api_func_table.FuncTableDelegate
import com.idosmart.model.FunctionTableModel
import com.idosmart.protocol_sdk.FuncTableInterface

internal class FuncTableDelegateImpl:FuncTableDelegate {

    companion object {
        @Volatile
        private var instance: FuncTableDelegateImpl? = null
        fun instance(): FuncTableDelegateImpl {
            return instance ?: synchronized(this) {
                instance ?: FuncTableDelegateImpl().also { instance = it }
            }
        }
    }

    private var _funcTableInfo: FunctionTableModel? = null

    var callbackFuncTable: ((FuncTableInterface) -> Unit)? = null

    val funcTableInfo: FunctionTableModel? get() {
        return _funcTableInfo
    }

    override fun listenFuncTableChanged(funcTableJson: String) {
        val gson = GsonBuilder().create()
        val obj = gson.fromJson(funcTableJson, FunctionTableModel::class.java)
        _funcTableInfo = obj
    }

    override fun listenFuncTableOnBind(funcTableJson: String) {
        val gson = GsonBuilder().create()
        val obj = gson.fromJson(funcTableJson, FunctionTableModel::class.java)
        val funcTable = IDOFuncTable(obj)
       callbackFuncTable?.invoke(funcTable)
        callbackFuncTable = null
    }

}