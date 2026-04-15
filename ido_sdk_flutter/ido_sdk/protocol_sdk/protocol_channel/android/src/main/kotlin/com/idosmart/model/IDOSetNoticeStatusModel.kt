package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.JsonDeserializationContext
import com.google.gson.JsonDeserializer
import com.google.gson.JsonElement
import com.google.gson.JsonObject
import com.google.gson.JsonSerializationContext
import com.google.gson.JsonSerializer
import java.lang.reflect.Type

// TODO: 安卓此类只用到属性callSwitch，待调整（修改会影响到已接入的客户）
open class IDOSetNoticeStatusModel(): IDOBaseAdapterModel<IDOSetNoticeStatusModel> {

    /// Notification reminder switch
    var notifySwitch: IDONoticeNotifySwitchState = IDONoticeNotifySwitchState.INVALID

    /// Incoming call reminder switch
    var callSwitch: IDONoticeCallSwitchState = IDONoticeCallSwitchState.INVALID

    /// Message app total switch
    var msgAllSwitch: IDONoticeMsgAllSwitchState = IDONoticeMsgAllSwitchState.INVALID

    /// 来电延迟 | Call delay
    var callDelay: Int = 0

    /// 短信提醒 | SMS reminder
    var isOnSms: Boolean = false

    /// 邮件提醒 | Email alert
    var isOnEmail: Boolean = false

    /// 微信提醒 | WeChat reminder
    var isOnWeChat: Boolean = false

    /// qq提醒 | qq reminder
    var isOnQq: Boolean = false

    /// 微博提醒 | Weibo reminder
    var isOnWeibo: Boolean = false

    /// FaceBook 提醒 | FaceBook Reminder
    var isOnFaceBook: Boolean = false

    /// Twitter 提醒 | Twitter Reminder
    var isOnTwitter: Boolean = false

    /// Whatsapp 提醒 | Whatsapp Reminder
    var isOnWhatsapp: Boolean = false

    /// Messenger 提醒 | Messenger reminder
    var isOnMessenger: Boolean = false

    /// Instagram 提醒 | Instagram reminder
    var isOnInstagram: Boolean = false

    /// LinkedIn 提醒 | LinkedIn Reminder
    var isOnLinkedIn: Boolean = false

    /// Calendar 提醒 | Calendar Reminder
    var isOnCalendar: Boolean = false

    /// Skype 提醒 | Skype reminder
    var isOnSkype: Boolean = false

    /// Alarm 提醒 | Alarm Reminder
    var isOnAlarm: Boolean = false

    /// Pokeman (其他)提醒 | Pokemon Reminder(other)
    var isOnPokeman: Boolean = false

    /// Vkontakte 提醒 | Vkontakte Reminder
    var isOnVkontakte: Boolean = false

    /// Line 提醒 | Line reminder
    var isOnLine: Boolean = false

    /// Viber 提醒 | Viber reminder
    var isOnViber: Boolean = false

    /// KakaoTalk 提醒 | KakaoTalk Reminder
    var isOnKakaoTalk: Boolean = false

    /// Gmail 提醒 | Gmail reminder
    var isOnGmail: Boolean = false

    /// Outlook 提醒 | Outlook reminder
    var isOnOutlook: Boolean = false

    /// Snapchat 提醒 | Snapchat Reminder
    var isOnSnapchat: Boolean = false

    /// Telegram 提醒 | Telegram Reminder
    var isOnTelegram: Boolean = false

    /// Chatwork 提醒 | Chatwork
    var isOnChatwork: Boolean = false

    /// Slack 提醒 | Slack
    var isOnSlack: Boolean = false

    /// Yahoo Mail 提醒 | Yahoo Mail
    var isOnYahooMail: Boolean = false

    /// Tumblr 提醒 | Tumblr
    var isOnTumblr: Boolean = false

    /// Youtube 提醒 | Youtube
    var isOnYoutube: Boolean = false

    /// Yahoo Pinterest 提醒 | Yahoo Pinterest
    var isOnYahooPinterest: Boolean = false

    /// Keep 提醒 | keep
    var isOnKeep: Boolean = false

    /// TikTok 提醒 | tiktok
    var isOnTikTok: Boolean = false

    /// Redbus 提醒 | redbus
    var isOnRedbus: Boolean = false

    /// Dailyhunt 提醒 | dailyhunt
    var isOnDailyhunt: Boolean = false

    /// Hotstar 提醒 | hotstar
    var isOnHotstar: Boolean = false

    /// Inshorts 提醒 | inshorts
    var isOnInshorts: Boolean = false

