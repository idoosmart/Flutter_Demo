
// 个人信息
import 'dart:ffi';
import '../../../generated/l10n.dart';


class ModelUntil{

 static int obainWeekIndex(bool flag ,List<String> weekList)
  {
    final List<String> weekStrList = [S.current.monday,
      S.current.tuesday,
      S.current.wednesday,
      S.current.thursday,
      S.current.friday,
      S.current.saturday,
      S.current.sunday];

    String repStr = '';
    if (flag && weekList.isNotEmpty) {
      for(int i = 0; i < weekList.length ;i++)
      {
        repStr = repStr + (weekStrList.indexOf(weekList[i]) + 1).toString();
      }
      return int.parse(repStr);
    }
    else {
      return 0;
    }
  }

}




class InformationSetModel
{
  String userId = '-1';
  String birthday = '1998-01-01';
  /// yes 为男  no 为女
  bool sexFlag = true;
  int height = 175;
  int weight = 65;

  InformationSetModel(this.userId,this.birthday,this.sexFlag,this.height,this.weight);


  Map<String,dynamic>  toMap()
  {
    Map<String,dynamic> rMap = {};
    List<String> list = birthday.split('-');
    rMap['year'] = int.parse(list[0]);
    rMap['monuth'] = int.parse(list[1]);
    rMap['day'] = int.parse(list[2]);
    rMap['height'] = height;
    rMap['weight'] = weight;
    int gender = sexFlag ? 0:1;
    rMap['gender'] = gender;
    rMap['hour'] = 18;

    return rMap;
  }


}

// 抬腕识别
class HandUpIdentifySetModel
{
  // 抬腕手势开关
  bool hFidFlag = false;
  // 显示时长
  int  showtime = 3;
  // 是否有时间区间
  bool tqFlag = false;
  int startTimeHour = 23;
  int startTimeMinute = 0;
  int endTimeHour = 23;
  int endTimeMinute = 59;

  HandUpIdentifySetModel(this.hFidFlag,this.showtime,this.tqFlag,this.startTimeHour,this.startTimeMinute,this.endTimeHour,this.endTimeMinute);


  Map<String,dynamic>  toMap()
  {
    Map<String,dynamic> rMap = {};
    hFidFlag ? rMap['on_off'] = 170 : rMap['on_off'] = 85;
    rMap['show_second'] = 10;
    tqFlag ? rMap['has_time_range'] = 1 :  rMap['has_time_range'] = 0;
    rMap['start_hour'] = startTimeHour;
    rMap['start_minute'] = startTimeMinute;
    rMap['end_hour'] = endTimeHour;
    rMap['end_minute'] = endTimeMinute;

    return rMap;
  }


}


// v2智能提醒
class SmartNotifitySetModel
{
  // 子开关
  bool childFlag = false;
  // 延时时间
  int  delayTime = 0;
  // 来电提醒
  bool callFlag = false;
  // 短信
  bool shortMessageFlag = false;
  // 邮件
  bool emailFlag = false;
  // 微信
  bool wechatFlag = false;
  // QQ
  bool qqFlag = false;
  // 新浪微博
  bool sinaWeiboFlag = false;
  // facebook
  bool facebookFlag = false;
  // twitter
  bool twitterFlag = false;
  // whatsapp
  bool whatsappFlag = false;
  // messenger
  bool messengerFlag = false;
  // instagram
  bool instagramFlag = false;
  // linked in
  bool linkedFlag = false;
  // 日历事件
  bool calendarEventFlag = false;
  // skype
  bool skypeFlag = false;
  // 闹钟事件
  bool alarmEventFlag = false;
  // pokeman
  bool pokemanFlag = false;
  // vkontakte
  bool vkontakteFlag = false;
  // line
  bool lineFlag = false;
  // viber
  bool viberFlag = false;
  // kakaotalk
  bool kakaotalkFlag = false;
  // gmail
  bool gmailFlag = false;
  // outlook
  bool outlookFlag = false;
  // snapchat
  bool snapchatFlag = false;
  // telegram
  bool telegramFlag = false;
  // chatwork
  bool chatworkFlag = false;
  // slack
  bool slackFlag = false;
  // yahoo mail
  bool yahooMailFlag = false;
  // tumblr
  bool tumblrFlag = false;
  // youtube
  bool youtubeFlag = false;
  // yahoo pinterest
  bool yahooPinterestFlag = false;
  // keep
  bool keepFlag = false;
  // tiktok
  bool tiktokFlag = false;
  // redbus
  bool redbusFlag = false;
  // dailyhunt
  bool dailyhuntFlag = false;
  // hotstar
  bool hotstarFlag = false;
  // inshorts
  bool inshortsFlag = false;
  // paytm
  bool paytmFlag = false;
  // amazon
  bool amazonFlag = false;
  // flipkart
  bool flipkartFlag = false;
  // prime
  bool primeFlag = false;
  // netflix
  bool netflixFlag = false;
  // gpay
  bool gpayFlag = false;
  // phonpe
  bool phonpeFlag = false;
  // swiggy
  bool swiggyFlag = false;
  // zomato
  bool zomatoFlag = false;
  // make my trip
  bool mytripFlag = false;
  // jio tv
  bool jiotvFlag = false;
  // microsoft
  bool microsoftFlag = false;
  // whats app business
  bool whatsBusinessFlag = false;
  // noise fit
  bool noiseFitFlag = false;
  // did not call
  bool didNotCallFlag = false;
  // matters remind
  bool mattersRemindFlag = false;
  // uber
  bool uberFlag = false;
  // ola
  bool olaFlag = false;
  // yt music
  bool ytMusicFlag = false;
  // google meet
  bool googleMeetFlag = false;
  // mormaii smart watch
  bool mormaiiSmartWatchFlag = false;
  // technos connect
  bool technosConnectFlag = false;
  // enioei
  bool enioeiFlag = false;
  // aliexpress
  bool aliexpressFlag = false;
  // shopee
  bool shopeeFlag = false;
  // teams
  bool teamsFlag = false;
  // 99 taxi
  bool taxi99Flag = false;
  // uber eats
  bool uberEatsFlag = false;
  // lfood
  bool lfoodFlag = false;
  // rappi
  bool rappiFlag = false;
  // mercado liver
  bool mercadoLiverFlag = false;
  // magalu
  bool magaluFlag = false;
  // americanas
  bool americanasFlag = false;
  // yahoo
  bool yahooFlag = false;



