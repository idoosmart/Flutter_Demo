/// 通知中心各个开关状态的实体数据模型
class IDONoticeStatusModel {
  /// 通知提醒开关
  /// 0：总开关关 (预留 无效功能)
  /// 1：ble总开关开 (发起配对 IOS专用)
  /// 2：设置子开关
  /// 3：只开bt (开关)
  /// 4：ble、bt都开 (开关)
  int notifySwitch;

  /// 来电子提醒开关
  /// 1：开
  /// 0：关
  /// -1：无效
  int callSwitch;

  /// 来电提醒延时，单位为秒
  int callDelay;

  /// 消息应用总开关
  /// 1：开
  /// 0：关
  /// -1：无效
  int msgAllSwitch;

  // ==================== notify_item1 ====================
  /// 短信提醒
  bool sms;
  /// 邮件提醒
  bool email;
  /// 微信提醒
  bool weChat;
  /// QQ 提醒
  bool qq;
  /// 微博提醒
  bool weibo;
  /// Facebook 提醒
  bool facebook;
  /// Twitter 提醒
  bool twitter;

  // ==================== notify_item2 ====================
  /// WhatsApp 提醒
  bool whatsApp;
  /// Messenger 提醒
  bool messenger;
  /// Instagram 提醒
  bool instagram;
  /// LinkedIn 提醒
  bool linkedIn;
  /// 日历事件提醒
  bool calendar;
  /// Skype 提醒
  bool skype;
  /// 闹钟事件提醒
  bool alarm;
  /// 其它应用提醒
  bool other;

  // ==================== notify_item3 ====================
  /// VKontakte 提醒
  bool vkontakte;
  /// Line 提醒
  bool line;
  /// Viber 提醒
  bool viber;
  /// KakaoTalk 提醒
  bool kakaoTalk;
  /// Gmail 提醒
  bool gmail;
  /// Outlook 提醒
  bool outlook;
  /// Snapchat 提醒
  bool snapchat;
  /// Telegram 提醒
  bool telegram;

  // ==================== notify_item4 ====================
  /// Chatwork 提醒
  bool chatwork;
  /// Slack 提醒
  bool slack;
  /// Yahoo Mail 提醒
  bool yahooMail;
  /// Tumblr 提醒
  bool tumblr;
  /// YouTube 提醒
  bool youtube;
  /// Yahoo Pinterest 提醒
  bool yahooPinterest;
  /// Keep 提醒
  bool keep;
  /// Mormaii Smartwatches 提醒
  bool mormaiiSmartwatches;

  // ==================== notify_item5 ====================
  /// TikTok (国际版) 提醒
  bool tikTok;
  /// Redbus 提醒
  bool redbus;
  /// Dailyhunt 提醒
  bool dailyhunt;
  /// Hotstar 提醒
  bool hotstar;
  /// Inshorts 提醒
  bool inshorts;
  /// Paytm 提醒
  bool paytm;
  /// Amazon 提醒
  bool amazon;
  /// Flipkart 提醒
  bool flipkart;

  // ==================== notify_item6 ====================
  /// Prime 提醒
  bool prime;
  /// Netflix 提醒
  bool netflix;
  /// Gpay 提醒
  bool gpay;
  /// Phonpe 提醒
  bool phonpe;
  /// Swiggy 提醒
  bool swiggy;
  /// Zomato 提醒
  bool zomato;
  /// MakeMyTrip 提醒
  bool makeMyTrip;
  /// Jio Tv 提醒
  bool jioTv;

  // ==================== notify_item7 ====================
  /// Microsoft 提醒
  bool microsoft;
  /// WhatsApp Business 提醒
  bool whatsAppBusiness;
  /// NioseFit 提醒
  bool nioseFit;
  /// 未接来电提醒
  bool missedCalls;
  /// YT Music 提醒
  bool ytMusic;
  /// Uber 提醒
  bool uber;
  /// Ola 提醒
  bool ola;
  /// 事项提醒
  bool mattersRemind;