    /// Paytm 提醒 | paytm
    var isOnPaytm: Boolean = false

    /// Amazon 提醒 | amazon
    var isOnAmazon: Boolean = false

    /// Flipkart 提醒 | flipkart
    var isOnFlipkart: Boolean = false

    /// Prime 提醒 | prime
    var isOnPrime: Boolean = false

    /// Netflix 提醒 | netflix
    var isOnNetflix: Boolean = false

    /// Gpay 提醒 | gpay
    var isOnGpay: Boolean = false

    /// Phonpe 提醒 | phonpe
    var isOnPhonpe: Boolean = false

    /// Swiggy 提醒 | swiggy
    var isOnSwiggy: Boolean = false

    /// Zomato 提醒 | zomato
    var isOnZomato: Boolean = false

    /// MakeMyTrip 提醒 | make my trip
    var isOnMakeMyTrip: Boolean = false

    /// JioTv 提醒 | jio tv
    var isOnJioTv: Boolean = false

    /// Microsoft 提醒 | Microsoft
    var isOnMicrosoft: Boolean = false

    /// WhatsApp Business 提醒 | WhatsApp Business
    var isOnWhatsAppBusiness: Boolean = false
    /// nioseFit 提醒 | noiseFit
    var isOnNioseFit: Boolean = false
    /// did no call 提醒 | did no call
    var isOnDidNotCall: Boolean = false
    /// 事项 提醒 | matters remind
    var isOnMattersRemind: Boolean = false
    /// uber 提醒 | uber
    var isOnUber: Boolean = false
    /// ola 提醒 | ola
    var isOnOla: Boolean = false
    /// yt music 提醒 | yt music
    var isOnYtMusic: Boolean = false
    /// google meet 提醒
    var isOnGoogleMeet: Boolean = false
    /// mormaii smartwatch 提醒
    var isOnMormaiiSmartwatch: Boolean = false
    /// technos connect 提醒
    var isOnTechnosConnect: Boolean = false
    /// enioei 提醒
    var isOnEnioei: Boolean = false
    /// aliexpress 提醒
    var isOnAliexpress: Boolean = false
    /// shopee 提醒
    var isOnShopee: Boolean = false
    /// teams 提醒
    var isOnTeams: Boolean = false
    /// 99 taxi 提醒
    var isOn99Taxi: Boolean = false
    /// uber eats 提醒
    var isOnUberEats: Boolean = false
    /// l food 提醒
    var isOnLfood: Boolean = false
    /// rappi 提醒
    var isOnRappi: Boolean = false
    /// mercado Livre 提醒
    var isOnMercadoLivre: Boolean = false
    /// Magalu 提醒
    var isOnMagalu: Boolean = false
    /// Americanas 提醒
    var isOnAmericanas: Boolean = false
    /// Yahoo 提醒
    var isOnYahoo: Boolean = false

    /// Instantemail 提醒 | 支持Instantemail的功能表
    var isOnInstantemail: Boolean = false

    /// nhnemail 提醒 | 支持NAVER邮件的功能表
    var isOnNhnemail: Boolean = false
    /// zohoemail 提醒 | 支持ZoHo邮箱的功能表
    var isOnZohoemail: Boolean = false
    /// Exchangeemail 提醒 | 支持Exchange+ Mail Client 交换邮件的功能表
    var isOnExchangeemail: Boolean = false
    /// 189email 提醒 | 支持189邮件的功能表
    var isOn189email: Boolean = false
    /// googleGmail 提醒 | 支持谷歌邮箱的功能表
    var isOnGoogleGmail: Boolean = false
    /// Veryfit 提醒 的功能表 0x4F
    var isOnVeryfit: Boolean = false

    /// general 提醒 | 通知支持通用的功能表 0x50
    var isOnGeneral: Boolean = false
    /// 189email 提醒 |  通知支持阿里巴巴邮箱的功能表 type:0x51
    var isOnAlibabaemail: Boolean = false