  // SmartNotifitySetModel(this)


}

// 久坐提醒的模型
class  LongSitRemindSetModel
{
  bool longSitFlag = false;
  int remindTime = 15;
  int startHour= 8;
  int startMinute = 30;
  int endHour = 18;
  int endMinute = 30;
  List<String> weekList = [];

  // LongSitRemindSetModel(this.longSitFlag, this.remindTime, this.startHour,
  //     this.startMinute, this.endHour, this.endMinute, this.weekList);

  Map<String,dynamic>  toMap()
  {


    Map<String,dynamic> rMap = {};
    rMap['start_hour'] = startHour;
    rMap['start_minute'] = startMinute;
    rMap['end_hour'] = endHour;
    rMap['end_minute'] = endMinute;
    rMap['interval'] = remindTime;
    
    rMap['repetitions'] = ModelUntil.obainWeekIndex(longSitFlag, weekList);
    
    return rMap;
  }

}


// v2心率模式的模型
class  HeartRateModeSetModel
{
  int hrMode = 1;
  int mode = 170;
  bool hrInteTimeFlag = false;
  int startHour= 8;
  int startMinute = 30;
  int endHour = 18;
  int endMinute = 30;


  Map<String,dynamic>  toMap()
  {
    Map<String,dynamic> rMap = {};
    rMap['mode'] = mode;
    rMap['start_hour'] = startHour;
    rMap['start_minute'] = startMinute;
    rMap['end_hour'] = endHour;
    rMap['end_minute'] = endMinute;
    rMap['has_time_range'] = hrInteTimeFlag?1:0;
    rMap['measurement_interval'] = 15;

    return rMap;
  }


}

// 设置心率区间
class  HeartIntervalSetModel
{
  /// 燃烧脂肪
  int burnFat = 117;
  /// 有氧锻炼
  int aerobic = 137;
  /// 极限运动
  int limitValue = 176;
  /// 最大心率
  int userMaxHr = 195;
  /// 热身运动
  int warmUp = 98;
  /// 无氧运动
  int anaerobic = 156;
  /// 最小心率
  int  minHr = 39;
  ///   提醒开始时 | remind start hour
  int startHour = 8;
  ///   提醒开始分 | remind start minute
  int startMinute = 30;
  ///   提醒结束时 | remind stop hour
  int stopHour = 18;
  ///   提醒结束分 | remind stop minute
  int stopMinute = 30;
  ///   最大心率提醒开关
  bool maxHrRemind = true;
  ///   最小心率提醒开关
  bool minHrRemind = true;


