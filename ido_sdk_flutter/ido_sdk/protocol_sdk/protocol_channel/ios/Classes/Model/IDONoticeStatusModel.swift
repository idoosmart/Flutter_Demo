//
//  IDONoticeStatusModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation

@objcMembers
public class IDOSetNoticeStatusModel: NSObject, IDOBaseModel {
    /// Notification reminder switch
    public var notifySwitch: IDONoticeNotifySwitchState

    /// Incoming call reminder switch
    public var callSwitch: IDONoticeCallSwitchState

    /// Message app total switch
    public var msgAllSwitch: IDONoticeMsgAllSwitchState

    /// 来电延迟 | Call delay
    public var callDelay: Int
    
    /// 短信提醒 | SMS reminder
    public var isOnSms: Bool = false

    /// 邮件提醒 | Email alert
    public var isOnEmail: Bool = false

    /// 微信提醒 | WeChat reminder
    public var isOnWeChat: Bool = false

    /// qq提醒 | qq reminder
    public var isOnQq: Bool = false

    /// 微博提醒 | Weibo reminder
    public var isOnWeibo: Bool = false

    /// FaceBook 提醒 | FaceBook Reminder
    public var isOnFaceBook: Bool = false

    /// Twitter 提醒 | Twitter Reminder
    public var isOnTwitter: Bool = false

    /// Whatsapp 提醒 | Whatsapp Reminder
    public var isOnWhatsapp: Bool = false

    /// Messenger 提醒 | Messenger reminder
    public var isOnMessenger: Bool = false

    /// Instagram 提醒 | Instagram reminder
    public var isOnInstagram: Bool = false

    /// LinkedIn 提醒 | LinkedIn Reminder
    public var isOnLinkedIn: Bool = false

    /// Calendar 提醒 | Calendar Reminder
    public var isOnCalendar: Bool = false

    /// Skype 提醒 | Skype reminder
    public var isOnSkype: Bool = false

    /// Alarm 提醒 | Alarm Reminder
    public var isOnAlarm: Bool = false

    /// (其他)提醒 |  Reminder(other)
    public var isOnOther: Bool = false

    /// Vkontakte 提醒 | Vkontakte Reminder
    public var isOnVkontakte: Bool = false

    /// Line 提醒 | Line reminder
    public var isOnLine: Bool = false

    /// Viber 提醒 | Viber reminder
    public var isOnViber: Bool = false

    /// KakaoTalk 提醒 | KakaoTalk Reminder
    public var isOnKakaoTalk: Bool = false

    /// Gmail 提醒 | Gmail reminder
    public var isOnGmail: Bool = false

    /// Outlook 提醒 | Outlook reminder
    public var isOnOutlook: Bool = false

    /// Snapchat 提醒 | Snapchat Reminder
    public var isOnSnapchat: Bool = false

    /// Telegram 提醒 | Telegram Reminder
    public var isOnTelegram: Bool = false

    /// Chatwork 提醒 | Chatwork
    public var isOnChatwork: Bool = false

    /// Slack 提醒 | Slack
    public var isOnSlack: Bool = false

    /// Yahoo Mail 提醒 | Yahoo Mail
    public var isOnYahooMail: Bool = false

    /// Tumblr 提醒 | Tumblr
    public var isOnTumblr: Bool = false

    /// Youtube 提醒 | Youtube
    public var isOnYoutube: Bool = false

    /// Yahoo Pinterest 提醒 | Yahoo Pinterest
    public var isOnYahooPinterest: Bool = false

    /// Keep 提醒 | keep
    public var isOnKeep: Bool = false

    /// TikTok 提醒 | tiktok
    public var isOnTikTok: Bool = false

    /// Redbus 提醒 | redbus
    public var isOnRedbus: Bool = false

    /// Dailyhunt 提醒 | dailyhunt
    public var isOnDailyhunt: Bool = false

    /// Hotstar 提醒 | hotstar
    public var isOnHotstar: Bool = false

    /// Inshorts 提醒 | inshorts
    public var isOnInshorts: Bool = false

    /// Paytm 提醒 | paytm
    public var isOnPaytm: Bool = false

    /// Amazon 提醒 | amazon
    public var isOnAmazon: Bool = false

    /// Flipkart 提醒 | flipkart
    public var isOnFlipkart: Bool = false

    /// Prime 提醒 | prime
    public var isOnPrime: Bool = false

    /// Netflix 提醒 | netflix
    public var isOnNetflix: Bool = false

    /// Gpay 提醒 | gpay
    public var isOnGpay: Bool = false