  // ==================== notify_item8 ====================
  /// Google Meet 提醒
  bool googleMeet;
  /// Prime vídeo 提醒
  bool primeVideo;
  /// Mormaii Smartwatch 提醒
  bool mormaiiSmartwatch;
  /// Technos Connect 提醒
  bool technosConnect;
  /// Magalu 提醒
  bool magalu;
  /// Americanas 提醒
  bool americanas;

  // ==================== notify_item9 ====================
  /// Enjoei 提醒
  bool enjoei;
  /// Aliexpress 提醒
  bool aliexpress;
  /// Shopee 提醒
  bool shopee;
  /// Teams 提醒
  bool teams;
  /// 99 Taxi 提醒
  bool taxi99;
  /// Uber Eats 提醒
  bool uberEats;
  /// Lfood 提醒
  bool lfood;
  /// Rappi 提醒
  bool rappi;

  // ==================== notify_item10 ====================
  /// Mercado Livre 提醒
  bool mercadoLivre;
  /// Yahoo 提醒
  bool yahoo;
  /// TickTick 提醒
  bool tickTick;
  /// Todoist 提醒
  bool todoist;
  /// Banco do Brasil 提醒
  bool bancoDoBrasil;
  /// Correios 提醒
  bool correios;
  /// Banco Inter 提醒
  bool bancoInter;
  /// Caixa Economica 提醒
  bool caixaEconomica;

  // ==================== notify_item11 ====================
  /// Neon 提醒
  bool neon;
  /// Santander 提醒
  bool santander;
  /// Next 提醒
  bool next;
  /// Shein 提醒
  bool shein;
  /// Google Task 提醒
  bool googleTask;
  /// Microsoft To Do 提醒
  bool microsoftToDo;
  /// Veryfit 提醒
  bool veryfit;
  /// 通用提醒
  bool general;

  // ==================== notify_item12 ====================
  /// Alibaba Email 提醒
  bool alibabaEmail;
  /// Google Calendario 提醒
  bool googleCalendario;
  /// Fastrack Reflex World 提醒
  bool fastrackReflexWorld;
  /// Hama Fit Move 提醒
  bool hamaFitMove;
  /// 淘宝提醒
  bool taobao;
  /// 钉钉 (DingTalk) 提醒
  bool dingTalk;
  /// 支付宝 (Alipay) 提醒
  bool alipay;
  /// 今日头条 (Toutiao) 提醒
  bool toutiao;

  // ==================== notify_item13 ====================
  /// 天猫 (TMail) 提醒
  bool tmail;
  /// 京东 (JD) 提醒
  bool jd;
  /// 拼多多提醒
  bool pinduoduo;
  /// 百度 (Baidu) 提醒
  bool baidu;
  /// 美团 (Meituan) 提醒
  bool meituan;
  /// 饿了么 (ele.me) 提醒
  bool eleme;
  /// 抖音 (国内版) 提醒
  bool douyin;
  /// 新浪微博 (国内版) 提醒
  bool homeWeibo;

  // ==================== notify_item14 ====================
  /// Titan Smart World 提醒
  bool titanSmartWorld;
  /// Ryze Connect 提醒
  bool ryzeConnect;
  /// LOOPS FIT 提醒
  bool loopsFit;
  /// Facebook Messenger 提醒
  bool facebookMessenger;
  /// Nubank 提醒
  bool nubank;
  /// Bradesco 提醒
  bool bradesco;
  /// Itaú 提醒
  bool itau;

  // ==================== notify_item15 ====================
  /// Google Messages 提醒
  bool googleMessages;
  /// Apple Calendar 提醒
  bool appleCalendar;
  /// Apple Mail 提醒
  bool appleMail;
  /// Google Calendar 提醒
  bool googleCalendar;
  /// Health &U 提醒
  bool healthU;
  /// Zalo 提醒
  bool zalo;
  /// 滴滴出行 (Didi Taxi) 提醒
  bool didiTaxi;
  /// Zoom Workplace 提醒
  bool zoomWorkplace;

  // ==================== notify_item16 ====================
  /// BUZUD 提醒
  bool buzud;