  Map<String,dynamic>  toMap()
  {
    Map<String,dynamic> rMap = {};
    rMap['burn_fat_threshold'] = burnFat;
    rMap['aerobic_threshold'] = aerobic;
    rMap['limit_threshold'] = limitValue;
    rMap['user_max_hr'] = userMaxHr;
    rMap['range1'] = warmUp;
    rMap['range1'] = warmUp;
    rMap['range1'] = warmUp;
    rMap['range4'] = anaerobic;
    rMap['range1'] = warmUp;
    rMap['min_hr'] = minHr;
    maxHrRemind?rMap['max_hr_remind'] = 1:rMap['max_hr_remind'] = 0;
    minHrRemind?rMap['min_hr_remind'] = 1:rMap['min_hr_remind'] = 0;
    rMap['remind_start_hour'] = startHour;
    rMap['remind_start_minute'] = startMinute;
    rMap['remind_stop_hour'] = stopHour;
    rMap['remind_stop_minute'] = stopMinute;

    return rMap;
  }

}


// 勿扰模式的模型
class  NoDisturbModeSetModel
{
  bool noDisturbModeFlag = false;
  bool timeRegionFlag = false;
  int startHour= 8;
  int startMinute = 30;
  int endHour = 18;
  int endMinute = 30;
  List<String> weekList = [];


  Map<String,dynamic>  toMap()
  {
    Map<String,dynamic> rMap = {};
    rMap['noontime_rest_start_hour'] = startHour;
    rMap['noontime_rest_start_minute'] = startMinute;
    rMap['noontime_rest_end_hour'] = endHour;
    rMap['noontime_rest_end_minute'] = endMinute;
    timeRegionFlag?rMap['have_time_range'] = 2 : rMap['have_time_range'] = 1;
    noDisturbModeFlag?rMap['all_day_on_off'] = 170 : rMap['all_day_on_off'] = 85;
    
    rMap['week_repeat'] = ModelUntil.obainWeekIndex(noDisturbModeFlag, weekList);


    return rMap;
  }


}


// 设置设备单位
class  DeviceUnitSetModel
{
  int distanceUnit = 1;
  int weightUnit = 1;
  int temperatureUnit = 1;
  int currentLanguage = 1;
  int walkStepLength = 1;
  int runningStepLength = 1;
  int gpsStrideCalibration = 1;
  int timeFormat = 1;
  int weekStart = 1;
  int calorieUnit = 1;
  int swimPoolUnit = 1;
  int cyclingUnit = 1;
  int runUnit = 1;



  Map<String,dynamic>  toMap()
  {
    Map<String,dynamic> rMap = {};
    rMap['dist_unit'] = distanceUnit;
    rMap['weight_unit'] = weightUnit;
    rMap['temp'] = temperatureUnit;
    rMap['stride'] = walkStepLength;
    rMap['stride_run'] = runningStepLength;
    rMap['stride_gps_cal'] = gpsStrideCalibration;
    rMap['is_12hour_format'] = timeFormat;
    rMap['weekStart'] = weekStart;
    rMap['calorieUnit'] = calorieUnit;
    rMap['swimPoolUnit'] = swimPoolUnit;
    rMap['cycling_unit'] = cyclingUnit;
    rMap['walking_running_unit'] = runUnit;

    return rMap;
  }

}


// 设置血压校准
class  BloodPressureCalibrationSetModel
{
  // 收缩压
  int diastolic = 70;
  // 舒张压
  int shrinkage = 110;

  Map<String,dynamic>  toMap()
  {
    Map<String,dynamic> rMap = {};
    rMap['diastolic'] = diastolic;
    rMap['systolic'] = shrinkage;
    rMap['flag'] = 1;

    return rMap;
  }


}


// 设置屏幕亮度
class  ScreenBrightnessSetModel
{
  // 屏幕亮度等级
  int screenBrightnessLevel = 50;
  // 设置用户调节开关
  bool userAdjustFlag = false;
  // 设置亮度模式
  int screenBrightnessMode = 1;

  int startHour = 8;
  int startMinute = 30;
  int stopHour = 18;
  int stopMinute = 30;

  int nightBrightnessLevel = 1;
  int showInterval = 5;

  Map<String,dynamic>  toMap()
  {
    Map<String,dynamic> rMap = {};
    rMap['level'] = screenBrightnessLevel;
    rMap['opera'] = userAdjustFlag?1:0;
    rMap['mode'] = screenBrightnessMode;
    rMap['auto_adjust_night'] = 3;
    rMap['start_hour'] = startHour;
    rMap['start_minute'] = startMinute;
    rMap['end_hour'] = stopHour;
    rMap['end_minute'] = stopMinute;
    rMap['night_level'] = nightBrightnessLevel;
    rMap['show_interval'] = showInterval;


    return rMap;
  }



}


// 设置GPS信息
class  GpsInfoSetModel
{
  // 启动模式
  int startMode = 1;
  // 操作模式
  int operateMode = 1;
  // 定位周期
  int locationCycle = 1000;
  // 定位模式
  int locationMode = 1;