    /// Phonpe 提醒 | phonpe
    public var isOnPhonpe: Bool = false

    /// Swiggy 提醒 | swiggy
    public var isOnSwiggy: Bool = false

    /// Zomato 提醒 | zomato
    public var isOnZomato: Bool = false

    /// MakeMyTrip 提醒 | make my trip
    public var isOnMakeMyTrip: Bool = false

    /// JioTv 提醒 | jio tv
    public var isOnJioTv: Bool = false

    /// Microsoft 提醒 | Microsoft
    public var isOnMicrosoft: Bool = false

    /// WhatsApp Business 提醒 | WhatsApp Business
    public var isOnWhatsAppBusiness: Bool = false
    /// nioseFit 提醒 | noiseFit
    public var isOnNioseFit: Bool = false
    /// did no call 提醒 | did no call
    public var isOnDidNotCall: Bool = false
    /// 事项 提醒 | matters remind
    public var isOnMattersRemind: Bool = false
    /// uber 提醒 | uber
    public var isOnUber: Bool = false
    /// ola 提醒 | ola
    public var isOnOla: Bool = false
    /// yt music 提醒 | yt music
    public var isOnYtMusic: Bool = false
    /// google meet 提醒
    public var isOnGoogleMeet: Bool = false
    /// mormaii smartwatch 提醒
    public var isOnMormaiiSmartwatch: Bool = false
    /// technos connect 提醒
    public var isOnTechnosConnect: Bool = false
    /// enioei 提醒
    public var isOnEnioei: Bool = false
    /// aliexpress 提醒
    public var isOnAliexpress: Bool = false
    /// shopee 提醒
    public var isOnShopee: Bool = false
    /// teams 提醒
    public var isOnTeams: Bool = false
    /// 99 taxi 提醒
    public var isOn99Taxi: Bool = false
    /// uber eats 提醒
    public var isOnUberEats: Bool = false
    /// l food 提醒
    public var isOnLfood: Bool = false
    /// rappi 提醒
    public var isOnRappi: Bool = false
    /// mercado Livre 提醒
    public var isOnMercadoLivre: Bool = false
    /// Magalu 提醒
    public var isOnMagalu: Bool = false
    /// Americanas 提醒
    public var isOnAmericanas: Bool = false
    /// Yahoo 提醒
    public var isOnYahoo: Bool = false

    /// Instantemail 提醒 | 支持Instantemail的功能表
    public var isOnInstantemail: Bool = false

    /// nhnemail 提醒 | 支持NAVER邮件的功能表
    public var isOnNhnemail: Bool = false
    /// zohoemail 提醒 | 支持ZoHo邮箱的功能表
    public var isOnZohoemail: Bool = false
    /// Exchangeemail 提醒 | 支持Exchange+ Mail Client 交换邮件的功能表
    public var isOnExchangeemail: Bool = false
    /// 189email 提醒 | 支持189邮件的功能表
    public var isOn189email: Bool = false
    /// googleGmail 提醒 | 支持谷歌邮箱的功能表
    public var isOnGoogleGmail: Bool = false
    /// Veryfit 提醒 的功能表 0x4F
    public var isOnVeryfit: Bool = false

    /// general 提醒 | 通知支持通用的功能表 0x50
    public var isOnGeneral: Bool = false
    /// 189email 提醒 |  通知支持阿里巴巴邮箱的功能表 type:0x51
    public var isOnAlibabaemail: Bool = false
    
    /// Calendario(谷歌日历)
    public var isOnGoogleCalendario: Bool = false
    /// Fastrack Reflex World
    public var isOnFastrackReflexWorld: Bool = false
    /// Hama Fit Move
    public var isOnHamaFitMove: Bool = false
    /// 淘宝
    public var isOnTaobao: Bool = false
    /// 钉钉(DingTalk)
    public var isOnDingTalk: Bool = false
    /// 支付宝(Alipay)
    public var isOnAlipay: Bool = false
    /// 今日头条(Toutiao)
    public var isOnToutiao: Bool = false

    enum CodingKeys: String, CodingKey {
        case notifySwitch = "notify_switch"
        case callSwitch = "call_switch"
        case notifyItem1 = "notify_item1"
        case notifyItem2 = "notify_item2"
        case callDelay = "call_delay"
        case notifyItem3 = "notify_item3"
        case notifyItem4 = "notify_item4"
        case notifyItem5 = "notify_item5"
        case notifyItem6 = "notify_item6"
        case notifyItem7 = "notify_item7"
        case notifyItem8 = "notify_item8"
        case notifyItem9 = "notify_item9"
        case notifyItem10 = "notify_item10"
        case msgAllSwitch = "msg_all_switch"
        case notifyItem11 = "notify_item11"
        case notifyItem12 = "notify_item12"
    }
    