  IDONoticeStatusModel({
    this.notifySwitch = 0,
    this.callSwitch = 0,
    this.callDelay = 0,
    this.msgAllSwitch = 0,
    this.sms = false,
    this.email = false,
    this.weChat = false,
    this.qq = false,
    this.weibo = false,
    this.facebook = false,
    this.twitter = false,
    this.whatsApp = false,
    this.messenger = false,
    this.instagram = false,
    this.linkedIn = false,
    this.calendar = false,
    this.skype = false,
    this.alarm = false,
    this.other = false,
    this.vkontakte = false,
    this.line = false,
    this.viber = false,
    this.kakaoTalk = false,
    this.gmail = false,
    this.outlook = false,
    this.snapchat = false,
    this.telegram = false,
    this.chatwork = false,
    this.slack = false,
    this.yahooMail = false,
    this.tumblr = false,
    this.youtube = false,
    this.yahooPinterest = false,
    this.keep = false,
    this.mormaiiSmartwatches = false,
    this.tikTok = false,
    this.redbus = false,
    this.dailyhunt = false,
    this.hotstar = false,
    this.inshorts = false,
    this.paytm = false,
    this.amazon = false,
    this.flipkart = false,
    this.prime = false,
    this.netflix = false,
    this.gpay = false,
    this.phonpe = false,
    this.swiggy = false,
    this.zomato = false,
    this.makeMyTrip = false,
    this.jioTv = false,
    this.microsoft = false,
    this.whatsAppBusiness = false,
    this.nioseFit = false,
    this.missedCalls = false,
    this.ytMusic = false,
    this.uber = false,
    this.ola = false,
    this.mattersRemind = false,
    this.googleMeet = false,
    this.primeVideo = false,
    this.mormaiiSmartwatch = false,
    this.technosConnect = false,
    this.magalu = false,
    this.americanas = false,
    this.enjoei = false,
    this.aliexpress = false,
    this.shopee = false,
    this.teams = false,
    this.taxi99 = false,
    this.uberEats = false,
    this.lfood = false,
    this.rappi = false,
    this.mercadoLivre = false,
    this.yahoo = false,
    this.tickTick = false,
    this.todoist = false,
    this.bancoDoBrasil = false,
    this.correios = false,
    this.bancoInter = false,
    this.caixaEconomica = false,
    this.neon = false,
    this.santander = false,
    this.next = false,
    this.shein = false,
    this.googleTask = false,
    this.microsoftToDo = false,
    this.veryfit = false,
    this.general = false,
    this.alibabaEmail = false,
    this.googleCalendario = false,
    this.fastrackReflexWorld = false,
    this.hamaFitMove = false,
    this.taobao = false,
    this.dingTalk = false,
    this.alipay = false,
    this.toutiao = false,
    this.tmail = false,
    this.jd = false,
    this.pinduoduo = false,
    this.baidu = false,
    this.meituan = false,
    this.eleme = false,
    this.douyin = false,
    this.homeWeibo = false,
    this.titanSmartWorld = false,
    this.ryzeConnect = false,
    this.loopsFit = false,
    this.facebookMessenger = false,
    this.nubank = false,
    this.bradesco = false,
    this.itau = false,
    this.googleMessages = false,
    this.appleCalendar = false,
    this.appleMail = false,
    this.googleCalendar = false,
    this.healthU = false,
    this.zalo = false,
    this.didiTaxi = false,
    this.zoomWorkplace = false,
    this.buzud = false,
  });