    companion object {
        fun createDefaultModel(): IDOSetNoticeStatusModel {
            val gsonBuilder = GsonBuilder()
            gsonBuilder.registerTypeAdapter(
                IDOSetNoticeStatusModel::class.java,
                SetNoticeStatusModelSerializer()
            )
            val jsonStr = "{\"call_delay\":0,\"call_switch\":1,\"msg_all_switch\":1,\"notify_item1\":255,\"notify_item2\":255,\"notify_item3\":255,\"notify_item4\":253,\"notify_item5\":255,\"notify_item6\":255,\"notify_item7\":255,\"notify_item8\":255,\"notify_item9\":255,\"notify_item10\":255,\"notify_item11\":255,\"notify_item12\":255,\"notify_switch\":2}"
            val gson = gsonBuilder.create()
            val rs = gson.fromJson(jsonStr, IDOSetNoticeStatusModel::class.java)
            return rs
        }

        fun createAllOffModel(): IDOSetNoticeStatusModel {
            val gsonBuilder = GsonBuilder()
            gsonBuilder.registerTypeAdapter(
                IDOSetNoticeStatusModel::class.java,
                SetNoticeStatusModelSerializer()
            )
            val jsonStr = "{\"call_delay\":0,\"call_switch\":0,\"msg_all_switch\":0,\"notify_item1\":0,\"notify_item2\":0,\"notify_item3\":0,\"notify_item4\":0,\"notify_item5\":0,\"notify_item6\":0,\"notify_item7\":0,\"notify_item8\":0,\"notify_item9\":0,\"notify_item10\":0,\"notify_item11\":0,\"notify_item12\":0,\"notify_switch\":2}"
            val gson = gsonBuilder.create()
            val rs = gson.fromJson(jsonStr, IDOSetNoticeStatusModel::class.java)
            return rs
        }
    }

    override fun getDeSerializer(): IDOBaseModelDeSerializer<IDOSetNoticeStatusModel>? {
        return SetNoticeStatusModelSerializer()
    }

    override fun toString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}

enum class IDONoticeNotifySwitchState(val rawValue: Int) {
    /// Invalid(Not Support)
    INVALID(-1),
    /// BLE switch off(Reserved,invalid function)
    BLEOFF(0),
    /// BLE switch on(Initiate pairing for IOS only)
    BLEON(1),
    /// Setting sub-switch
    SETTINGSUBSWITCH(2),
    /// BT only (switch)
    BTONLYSWITCH(3),
    /// BLE and BT on (switch)
    BLEANDBTON(4);

    companion object {
        fun fromRawValue(value: Int): IDONoticeNotifySwitchState {
            return IDONoticeNotifySwitchState.values().find { it.rawValue == value } ?: IDONoticeNotifySwitchState.INVALID
        }
    }
}

enum class IDONoticeCallSwitchState(val rawValue: Int) {
    INVALID(-1),
    OFF(0),
    ON(1);

    companion object {
        fun fromRawValue(value: Int): IDONoticeCallSwitchState {
            return IDONoticeCallSwitchState.values().find { it.rawValue == value } ?: IDONoticeCallSwitchState.INVALID
        }
    }
}

enum class IDONoticeMsgAllSwitchState(val rawValue: Int) {
    INVALID(-1),
    OFF(0),
    ON(1);

    companion object {
        fun fromRawValue(value: Int): IDONoticeMsgAllSwitchState {
            return IDONoticeMsgAllSwitchState.values().find { it.rawValue == value } ?: IDONoticeMsgAllSwitchState.INVALID
        }
    }
}