  Map<String,dynamic>  toMap()
  {
    DateTime today = DateTime.now();


    Map<String,dynamic> rMap = {};
    rMap['utc_year'] = today.year;
    rMap['utc_month'] = today.month;
    rMap['utc_day'] = today.day;
    rMap['utc_hour'] = today.hour;
    rMap['utc_minute'] = today.minute;
    rMap['utc_second'] = today.second;
    rMap['start_mode'] = startMode;
    rMap['gsop_operation_mode'] = operateMode;
    rMap['gsop_cycle_ms'] = locationCycle;
    rMap['gns_value'] = locationMode;


    return rMap;
  }


}

// 设置启动参数
class  HotStartInfoSetModel
{
  // 晶振偏移
  int crystalOscillationOffset = 200;
  // 经度
  int longitude = 1;
  // 纬度
  int latitude = 1;
  // 身高
  int height = 170;

  Map<String,dynamic>  toMap()
  {

    Map<String,dynamic> rMap = {};
    rMap['longitude'] = longitude;
    rMap['latitude'] = latitude;
    rMap['altitude'] = crystalOscillationOffset;
    rMap['tcxo_offset'] = height;

    return rMap;
  }

}


// 设置睡眠时间
class  SleepTimeSetModel
{
  // 设置睡眠时间开关
  bool sleepTimeFlag = false;

  int startHour = 22;
  int startMinute = 30;

  int stopHour = 7;
  int stopMinute = 00;

  Map<String,dynamic>  toMap()
  {
    Map<String,dynamic> rMap = {};
    sleepTimeFlag ? rMap['on_off'] = 170 : rMap['on_off'] = 85;
    rMap['start_hour'] = startHour;
    rMap['start_minute'] = startMinute;
    rMap['end_hour'] = stopHour;
    rMap['end_minute'] = stopMinute;

    return rMap;
  }

}


// 设置经期参数
class MenstruationParameterSetModel
{
  // 经期开关
  bool menstrualSwitch = false;
  // 经期长度
  int menstrualLength = 5;
  // 经期周期
  int menstrualCycle = 5;
  // 最近经期
  String recentlyMenstrual = '2023-01-01';
  // 排卵日的间隔
  int intervalDays = 14;
  // 经期前一天
  int dayBeforeMenstrual = 5;
  // 经期后一天
  int dayAfterMenstrual = 5;

  Map<String,dynamic>  toMap()
  {
    Map<String,dynamic> rMap = {};
    menstrualSwitch ? rMap['on_off'] = 170 : rMap['on_off'] = 85;
    rMap['menstrual_length'] = menstrualLength;
    rMap['menstrual_cycle'] = menstrualCycle;

    List<String> dateList = recentlyMenstrual.split('-');
    rMap['last_menstrual_year'] = int.parse(dateList[0]);
    rMap['last_menstrual_month'] = int.parse(dateList[1]);
    rMap['last_menstrual_day'] = int.parse(dateList[2]);

    rMap['ovulation_interval_day'] = intervalDays;
    rMap['ovulation_before_day'] = dayBeforeMenstrual;
    rMap['ovulation_after_day'] = dayAfterMenstrual;

    rMap['notify_flag'] = 1;

    return rMap;
  }

}



// 设置经期提醒
class MenstruationReminderSetModel
{
  // 开始日提醒提前天数
  int startDateInt = 2;
  // 排卵日提醒提前天数
  int ovulationDaySareremind = 3;
  // 提醒时间
  int reminderHour = 20;
  int reminderMinute = 0;
  // 易孕期开始提醒天数
  int pregnancydaybefore = 0;
  // 易孕期结束提醒天数
  int pregnancydayend = 0;
  // 经期结束提前提醒天数
  int menstrualdayend = 0;


  Map<String,dynamic>  toMap()
  {
    Map<String,dynamic> rMap = {};

    rMap['start_day'] = startDateInt;
    rMap['ovulation_day'] = ovulationDaySareremind;

    rMap['hour'] = reminderHour;
    rMap['minute'] = reminderMinute;

    rMap['pregnancy_day_before_remind'] = pregnancydaybefore;
    rMap['pregnancy_day_end_remind'] = pregnancydayend;
    rMap['menstrual_day_end_remind'] = menstrualdayend;

    return rMap;
  }

}


// 设置喝水提醒
class DrinkWaterReminderSetModel
{
  // 设置喝水提醒
  bool drinkWaterReminderFlag = false;
  // 设置分钟间隔时长
  int minuteInterval = 1;
  // 设置开始时间
  int startHour = 8;
  int startMinute = 0;
  // 设置结束时间
  int stopHour = 20;
  int stopMinute = 0;
  // 经期结束提前提醒天数
  List<String> weekList = [];