  factory IDONoticeStatusModel.fromJson(Map<String, dynamic> json) {
    final model = IDONoticeStatusModel(
      notifySwitch: json['notify_switch'] as int? ?? 0,
      callSwitch: json['call_switch'] as int? ?? 0,
      callDelay: json['call_delay'] as int? ?? 0,
      msgAllSwitch: json['msg_all_switch'] as int? ?? 0,
    );

    // notify_item1
    final item1 = json['notify_item1'] as int? ?? 0;
    model.sms = (item1 & (1 << 1)) != 0;
    model.email = (item1 & (1 << 2)) != 0;
    model.weChat = (item1 & (1 << 3)) != 0;
    model.qq = (item1 & (1 << 4)) != 0;
    model.weibo = (item1 & (1 << 5)) != 0;
    model.facebook = (item1 & (1 << 6)) != 0;
    model.twitter = (item1 & (1 << 7)) != 0;

    // notify_item2
    final item2 = json['notify_item2'] as int? ?? 0;
    model.whatsApp = (item2 & (1 << 0)) != 0;
    model.messenger = (item2 & (1 << 1)) != 0;
    model.instagram = (item2 & (1 << 2)) != 0;
    model.linkedIn = (item2 & (1 << 3)) != 0;
    model.calendar = (item2 & (1 << 4)) != 0;
    model.skype = (item2 & (1 << 5)) != 0;
    model.alarm = (item2 & (1 << 6)) != 0;
    model.other = (item2 & (1 << 7)) != 0;

    // notify_item3
    final item3 = json['notify_item3'] as int? ?? 0;
    model.vkontakte = (item3 & (1 << 0)) != 0;
    model.line = (item3 & (1 << 1)) != 0;
    model.viber = (item3 & (1 << 2)) != 0;
    model.kakaoTalk = (item3 & (1 << 3)) != 0;
    model.gmail = (item3 & (1 << 4)) != 0;
    model.outlook = (item3 & (1 << 5)) != 0;
    model.snapchat = (item3 & (1 << 6)) != 0;
    model.telegram = (item3 & (1 << 7)) != 0;

    // notify_item4
    final item4 = json['notify_item4'] as int? ?? 0;
    model.chatwork = (item4 & (1 << 0)) != 0;
    model.slack = (item4 & (1 << 1)) != 0;
    model.yahooMail = (item4 & (1 << 2)) != 0;
    model.tumblr = (item4 & (1 << 3)) != 0;
    model.youtube = (item4 & (1 << 4)) != 0;
    model.yahooPinterest = (item4 & (1 << 5)) != 0;
    model.keep = (item4 & (1 << 6)) != 0;
    model.mormaiiSmartwatches = (item4 & (1 << 7)) != 0;

    // notify_item5
    final item5 = json['notify_item5'] as int? ?? 0;
    model.tikTok = (item5 & (1 << 0)) != 0;
    model.redbus = (item5 & (1 << 1)) != 0;
    model.dailyhunt = (item5 & (1 << 2)) != 0;
    model.hotstar = (item5 & (1 << 3)) != 0;
    model.inshorts = (item5 & (1 << 4)) != 0;
    model.paytm = (item5 & (1 << 5)) != 0;
    model.amazon = (item5 & (1 << 6)) != 0;
    model.flipkart = (item5 & (1 << 7)) != 0;

    // notify_item6
    final item6 = json['notify_item6'] as int? ?? 0;
    model.prime = (item6 & (1 << 0)) != 0;
    model.netflix = (item6 & (1 << 1)) != 0;
    model.gpay = (item6 & (1 << 2)) != 0;
    model.phonpe = (item6 & (1 << 3)) != 0;
    model.swiggy = (item6 & (1 << 4)) != 0;
    model.zomato = (item6 & (1 << 5)) != 0;
    model.makeMyTrip = (item6 & (1 << 6)) != 0;
    model.jioTv = (item6 & (1 << 7)) != 0;

    // notify_item7
    final item7 = json['notify_item7'] as int? ?? 0;
    model.microsoft = (item7 & (1 << 0)) != 0;
    model.whatsAppBusiness = (item7 & (1 << 1)) != 0;
    model.nioseFit = (item7 & (1 << 2)) != 0;
    model.missedCalls = (item7 & (1 << 3)) != 0;
    model.ytMusic = (item7 & (1 << 4)) != 0;
    model.uber = (item7 & (1 << 5)) != 0;
    model.ola = (item7 & (1 << 6)) != 0;
    model.mattersRemind = (item7 & (1 << 7)) != 0;

    // notify_item8
    final item8 = json['notify_item8'] as int? ?? 0;
    model.googleMeet = (item8 & (1 << 0)) != 0;
    model.primeVideo = (item8 & (1 << 1)) != 0;
    model.mormaiiSmartwatch = (item8 & (1 << 4)) != 0;
    model.technosConnect = (item8 & (1 << 5)) != 0;
    model.magalu = (item8 & (1 << 6)) != 0;
    model.americanas = (item8 & (1 << 7)) != 0;

    // notify_item9
    final item9 = json['notify_item9'] as int? ?? 0;
    model.enjoei = (item9 & (1 << 0)) != 0;
    model.aliexpress = (item9 & (1 << 1)) != 0;
    model.shopee = (item9 & (1 << 2)) != 0;
    model.teams = (item9 & (1 << 3)) != 0;
    model.taxi99 = (item9 & (1 << 4)) != 0;
    model.uberEats = (item9 & (1 << 5)) != 0;
    model.lfood = (item9 & (1 << 6)) != 0;
    model.rappi = (item9 & (1 << 7)) != 0;

    // notify_item10
    final item10 = json['notify_item10'] as int? ?? 0;
    model.mercadoLivre = (item10 & (1 << 0)) != 0;
    model.yahoo = (item10 & (1 << 1)) != 0;
    model.tickTick = (item10 & (1 << 2)) != 0;
    model.todoist = (item10 & (1 << 3)) != 0;
    model.bancoDoBrasil = (item10 & (1 << 4)) != 0;
    model.correios = (item10 & (1 << 5)) != 0;
    model.bancoInter = (item10 & (1 << 6)) != 0;
    model.caixaEconomica = (item10 & (1 << 7)) != 0;

    // notify_item11
    final item11 = json['notify_item11'] as int? ?? 0;
    model.neon = (item11 & (1 << 0)) != 0;
    model.santander = (item11 & (1 << 1)) != 0;
    model.next = (item11 & (1 << 2)) != 0;
    model.shein = (item11 & (1 << 3)) != 0;
    model.googleTask = (item11 & (1 << 4)) != 0;
    model.microsoftToDo = (item11 & (1 << 5)) != 0;
    model.veryfit = (item11 & (1 << 6)) != 0;
    model.general = (item11 & (1 << 7)) != 0;

    // notify_item12
    final item12 = json['notify_item12'] as int? ?? 0;
    model.alibabaEmail = (item12 & (1 << 0)) != 0;
    model.googleCalendario = (item12 & (1 << 1)) != 0;
    model.fastrackReflexWorld = (item12 & (1 << 2)) != 0;
    model.hamaFitMove = (item12 & (1 << 3)) != 0;
    model.taobao = (item12 & (1 << 4)) != 0;
    model.dingTalk = (item12 & (1 << 5)) != 0;
    model.alipay = (item12 & (1 << 6)) != 0;
    model.toutiao = (item12 & (1 << 7)) != 0;

    // notify_item13
    final item13 = json['notify_item13'] as int? ?? 0;
    model.tmail = (item13 & (1 << 0)) != 0;
    model.jd = (item13 & (1 << 1)) != 0;
    model.pinduoduo = (item13 & (1 << 2)) != 0;
    model.baidu = (item13 & (1 << 3)) != 0;
    model.meituan = (item13 & (1 << 4)) != 0;
    model.eleme = (item13 & (1 << 5)) != 0;
    model.douyin = (item13 & (1 << 6)) != 0;
    model.homeWeibo = (item13 & (1 << 7)) != 0;

    // notify_item14
    final item14 = json['notify_item14'] as int? ?? 0;
    model.titanSmartWorld = (item14 & (1 << 0)) != 0;
    model.ryzeConnect = (item14 & (1 << 1)) != 0;
    model.loopsFit = (item14 & (1 << 2)) != 0;
    model.facebookMessenger = (item14 & (1 << 4)) != 0;
    model.nubank = (item14 & (1 << 5)) != 0;
    model.bradesco = (item14 & (1 << 6)) != 0;
    model.itau = (item14 & (1 << 7)) != 0;

    // notify_item15
    final item15 = json['notify_item15'] as int? ?? 0;
    model.googleMessages = (item15 & (1 << 0)) != 0;
    model.appleCalendar = (item15 & (1 << 1)) != 0;
    model.appleMail = (item15 & (1 << 2)) != 0;
    model.googleCalendar = (item15 & (1 << 3)) != 0;
    model.healthU = (item15 & (1 << 4)) != 0;
    model.zalo = (item15 & (1 << 5)) != 0;
    model.didiTaxi = (item15 & (1 << 6)) != 0;
    model.zoomWorkplace = (item15 & (1 << 7)) != 0;

    // notify_item16
    final item16 = json['notify_item16'] as int? ?? 0;
    model.buzud = (item16 & (1 << 0)) != 0;

    return model;
  }