    public static func createDefaultModel() -> IDOSetNoticeStatusModel {
        let jsonStr = """
            {
                \"call_delay\": 0,
                \"call_switch\": 1,
                \"msg_all_switch\": 1,
                \"notify_item1\": 255,
                \"notify_item2\": 255,
                \"notify_item3\": 255,
                \"notify_item4\": 253,
                \"notify_item5\": 255,
                \"notify_item6\": 255,
                \"notify_item7\": 255,
                \"notify_item8\": 255,
                \"notify_item9\": 255,
                \"notify_item10\": 255,
                \"notify_item11\": 255,
                \"notify_item12\": 255,
                \"notify_switch\": 2
            }
        """
        let jsonData = jsonStr.data(using: .utf8)
        let obj = try! JSONDecoder().decode(IDOSetNoticeStatusModel.self, from: jsonData!)
        return obj
    }
    
    public static func createAllOffModel() -> IDOSetNoticeStatusModel {
        let jsonStr = """
            {
                \"call_delay\": 0,
                \"call_switch\": 0,
                \"msg_all_switch\": 0,
                \"notify_item1\": 0,
                \"notify_item2\": 0,
                \"notify_item3\": 0,
                \"notify_item4\": 0,
                \"notify_item5\": 0,
                \"notify_item6\": 0,
                \"notify_item7\": 0,
                \"notify_item8\": 0,
                \"notify_item9\": 0,
                \"notify_item10\": 0,
                \"notify_item11\": 0,
                \"notify_item12\": 0,
                \"notify_switch\": 2
            }
        """
        let jsonData = jsonStr.data(using: .utf8)
        let obj = try! JSONDecoder().decode(IDOSetNoticeStatusModel.self, from: jsonData!)
        return obj
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        callDelay = try container.decode(Int.self, forKey: .callDelay)

        if let value = try container.decodeIfPresent(Int.self, forKey: .notifySwitch) {
            notifySwitch = IDONoticeNotifySwitchState(rawValue: value)!
        } else {
            notifySwitch = .invalid
        }
        if let value = try container.decodeIfPresent(Int.self, forKey: .callSwitch) {
            callSwitch = IDONoticeCallSwitchState(rawValue: value)!
        } else {
            callSwitch = .invalid
        }
        if let value = try container.decodeIfPresent(Int.self, forKey: .msgAllSwitch) {
            msgAllSwitch = IDONoticeMsgAllSwitchState(rawValue: value)!
        } else {
            msgAllSwitch = .invalid
        }

        // notifyItem1
        var value = try container.decodeIfPresent(Int.self, forKey: .notifyItem1)
        var bits = value == nil ? 0.toBits() : value!.toBits()
        isOnSms         = bits[1] != 0
        isOnEmail       = bits[2] != 0
        isOnWeChat      = bits[3] != 0
        isOnQq          = bits[4] != 0
        isOnWeibo       = bits[5] != 0
        isOnFaceBook    = bits[6] != 0
        isOnTwitter     = bits[7] != 0
        
        
        // notifyItem2
        value = try container.decodeIfPresent(Int.self, forKey: .notifyItem2)
        bits = value == nil ? 0.toBits() : value!.toBits()
        isOnWhatsapp   = bits[0] != 0
        isOnMessenger  = bits[1] != 0
        isOnInstagram  = bits[2] != 0
        isOnLinkedIn   = bits[3] != 0
        isOnCalendar   = bits[4] != 0
        isOnSkype      = bits[5] != 0
        isOnAlarm      = bits[6] != 0
        isOnOther      = bits[7] != 0
        
        // notifyItem3
        value = try container.decodeIfPresent(Int.self, forKey: .notifyItem3)
        bits = value == nil ? 0.toBits() : value!.toBits()
        isOnVkontakte   = bits[0] != 0
        isOnLine        = bits[1] != 0
        isOnViber       = bits[2] != 0
        isOnKakaoTalk   = bits[3] != 0
        isOnGmail       = bits[4] != 0
        isOnOutlook     = bits[5] != 0
        isOnSnapchat    = bits[6] != 0
        isOnTelegram    = bits[7] != 0
        
        // notifyItem4
        value = try container.decodeIfPresent(Int.self, forKey: .notifyItem4)
        bits = value == nil ? 0.toBits() : value!.toBits()
        isOnChatwork        = bits[1] != 0
        isOnSlack           = bits[2] != 0
        isOnYahooMail       = bits[3] != 0
        isOnTumblr          = bits[4] != 0
        isOnYoutube         = bits[5] != 0
        isOnYahooPinterest  = bits[5] != 0
        isOnKeep            = bits[7] != 0
        
        // notifyItem5
        value = try container.decodeIfPresent(Int.self, forKey: .notifyItem5)
        bits = value == nil ? 0.toBits() : value!.toBits()
        isOnTikTok      = bits[0] != 0
        isOnRedbus      = bits[1] != 0
        isOnDailyhunt   = bits[2] != 0
        isOnHotstar     = bits[3] != 0
        isOnInshorts    = bits[4] != 0
        isOnPaytm       = bits[5] != 0
        isOnAmazon      = bits[6] != 0
        isOnFlipkart    = bits[7] != 0
        
        // notifyItem6
        value = try container.decodeIfPresent(Int.self, forKey: .notifyItem6)
        bits = value == nil ? 0.toBits() : value!.toBits()
        isOnPrime       = bits[0] != 0
        isOnNetflix     = bits[1] != 0
        isOnGpay        = bits[2] != 0
        isOnPhonpe      = bits[3] != 0
        isOnSwiggy      = bits[4] != 0
        isOnZomato      = bits[5] != 0
        isOnMakeMyTrip  = bits[6] != 0
        isOnJioTv       = bits[7] != 0
        
        // notifyItem7
        value = try container.decodeIfPresent(Int.self, forKey: .notifyItem7)
        bits = value == nil ? 0.toBits() : value!.toBits()
        isOnMicrosoft           = bits[0] != 0
        isOnWhatsAppBusiness    = bits[1] != 0
        isOnNioseFit            = bits[2] != 0
        isOnDidNotCall          = bits[3] != 0
        isOnYtMusic             = bits[4] != 0
        isOnUber                = bits[5] != 0
        isOnOla                 = bits[6] != 0
        isOnMattersRemind       = bits[7] != 0
        
        // notifyItem8
        value = try container.decodeIfPresent(Int.self, forKey: .notifyItem8)
        bits = value == nil ? 0.toBits() : value!.toBits()
        isOnGoogleMeet   = bits[0] != 0
        isOnMormaiiSmartwatch   = bits[4] != 0
        isOnTechnosConnect      = bits[5] != 0
        isOnMagalu              = bits[6] != 0
        isOnAmericanas          = bits[7] != 0
        
        // notifyItem9
        value = try container.decodeIfPresent(Int.self, forKey: .notifyItem9)
        bits = value == nil ? 0.toBits() : value!.toBits()
        isOnEnioei      = bits[0] != 0
        isOnAliexpress   = bits[1] != 0
        isOnShopee      = bits[2] != 0
        isOnTeams       = bits[3] != 0
        isOn99Taxi      = bits[4] != 0
        isOnUberEats    = bits[5] != 0
        isOnLfood       = bits[6] != 0
        isOnRappi       = bits[7] != 0
        
        // notifyItem10
        value = try container.decodeIfPresent(Int.self, forKey: .notifyItem10)
        bits = value == nil ? 0.toBits() : value!.toBits()
        isOnMercadoLivre    = bits[0] != 0
        isOnYahoo           = bits[1] != 0
        
        // notifyItem11
        value = try container.decodeIfPresent(Int.self, forKey: .notifyItem11)
        bits = value == nil ? 0.toBits() : value!.toBits()
        isOnInstantemail    = bits[0] != 0
        isOnNhnemail        = bits[1] != 0
        isOnZohoemail       = bits[2] != 0
        isOnExchangeemail   = bits[3] != 0
        isOn189email        = bits[4] != 0
        isOnGoogleGmail     = bits[5] != 0
        isOnVeryfit         = bits[6] != 0
        isOnGeneral         = bits[7] != 0
        
        // notifyItem12
        value = try container.decodeIfPresent(Int.self, forKey: .notifyItem12)
        bits = value == nil ? 0.toBits() : value!.toBits()
        isOnAlibabaemail        = bits[0] != 0
        isOnGoogleCalendario    = bits[1] != 0
        isOnFastrackReflexWorld = bits[2] != 0
        isOnHamaFitMove         = bits[3] != 0
        isOnTaobao              = bits[4] != 0
        isOnDingTalk            = bits[5] != 0
        isOnAlipay              = bits[6] != 0
        isOnToutiao             = bits[7] != 0
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(callDelay, forKey: .callDelay)
        
        try container.encode(notifySwitch.rawValue, forKey: .notifySwitch)
        try container.encode(callSwitch.rawValue, forKey: .callSwitch)
        try container.encode(msgAllSwitch.rawValue, forKey: .msgAllSwitch)
        
        try container.encode([
            nil,
            isOnSms,
            isOnEmail,
            isOnWeChat,
            isOnQq,
            isOnWeibo,
            isOnFaceBook,
            isOnTwitter
        ].reversed().toInt(), forKey: .notifyItem1)
        
        try container.encode([
            isOnWhatsapp,
            isOnMessenger,
            isOnInstagram,
            isOnLinkedIn,
            isOnCalendar,
            isOnSkype,
            isOnAlarm,
            isOnOther
        ].reversed().toInt(), forKey: .notifyItem2)
        
        try container.encode([
            isOnVkontakte,
            isOnLine,
            isOnViber,
            isOnKakaoTalk,
            isOnGmail,
            isOnOutlook,
            isOnSnapchat,
            isOnTelegram
        ].reversed().toInt(), forKey: .notifyItem3)
        
        try container.encode([
            isOnChatwork,
            isOnSlack,
            isOnYahooMail,
            isOnTumblr,
            isOnYoutube,
            isOnYahooPinterest,
            isOnKeep,
            nil
        ].reversed().toInt(), forKey: .notifyItem4)
        
        try container.encode([
            isOnTikTok,
            isOnRedbus,
            isOnDailyhunt,
            isOnHotstar,
            isOnInshorts,
            isOnPaytm,
            isOnAmazon,
            isOnFlipkart
        ].reversed().toInt(), forKey: .notifyItem5)
        
        try container.encode([
            isOnPrime,
            isOnNetflix,
            isOnGpay,
            isOnPhonpe,
            isOnSwiggy,
            isOnZomato,
            isOnMakeMyTrip,
            isOnJioTv
        ].reversed().toInt(), forKey: .notifyItem6)
        
        try container.encode([
            isOnMicrosoft,
            isOnWhatsAppBusiness,
            isOnNioseFit,
            isOnDidNotCall,
            isOnYtMusic,
            isOnUber,
            isOnOla,
            isOnMattersRemind
        ].reversed().toInt(), forKey: .notifyItem7)
        
        try container.encode([
            isOnGoogleMeet,
            nil, nil, nil,
            isOnMormaiiSmartwatch,
            isOnTechnosConnect,
            isOnMagalu,
            isOnAmericanas
        ].reversed().toInt(), forKey: .notifyItem8)
        
        try container.encode([
            isOnEnioei,
            isOnAliexpress,
            isOnShopee,
            isOnTeams,
            isOn99Taxi,
            isOnUberEats,
            isOnLfood,
            isOnRappi
        ].reversed().toInt(), forKey: .notifyItem9)
        
        try container.encode([
            isOnMercadoLivre,
            isOnYahoo,
            nil,nil, nil,nil,nil,nil
        ].reversed().toInt(), forKey: .notifyItem10)
        
        try container.encode([
            isOnInstantemail,
            isOnNhnemail,
            isOnZohoemail,
            isOnExchangeemail,
            isOn189email,
            isOnGoogleGmail,
            isOnVeryfit,
            isOnGeneral
        ].reversed().toInt(), forKey: .notifyItem11)
        
        try container.encode([
            isOnAlibabaemail,
            isOnGoogleCalendario,
            isOnFastrackReflexWorld,
            isOnHamaFitMove,
            isOnTaobao,
            isOnDingTalk,
            isOnAlipay,
            isOnToutiao
        ].reversed().toInt(), forKey: .notifyItem12)
    }

    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

@objc
public enum IDONoticeNotifySwitchState: Int {
    /// Invalid(Not Support)
    case invalid = -1
    /// BLE switch off(Reserved,invalid function)
    case bleOff = 0
    /// BLE switch on(Initiate pairing for IOS only)
    case bleOn = 1
    /// Setting sub-switch
    case settingSubSwitch = 2
    /// BT only (switch)
    case btOnlySwitch = 3
    /// BLE and BT on (switch)
    case bleAndBtOn
}

@objc
public enum IDONoticeCallSwitchState: Int {
    case invalid = -1
    case off = 0
    case on = 1
}

@objc
public enum IDONoticeMsgAllSwitchState: Int {
    case invalid = -1
    case off = 0
    case on = 1
}