  Map<String,dynamic>  toMap()
  {
    Map<String,dynamic> rMap = {};

    rMap['on_off'] = drinkWaterReminderFlag?1:0;

    rMap['start_hour'] = startHour;
    rMap['start_minute'] = startMinute;
    rMap['end_hour'] = stopHour;
    rMap['end_minute'] = stopMinute;
    rMap['repeat'] = ModelUntil.obainWeekIndex(drinkWaterReminderFlag, weekList);
    rMap['interval'] = minuteInterval;
    rMap['notify_flag'] = 1;
    rMap['do_not_disturb_on_off'] = 1;
    rMap['no_disturb_start_hour'] = 9;
    rMap['no_disturb_start_minute'] = 0;
    rMap['no_disturb_end_hour'] = 12;
    rMap['no_disturb_end_minute'] = 0;


    return rMap;
  }


}

// 设置v3心率模式
class HeartRateV3SetModel
{
  // 设置v3心率模式
  int heartRateV3Mode = 1;
  // 心率间隔时间
  bool hrIntervalTimeFlag = false;
  // 设置秒钟间隔时间
  int secondIntervalDuration = 2;
  // 设置开始时间
  int startHour = 8;
  int startMinute = 0;
  // 设置结束时间
  int stopHour = 20;
  int stopMinute = 0;


  Map<String,dynamic>  toMap()
  {
    Map<String,dynamic> rMap = {};

    rMap['update_time'] = 0; // DateTime.now().millisecondsSinceEpoch;
    rMap['mode'] = heartRateV3Mode;
    rMap['has_time_range'] = hrIntervalTimeFlag?1:0;
    rMap['measurement_interval'] = secondIntervalDuration;
    rMap['start_hour'] = startHour;
    rMap['start_minute'] = startMinute;
    rMap['end_hour'] = stopHour;
    rMap['end_minute'] = stopMinute;

    rMap['notify_flag'] = 0;
    rMap['high_heart_mode'] = 170;
    rMap['low_heart_mode'] = 170;
    rMap['high_heart_value'] = 0;
    rMap['low_heart_value'] = 0;

    return rMap;
  }


}

// 设置血氧开关
class Spo2SwitchSetModel
{
  // 设置血氧开关
  bool spo2SwitchFlag = false;
  // 设置开始时间
  int startHour = 8;
  int startMinute = 0;
  // 设置结束时间
  int stopHour = 20;
  int stopMinute = 0;
  // 血氧过低开关
  bool lowbloodoxygenswitchFlag = false;
  // 血氧过低阈值
  int  lowbloodoxygenthreshold = 1;


  Map<String,dynamic>  toMap()
  {
    Map<String,dynamic> rMap = {};

    rMap['on_off'] = spo2SwitchFlag?170:85;

    rMap['start_hour'] = startHour;
    rMap['start_minute'] = startMinute;
    rMap['end_hour'] = stopHour;
    rMap['end_minute'] = stopMinute;

    rMap['low_spo2_on_off'] = lowbloodoxygenswitchFlag?170:85;
    rMap['low_spo2_value'] = lowbloodoxygenthreshold;
    rMap['notify_flag'] = 1;


    return rMap;
  }


}



// 设置走动提醒
class WalkReminderSetModel
{
  // 设置走动提醒
  bool walkReminderFlag = false;
  // 设置提醒步数目标
  int walkReminderTarget = 100;
  // 设置目标时间
  int targetTime = 0;
  // 设置开始时间
  int startHour = 8;
  int startMinute = 0;
  // 设置结束时间
  int stopHour = 20;
  int stopMinute = 0;

  List<String> weekList = [];


  Map<String,dynamic>  toMap()
  {
    Map<String,dynamic> rMap = {};

    rMap['on_off'] = walkReminderFlag?170:85;

    rMap['goal_step'] = walkReminderTarget;
    rMap['goal_time'] = targetTime;


    rMap['repeat'] = ModelUntil.obainWeekIndex(walkReminderFlag, weekList);

    rMap['start_hour'] = startHour;
    rMap['start_minute'] = startMinute;
    rMap['end_hour'] = stopHour;
    rMap['end_minute'] = stopMinute;


    rMap['notify_flag'] = 1;


    return rMap;
  }

}



// 设置压力开关
class PressureSwitchSetModel
{
  // 设置压力开关
  bool pressureSwitchFlag = false;
  // 设置分钟间隔时长
  int intervalLength = 30;
  // 压力过高阈值
  int hightPressureReminder = 100;
  // 设置开始时间
  int startHour = 8;
  int startMinute = 0;
  // 设置结束时间
  int stopHour = 20;
  int stopMinute = 0;
  // 压力提醒开关
  bool pressureReminderFlag = false;

  List<String> weekList = [];