// Serializer & Deserializer
internal class SetNoticeStatusModelSerializer  : IDOBaseModelDeSerializer<IDOSetNoticeStatusModel> {
    override fun serialize(src: IDOSetNoticeStatusModel, typeOfSrc: Type, context: JsonSerializationContext): JsonElement {
        val jsonObject = JsonObject()
        jsonObject.addProperty("call_delay", src.callDelay)
        jsonObject.addProperty("call_switch", src.callSwitch.rawValue)
        jsonObject.addProperty("msg_all_switch", src.msgAllSwitch.rawValue)
        jsonObject.addProperty("notify_switch", src.notifySwitch.rawValue)

        var item: Array<Boolean?> = arrayOf(
            null,
            src.isOnSms,
            src.isOnEmail,
            src.isOnWeChat,
            src.isOnQq,
            src.isOnWeibo,
            src.isOnFaceBook,
            src.isOnTwitter)
        jsonObject.addProperty("notify_item1", item.toInt())

        item = arrayOf(
            src.isOnWhatsapp,
            src.isOnMessenger,
            src.isOnInstagram,
            src.isOnLinkedIn,
            src.isOnCalendar,
            src.isOnSkype,
            src.isOnAlarm,
            src.isOnPokeman)
        jsonObject.addProperty("notify_item2", item.toInt())

        item = arrayOf(
            src.isOnVkontakte,
            src.isOnLine,
            src.isOnViber,
            src.isOnKakaoTalk,
            src.isOnGmail,
            src.isOnOutlook,
            src.isOnSnapchat,
            src.isOnTelegram)
        jsonObject.addProperty("notify_item3", item.toInt())

        item = arrayOf(
            src.isOnChatwork,
            src.isOnSlack,
            src.isOnYahooMail,
            src.isOnTumblr,
            src.isOnYoutube,
            src.isOnYahooPinterest,
            src.isOnKeep,
            null)
        jsonObject.addProperty("notify_item4", item.toInt())

        item = arrayOf(
            src.isOnTikTok,
            src.isOnRedbus,
            src.isOnDailyhunt,
            src.isOnHotstar,
            src.isOnInshorts,
            src.isOnPaytm,
            src.isOnAmazon,
            src.isOnFlipkart)
        jsonObject.addProperty("notify_item5", item.toInt())

        item = arrayOf(
            src.isOnPrime,
            src.isOnNetflix,
            src.isOnGpay,
            src.isOnPhonpe,
            src.isOnSwiggy,
            src.isOnZomato,
            src.isOnMakeMyTrip,
            src.isOnJioTv)
        jsonObject.addProperty("notify_item6", item.toInt())

        item = arrayOf(
            src.isOnMicrosoft,
            src.isOnWhatsAppBusiness,
            src.isOnNioseFit,
            src.isOnDidNotCall,
            src.isOnYtMusic,
            src.isOnUber,
            src.isOnOla,
            src.isOnMattersRemind)
        jsonObject.addProperty("notify_item7", item.toInt())

        item = arrayOf(
            src.isOnGoogleMeet,
            null, null, null,
            src.isOnMormaiiSmartwatch,
            src.isOnTechnosConnect,
            src.isOnMagalu,
            src.isOnAmericanas)
        jsonObject.addProperty("notify_item8", item.toInt())

        item = arrayOf(
            src.isOnEnioei,
            src.isOnAliexpress,
            src.isOnShopee,
            src.isOnTeams,
            src.isOn99Taxi,
            src.isOnUberEats,
            src.isOnLfood,
            src.isOnRappi)
        jsonObject.addProperty("notify_item9", item.toInt())

        item = arrayOf(
            src.isOnMercadoLivre,
            src.isOnYahoo,
            null,null, null,null,null,null)
        jsonObject.addProperty("notify_item10", item.toInt())

        item = arrayOf(
            src.isOnInstantemail,
            src.isOnNhnemail,
            src.isOnZohoemail,
            src.isOnExchangeemail,
            src.isOn189email,
            src.isOnGoogleGmail,
            src.isOnVeryfit,
            src.isOnGeneral)
        jsonObject.addProperty("notify_item11", item.toInt())

        item = arrayOf(
            src.isOnAlibabaemail,
            null,null,null,null,null,null,null)
        jsonObject.addProperty("notify_item12", item.toInt())
        return jsonObject
    }