  Map<String, dynamic> toJson() {
    int item1 = 0;
    if (sms) item1 |= (1 << 1);
    if (email) item1 |= (1 << 2);
    if (weChat) item1 |= (1 << 3);
    if (qq) item1 |= (1 << 4);
    if (weibo) item1 |= (1 << 5);
    if (facebook) item1 |= (1 << 6);
    if (twitter) item1 |= (1 << 7);

    int item2 = 0;
    if (whatsApp) item2 |= (1 << 0);
    if (messenger) item2 |= (1 << 1);
    if (instagram) item2 |= (1 << 2);
    if (linkedIn) item2 |= (1 << 3);
    if (calendar) item2 |= (1 << 4);
    if (skype) item2 |= (1 << 5);
    if (alarm) item2 |= (1 << 6);
    if (other) item2 |= (1 << 7);

    int item3 = 0;
    if (vkontakte) item3 |= (1 << 0);
    if (line) item3 |= (1 << 1);
    if (viber) item3 |= (1 << 2);
    if (kakaoTalk) item3 |= (1 << 3);
    if (gmail) item3 |= (1 << 4);
    if (outlook) item3 |= (1 << 5);
    if (snapchat) item3 |= (1 << 6);
    if (telegram) item3 |= (1 << 7);

    int item4 = 0;
    if (chatwork) item4 |= (1 << 0);
    if (slack) item4 |= (1 << 1);
    if (yahooMail) item4 |= (1 << 2);
    if (tumblr) item4 |= (1 << 3);
    if (youtube) item4 |= (1 << 4);
    if (yahooPinterest) item4 |= (1 << 5);
    if (keep) item4 |= (1 << 6);
    if (mormaiiSmartwatches) item4 |= (1 << 7);

    int item5 = 0;
    if (tikTok) item5 |= (1 << 0);
    if (redbus) item5 |= (1 << 1);
    if (dailyhunt) item5 |= (1 << 2);
    if (hotstar) item5 |= (1 << 3);
    if (inshorts) item5 |= (1 << 4);
    if (paytm) item5 |= (1 << 5);
    if (amazon) item5 |= (1 << 6);
    if (flipkart) item5 |= (1 << 7);

    int item6 = 0;
    if (prime) item6 |= (1 << 0);
    if (netflix) item6 |= (1 << 1);
    if (gpay) item6 |= (1 << 2);
    if (phonpe) item6 |= (1 << 3);
    if (swiggy) item6 |= (1 << 4);
    if (zomato) item6 |= (1 << 5);
    if (makeMyTrip) item6 |= (1 << 6);
    if (jioTv) item6 |= (1 << 7);

    int item7 = 0;
    if (microsoft) item7 |= (1 << 0);
    if (whatsAppBusiness) item7 |= (1 << 1);
    if (nioseFit) item7 |= (1 << 2);
    if (missedCalls) item7 |= (1 << 3);
    if (ytMusic) item7 |= (1 << 4);
    if (uber) item7 |= (1 << 5);
    if (ola) item7 |= (1 << 6);
    if (mattersRemind) item7 |= (1 << 7);

    int item8 = 0;
    if (googleMeet) item8 |= (1 << 0);
    if (primeVideo) item8 |= (1 << 1);
    if (mormaiiSmartwatch) item8 |= (1 << 4);
    if (technosConnect) item8 |= (1 << 5);
    if (magalu) item8 |= (1 << 6);
    if (americanas) item8 |= (1 << 7);

    int item9 = 0;
    if (enjoei) item9 |= (1 << 0);
    if (aliexpress) item9 |= (1 << 1);
    if (shopee) item9 |= (1 << 2);
    if (teams) item9 |= (1 << 3);
    if (taxi99) item9 |= (1 << 4);
    if (uberEats) item9 |= (1 << 5);
    if (lfood) item9 |= (1 << 6);
    if (rappi) item9 |= (1 << 7);

    int item10 = 0;
    if (mercadoLivre) item10 |= (1 << 0);
    if (yahoo) item10 |= (1 << 1);
    if (tickTick) item10 |= (1 << 2);
    if (todoist) item10 |= (1 << 3);
    if (bancoDoBrasil) item10 |= (1 << 4);
    if (correios) item10 |= (1 << 5);
    if (bancoInter) item10 |= (1 << 6);
    if (caixaEconomica) item10 |= (1 << 7);

    int item11 = 0;
    if (neon) item11 |= (1 << 0);
    if (santander) item11 |= (1 << 1);
    if (next) item11 |= (1 << 2);
    if (shein) item11 |= (1 << 3);
    if (googleTask) item11 |= (1 << 4);
    if (microsoftToDo) item11 |= (1 << 5);
    if (veryfit) item11 |= (1 << 6);
    if (general) item11 |= (1 << 7);

    int item12 = 0;
    if (alibabaEmail) item12 |= (1 << 0);
    if (googleCalendario) item12 |= (1 << 1);
    if (fastrackReflexWorld) item12 |= (1 << 2);
    if (hamaFitMove) item12 |= (1 << 3);
    if (taobao) item12 |= (1 << 4);
    if (dingTalk) item12 |= (1 << 5);
    if (alipay) item12 |= (1 << 6);
    if (toutiao) item12 |= (1 << 7);

    int item13 = 0;
    if (tmail) item13 |= (1 << 0);
    if (jd) item13 |= (1 << 1);
    if (pinduoduo) item13 |= (1 << 2);
    if (baidu) item13 |= (1 << 3);
    if (meituan) item13 |= (1 << 4);
    if (eleme) item13 |= (1 << 5);
    if (douyin) item13 |= (1 << 6);
    if (homeWeibo) item13 |= (1 << 7);

    int item14 = 0;
    if (titanSmartWorld) item14 |= (1 << 0);
    if (ryzeConnect) item14 |= (1 << 1);
    if (loopsFit) item14 |= (1 << 2);
    if (facebookMessenger) item14 |= (1 << 4);
    if (nubank) item14 |= (1 << 5);
    if (bradesco) item14 |= (1 << 6);
    if (itau) item14 |= (1 << 7);

    int item15 = 0;
    if (googleMessages) item15 |= (1 << 0);
    if (appleCalendar) item15 |= (1 << 1);
    if (appleMail) item15 |= (1 << 2);
    if (googleCalendar) item15 |= (1 << 3);
    if (healthU) item15 |= (1 << 4);
    if (zalo) item15 |= (1 << 5);
    if (didiTaxi) item15 |= (1 << 6);
    if (zoomWorkplace) item15 |= (1 << 7);

    int item16 = 0;
    if (buzud) item16 |= (1 << 0);

    return {
      'notify_switch': notifySwitch,
      'call_switch': callSwitch,
      'call_delay': callDelay,
      'msg_all_switch': msgAllSwitch,
      'notify_item1': item1,
      'notify_item2': item2,
      'notify_item3': item3,
      'notify_item4': item4,
      'notify_item5': item5,
      'notify_item6': item6,
      'notify_item7': item7,
      'notify_item8': item8,
      'notify_item9': item9,
      'notify_item10': item10,
      'notify_item11': item11,
      'notify_item12': item12,
      'notify_item13': item13,
      'notify_item14': item14,
      'notify_item15': item15,
      'notify_item16': item16,
    };
  }

  @override
  String toString() {
    return 'IDONoticeStatusModel{notifySwitch: $notifySwitch, callSwitch: $callSwitch, callDelay: $callDelay, msgAllSwitch: $msgAllSwitch, sms: $sms, weChat: $weChat}';
  }
}