  Map<String,dynamic>  toMap()
  {
    Map<String,dynamic> rMap = {};

    rMap['on_off'] = pressureSwitchFlag?170:85;

    rMap['interval'] = intervalLength;
    rMap['high_threshold'] = hightPressureReminder;

    rMap['repeat'] = ModelUntil.obainWeekIndex(pressureSwitchFlag, weekList);

    rMap['start_hour'] = startHour;
    rMap['start_minute'] = startMinute;
    rMap['end_hour'] = stopHour;
    rMap['end_minute'] = stopMinute;
    rMap['remind_on_off'] = pressureReminderFlag?170:85;

    rMap['stress_threshold'] = 80;
    rMap['notify_flag'] = 1;

    return rMap;
  }



}


// 设置洗手提醒
class WashHandReminderSetModel
{
  // 设置洗手提醒开关
  bool washHandReminderFlag = false;
  // 设置分钟间隔时长
  int intervalLength = 30;
  // 设置开始时间
  int startHour = 8;
  int startMinute = 0;
  // 设置结束时间
  int stopHour = 20;
  int stopMinute = 0;


  List<String> weekList = [];


  Map<String,dynamic>  toMap()
  {
    Map<String,dynamic> rMap = {};

    rMap['on_off'] = washHandReminderFlag?1:0;
    rMap['interval'] = intervalLength;

    rMap['repeat'] = ModelUntil.obainWeekIndex(washHandReminderFlag, weekList);

    rMap['start_hour'] = startHour;
    rMap['start_minute'] = startMinute;
    rMap['end_hour'] = stopHour;
    rMap['end_minute'] = stopMinute;


    return rMap;
  }



}



// 设置智能心率
class SmartHeartRateSetModel
{
  // 智能心率模式
  bool smartheartratemodelFlag = false;
  // 通知类型
  int notifyType = 1;
  // 心率过高提醒开关
  bool highheartratereminderFlag = false;
  // 心率过高提醒阈值
  int heartratetoohighthreshold = 0;
  // 心率过低提醒开关
  bool lowheartratereminderFlag = false;
  // 心率过低提醒阈值
  int heartratetoolowthreshold = 0;


  Map<String,dynamic>  toMap()
  {
    Map<String,dynamic> rMap = {};

    rMap['mode'] = smartheartratemodelFlag?1:0;
    rMap['notifyType'] = notifyType;

    rMap['high_heart_mode'] = highheartratereminderFlag?170:85;
    rMap['high_heart_value'] = heartratetoohighthreshold;
    rMap['low_heart_mode'] = lowheartratereminderFlag?170:85;
    rMap['low_heart_value'] = heartratetoolowthreshold;


    rMap['start_hour'] = 9;
    rMap['start_minute'] = 0;
    rMap['end_hour'] = 12;
    rMap['end_minute'] = 0;


    return rMap;
  }


}



// 科学睡眠开关
class SleepSwitchSetModel
{
  // 科学睡眠模式开关
  bool sleepSwitchModeFlag = false;
  // 设置开始时间
  int startHour = 8;
  int startMinute = 0;
  // 设置结束时间
  int stopHour = 20;
  int stopMinute = 0;


  Map<String,dynamic>  toMap()
  {
    Map<String,dynamic> rMap = {};

    rMap['mode'] = sleepSwitchModeFlag?170:85;
    rMap['start_hour'] = startHour;
    rMap['start_minute'] = startMinute;
    rMap['end_hour'] = stopHour;
    rMap['end_minute'] = stopMinute;


    return rMap;
  }

}


// 夜间体温开关
class NocturnalTemperatureSwitchSetModel
{
  // 夜间体温开关
  bool nocturnalTemperatureSwitchFlag = false;
  // 设置开始时间
  int startHour = 8;
  int startMinute = 0;
  // 设置结束时间
  int stopHour = 20;
  int stopMinute = 0;
  // 温度单位
  int temperatureUnit = 1;


  Map<String,dynamic>  toMap()
  {
    Map<String,dynamic> rMap = {};

    rMap['mode'] = nocturnalTemperatureSwitchFlag?170:85;
    rMap['start_hour'] = startHour;
    rMap['start_minute'] = startMinute;
    rMap['end_hour'] = stopHour;
    rMap['end_minute'] = stopMinute;
    rMap['unit'] = temperatureUnit;


    return rMap;
  }

}

// 环境音量的开关
class NoiseSwitchSetModel
{
  // 环境音量开关
  bool noiseSwitchFlag = false;
  // 设置开始时间
  int startHour = 8;
  int startMinute = 0;
  // 设置结束时间
  int stopHour = 20;
  int stopMinute = 0;
  // 阈值开关
  bool thresholdswitchFlag = false;
  // 阈值
  int threshold = 1;