    override fun deserialize(
        json: JsonElement?,
        typeOfT: Type?,
        context: JsonDeserializationContext?
    ): IDOSetNoticeStatusModel? {
        json?.let {
            val model = IDOSetNoticeStatusModel()
            val jsonObject = it.asJsonObject
            model.callDelay = jsonObject.get("call_delay").asInt
            model.callSwitch = IDONoticeCallSwitchState.fromRawValue(jsonObject.get("call_switch").asInt)
            model.msgAllSwitch = IDONoticeMsgAllSwitchState.fromRawValue(jsonObject.get("msg_all_switch").asInt)
            model.notifySwitch = IDONoticeNotifySwitchState.fromRawValue(jsonObject.get("notify_switch").asInt)

            var item = jsonObject.get("notify_item1").asInt
            var bits = item.toBits()
            model.isOnSms         = bits[1] != 0
            model.isOnEmail       = bits[2] != 0
            model.isOnWeChat      = bits[3] != 0
            model.isOnQq          = bits[4] != 0
            model.isOnWeibo       = bits[5] != 0
            model.isOnFaceBook    = bits[6] != 0
            model.isOnTwitter     = bits[7] != 0

            item = jsonObject.get("notify_item2").asInt
            bits = item.toBits()
            model.isOnWhatsapp   = bits[0] != 0
            model.isOnMessenger  = bits[1] != 0
            model.isOnInstagram  = bits[2] != 0
            model.isOnLinkedIn   = bits[3] != 0
            model.isOnCalendar   = bits[4] != 0
            model.isOnSkype      = bits[5] != 0
            model.isOnAlarm      = bits[6] != 0
            model.isOnPokeman    = bits[7] != 0

            item = jsonObject.get("notify_item3").asInt
            bits = item.toBits()
            model.isOnVkontakte   = bits[0] != 0
            model.isOnLine        = bits[1] != 0
            model.isOnViber       = bits[2] != 0
            model.isOnKakaoTalk   = bits[3] != 0
            model.isOnGmail       = bits[4] != 0
            model.isOnOutlook     = bits[5] != 0
            model.isOnSnapchat    = bits[6] != 0
            model.isOnTelegram    = bits[7] != 0

            item = jsonObject.get("notify_item4").asInt
            bits = item.toBits()
            model.isOnChatwork        = bits[1] != 0
            model.isOnSlack           = bits[2] != 0
            model.isOnYahooMail       = bits[3] != 0
            model.isOnTumblr          = bits[4] != 0
            model.isOnYoutube         = bits[5] != 0
            model.isOnYahooPinterest  = bits[5] != 0
            model.isOnKeep            = bits[7] != 0

            item = jsonObject.get("notify_item5").asInt
            bits = item.toBits()
            model.isOnTikTok      = bits[0] != 0
            model.isOnRedbus      = bits[1] != 0
            model.isOnDailyhunt   = bits[2] != 0
            model.isOnHotstar     = bits[3] != 0
            model.isOnInshorts    = bits[4] != 0
            model.isOnPaytm       = bits[5] != 0
            model.isOnAmazon      = bits[6] != 0
            model.isOnFlipkart    = bits[7] != 0

            item = jsonObject.get("notify_item6").asInt
            bits = item.toBits()
            model.isOnPrime       = bits[0] != 0
            model.isOnNetflix     = bits[1] != 0
            model.isOnGpay        = bits[2] != 0
            model.isOnPhonpe      = bits[3] != 0
            model.isOnSwiggy      = bits[4] != 0
            model.isOnZomato      = bits[5] != 0
            model.isOnMakeMyTrip  = bits[6] != 0
            model.isOnJioTv       = bits[7] != 0

            item = jsonObject.get("notify_item7").asInt
            bits = item.toBits()
            model.isOnMicrosoft           = bits[0] != 0
            model.isOnWhatsAppBusiness    = bits[1] != 0
            model.isOnNioseFit            = bits[2] != 0
            model.isOnDidNotCall          = bits[3] != 0
            model.isOnYtMusic             = bits[4] != 0
            model.isOnUber                = bits[5] != 0
            model.isOnOla                 = bits[6] != 0
            model.isOnMattersRemind       = bits[7] != 0

            item = jsonObject.get("notify_item8").asInt
            bits = item.toBits()
            model.isOnGoogleMeet   = bits[0] != 0
            model.isOnMormaiiSmartwatch   = bits[4] != 0
            model.isOnTechnosConnect      = bits[5] != 0
            model.isOnMagalu              = bits[6] != 0
            model.isOnAmericanas          = bits[7] != 0

            item = jsonObject.get("notify_item9").asInt
            bits = item.toBits()
            model.isOnEnioei      = bits[0] != 0
            model.isOnAliexpress   = bits[1] != 0
            model.isOnShopee      = bits[2] != 0
            model.isOnTeams       = bits[3] != 0
            model.isOn99Taxi      = bits[4] != 0
            model.isOnUberEats    = bits[5] != 0
            model.isOnLfood       = bits[6] != 0
            model.isOnRappi       = bits[7] != 0

            item = jsonObject.get("notify_item10").asInt
            bits = item.toBits()
            model.isOnMercadoLivre    = bits[0] != 0
            model.isOnYahoo           = bits[1] != 0

            item = jsonObject.get("notify_item11").asInt
            bits = item.toBits()
            model.isOnInstantemail    = bits[0] != 0
            model.isOnNhnemail        = bits[1] != 0
            model.isOnZohoemail       = bits[2] != 0
            model.isOnExchangeemail   = bits[3] != 0
            model.isOn189email        = bits[4] != 0
            model.isOnGoogleGmail     = bits[5] != 0
            model.isOnVeryfit         = bits[6] != 0
            model.isOnGeneral         = bits[7] != 0

            item = jsonObject.get("notify_item12").asInt
            bits = item.toBits()
            model.isOnAlibabaemail   = bits[0] != 0

            return model
        }
        return null
    }
}

private fun Array<Boolean?>.toInt(): Int {
    val bits = map { if (it != null && it == true) 1 else 0 }
    val intValue = bits.fold(0) { acc, bit -> (acc shl 1) + bit }
    return intValue
}

private fun Int.toBits(): List<Int> {
    val bits = IntArray(8) { 0 }
    for (i in 0 until 8) {
        val mask = 1 shl i
        bits[i] = (this and mask) shr i
    }
    return bits.reversed()
}