package com.idosmart.pigeon_implement

import com.idosmart.pigeongen.api_message_icon.MessageIconDelegate

internal class MessageIconDelegateImpl: MessageIconDelegate {

    companion object {
        @Volatile
        private var instance: MessageIconDelegateImpl? = null
        fun instance(): MessageIconDelegateImpl {
            return instance ?: synchronized(this) {
                instance ?: MessageIconDelegateImpl().also { instance = it }
            }
        }
    }

    var updating : Boolean = false
    var dirPath: String = ""

    override fun listenMessageIconState(updating: Boolean) {
       this.updating = updating
    }

    override fun listenIconDirPath(path: String) {
       this.dirPath = path
    }

}