  Map<String,dynamic>  toMap()
  {
    Map<String,dynamic> rMap = {};

    rMap['mode'] = noiseSwitchFlag?170:85;
    rMap['start_hour'] = startHour;
    rMap['start_minute'] = startMinute;
    rMap['end_hour'] = stopHour;
    rMap['end_minute'] = stopMinute;
    rMap['high_noise_on_off'] = thresholdswitchFlag?170:85;
    rMap['high_noise_value'] = threshold;


    return rMap;
  }

}



// 健身指导开关
class  FitnessGuidanceSwitchSetModel
{
  // 健身指导开关
  bool fitnessGuidanceSwitchFlag = false;
  int startHour= 8;
  int startMinute = 30;
  int endHour = 18;
  int endMinute = 30;
  // 通知类型
  int notifyType = 1;

  int targetStep = 10000;

  List<String> weekList = [];


  Map<String,dynamic>  toMap()
  {
    Map<String,dynamic> rMap = {};

    rMap['mode'] = fitnessGuidanceSwitchFlag?170:85;
    rMap['start_hour'] = startHour;
    rMap['start_minute'] = startMinute;
    rMap['end_hour'] = endHour;
    rMap['end_minute'] = endMinute;

    rMap['notify_flag'] = notifyType;
    rMap['repeat'] = ModelUntil.obainWeekIndex(fitnessGuidanceSwitchFlag, weekList);
    rMap['target_steps'] = targetStep;


    return rMap;
  }

}


// 日落日出时间
class  SunRiseSunSetModel
{
  int startHour= 8;
  int startMinute = 30;
  int endHour = 18;
  int endMinute = 30;


  Map<String,dynamic>  toMap()
  {
    Map<String,dynamic> rMap = {};

    rMap['sunrise_hour'] = startHour;
    rMap['sunrise_min'] = startMinute;
    rMap['sunset_hour'] = endHour;
    rMap['sunset_min'] = endMinute;

    return rMap;
  }

}


// 设置V3天气数据
class  WeatherDataV3SetModel
{
  // 天气类型
  int weathertype = 0;
  // 当前的温度
  int currentweather = 0;
  // 最大温度
  int maxweather = 0;
  // 最小温度
  int minweather = 0;
  // 空气质量
  int airquality = 0;
  // 降水概率
  int Precipitationprobability = 0;
  // 湿度
  int humidity = 0;
  // 紫外线强度
  int uvintensity = 0;
  // 风速
  int windspeed = 0;
  // 星期
  int week = 0;
  // 月
  int month = 2;
  // 日
  int day = 2;
  // 日出 日落
  int sunrisetimeHour= 8;
  int sunrisetimeMinute = 30;
  int sunsettimeHour = 18;
  int sunsettimeMinute = 30;

  String  cithName = '北京';


  Map<String,dynamic>  toMap()
  {
    Map<String,dynamic> rMap = {
    "version":0,
    "month":12,
    "day":26,
    "hour":16,
    "min":31,
    "sec":30,
    "week":1,
    "weather_type":1,
    "today_tmp":21,
    "today_max_temp":23,
    "today_min_temp":12,
    "city_name":"shenzhen",
    "air_quality":53,
  "precipitation_probability":1,
  "humidity":0,
  "today_uv_intensity":0,
  "wind_speed":0,
  "sunrise_hour":6,
  "sunrise_min":20,
  "sunset_hour":18,
  "sunset_min":17,
  "sunrise_item_num":0,
  "air_grade_item":[],
  "hours_weather_items":[
  {
  "weather_type":1,
  "temperature":0,
  "probability":0
  },
  {
  "weather_type":1,
  "temperature":0,
  "probability":0
  }
    ],
    "future_items":null,
    "sunrise_item":null
  };



    return rMap;
  }

}


// 运动子项数据排列
class  SportParamSortSetModel
{
  int sportType = 1;
  int showIndex = 1;


}

// 相关的日程内容
class SchedulerReminderModel
{
  int schdulerId = 0;
  // 标题
  String title = '';
  // 备注
  String remark = '';
  // 日期
  String dateString = '2000-01-01';
  // 时间 时分秒
  int hour = 0;
  int minute = 0;
  int second = 0;
  // 状态码
  int stateCode = 0;
  // 提醒类型
  int remindType = 0;
  // 超过天数提醒类型
  int exceedRemindType = 0;
  // week
  List<String> weekList = [];

}


// 设置日程提醒
class  SchedulerReminderSetModel
{
  int operate = 1;
  int version = 1;
  List<SchedulerReminderModel> schedulerList = [];

  Map<String,dynamic>  toMap()
  {
    Map<String,dynamic> rMap = {};

    rMap['version'] = version;
    rMap['operate'] = operate;
    if (operate == 1) {
      rMap['num'] = schedulerList.length;
    }

    List<Map<String,dynamic>> items = [];
    for(int i = 0;i<schedulerList.length;i++){
      SchedulerReminderModel srModel = schedulerList[i];
      Map<String,dynamic> newMap = {};
      newMap['id'] = srModel.schdulerId;
      List<String> dateList = srModel.dateString.split('-');
      newMap['year'] = int.parse(dateList[0]);
      newMap['mon'] = int.parse(dateList[1]);
      newMap['day'] = int.parse(dateList[2]);
      newMap['hour'] = srModel.hour;
      newMap['min'] = srModel.minute;
      newMap['sec'] = srModel.second;
      newMap['repeat_type'] = ModelUntil.obainWeekIndex(true, srModel.weekList);
      newMap['remind_on_off'] = 1;
      newMap['state'] = srModel.remindType;
      newMap['title'] = srModel.title;
      newMap['note'] = srModel.remark;
      items.add(newMap);
    }
    rMap['items'] = items;


    return rMap;
  }


}

// 蓝牙联系人
class  BlueToothContactModel
{
  String nameStr = '';
  String phoneNumber = '';
}


// 设置蓝牙联系人
class  BlueToothContactSetModel
{
  int version = 1;
  // 蓝牙联系人列表
  List<BlueToothContactModel> contactList = [];


  Map<String,dynamic>  toMap()
  {
    Map<String,dynamic> rMap = {};

    rMap['version'] = version;
    rMap['operate'] = 1;
    rMap['items_num'] = contactList.length;


    List<Map<String,dynamic>> items = [];
    for(int i = 0;i<contactList.length;i++){
      BlueToothContactModel srModel = contactList[i];
      Map<String,dynamic> newMap = {};

      newMap['phone'] = srModel.phoneNumber;
      newMap['name'] = srModel.nameStr;

      items.add(newMap);
    }
    rMap['items'] = items;


    return rMap;
  }

}



// APP通知
class  AppNotifyStatusModel
{
  // 事件类型
  int eventType = 0;
  // 通知状态
  int notifyStatus = 0;
}


// 设置APP通知状态
class  AppNotifyStatusSetModel
{
  int version = 1;
  // 蓝牙联系人列表
  List<AppNotifyStatusModel> notifyList = [];

  Map<String,dynamic>  toMap()
  {
    Map<String,dynamic> rMap = {};

    rMap['version'] = version;
    rMap['operate'] = 1;
    rMap['items_num'] = notifyList.length;


    List<Map<String,dynamic>> items = [];
    for(int i = 0;i<notifyList.length;i++){
      AppNotifyStatusModel srModel = notifyList[i];
      Map<String,dynamic> newMap = {};

      // newMap['phone'] = srModel.phoneNumber;
      // newMap['name'] = srModel.nameStr;

      items.add(newMap);
    }
    rMap['items'] = items;


    return rMap;
  }

}


// 服药提醒内容
class MedicationReminderModel
{
  // 吃药提醒开关
  bool takeMedicineReminderSwitch = false;
  // 设置分钟间隔时长
  int setMinuteIntervallength = 1;
  // 开始时间
  int startHour = 8;
  int startMinute = 30;
  // 结束时间
  int stopHour = 18;
  int stopMinute = 30;
  // 勿扰开关
  bool nodisturbSwitch = false;
  int nodisturbStartHour = 0;
  int nodisturbStartMinute = 0;
  int nodisturbStopHour = 0;
  int nodisturbStopMinute = 0;

  // week
  List<String> weekList = [];

}


// 设置服药记录
class  MedicationReminderSetModel
{

  List<MedicationReminderModel> medicationReminderList = [];
}


// 设置运动识别
class  SportRecognitionSetModel
{
  int auto_identify_sport_walk = 0;
  int auto_identify_sport_run = 0;
  int auto_identify_sport_bicycle = 0;
  int auto_pause_on_off = 0;
  int auto_end_remind_on_off_on_off = 0;
  int auto_identify_sport_elliptical = 0;
  int auto_identify_sport_rowing = 0;
  int auto_identify_sport_swim = 0;

  Map<String,dynamic>  toMap()
  {
    Map<String,dynamic> rMap = {};

    rMap['auto_identify_sport_walk'] = auto_identify_sport_walk;
    rMap['auto_identify_sport_run'] = auto_identify_sport_run;
    rMap['auto_identify_sport_bicycle'] = auto_identify_sport_bicycle;
    rMap['auto_pause_on_off'] = auto_pause_on_off;
    rMap['auto_end_remind_on_off_on_off'] = auto_end_remind_on_off_on_off;
    rMap['auto_identify_sport_elliptical'] = auto_identify_sport_elliptical;
    rMap['auto_identify_sport_rowing'] = auto_identify_sport_rowing;
    rMap['auto_identify_sport_swim'] = auto_identify_sport_swim;



    return rMap;
  }

}