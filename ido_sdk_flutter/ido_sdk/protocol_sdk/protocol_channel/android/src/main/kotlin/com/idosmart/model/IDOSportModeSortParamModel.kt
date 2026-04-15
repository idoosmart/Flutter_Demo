//
//  IDOSportModeSortParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.*
import java.io.Serializable
import java.lang.reflect.Type
import com.google.gson.annotations.SerializedName
import com.google.gson.annotations.JsonAdapter

///


open class IDOSportParamModel(items: List<IDOSportModeSortParamModel>
) : IDOBaseModel {
    // 运动类型详情个数，最大30个
    @SerializedName("num")
    private var num = items.size

    // 运动类型排序详情
    @SerializedName("item")
    var items: List<IDOSportModeSortParamModel> = items
    override fun toJsonString(): String {
        val gosn = GsonBuilder().setFieldNamingStrategy(CustomFieldNamingStrategy())
            .registerTypeAdapter(IDOSportType::class.java, SportTypeEnumToIntConverter())
            .create()
        return gosn.toJson(this).toString()
    }

    override fun toString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}


// MARK: - IDOSportModeSortParamModel

open class IDOSportModeSortParamModel(index: Int, type: IDOSportType) : IDOBaseModel {

    /// Sorting index (starting from 1, 0 is invalid)
    @SerializedName("index")
    var index: Int = index

    @SerializedName("type")
    var type: IDOSportType = type

    override fun toJsonString(): String {
        val gosn = GsonBuilder().setFieldNamingStrategy(CustomFieldNamingStrategy())
            .registerTypeAdapter(IDOSportType::class.java, SportTypeEnumToIntConverter())
            .create()
        return gosn.toJson(this).toString()
    }

    override fun toString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}


// MARK: - IDOSportSortParamModel
open class IDOSportSortParamModel(
    operate: Int,
    sportType: IDOSportType,
    nowUserLocation: Int,
    items: List<Int>
) : IDOBaseModel {
    @SerializedName("version")
    private var version: Int = 0

    /// Operation <br />0: Invalid 1: Query 2: Set
    @SerializedName("operate")
    var operate: Int = operate

    /// Type of sport
    @SerializedName("sport_type")
    var sportType: IDOSportType = sportType

    /// Current position of displayed added sports
    @SerializedName("now_user_location")
    var nowUserLocation: Int = nowUserLocation

    @SerializedName("all_num")
    private var allNum: Int = items.size

    @SerializedName("items")
    var items: List<Int> = items

    override fun toJsonString(): String {
        val gosn =
            GsonBuilder().setFieldNamingStrategy(FieldNamingPolicy.LOWER_CASE_WITH_UNDERSCORES)
                .registerTypeAdapter(IDOSportType::class.java, SportTypeEnumToIntConverter())
                .create()
        return gosn.toJson(this).toString()
    }

}

// MARK: - IDOSport100SortParamModel
open class IDOSport100SortParamModel(operate: Int, nowUserLocation: Int, items: List<Int>) :
    IDOBaseModel {
    @SerializedName("version")
    private var version: Int = 0

    /// Operation <br />0: Invalid 1: Query 2: Set
    @SerializedName("operate")
    var operate: Int = operate

    /// Current position of displayed added sports
    @SerializedName("now_user_location")
    var nowUserLocation: Int = nowUserLocation

    @SerializedName("all_num")
    private var allNum: Int = items.size

    @SerializedName("items_set")
    var items: List<Int> = items
    override fun toJsonString(): String {
        val gosn = GsonBuilder().setFieldNamingStrategy(CustomFieldNamingStrategy()).create()
        return gosn.toJson(this).toString()
    }


}

// MARK: - IDOSport100SortModel
open class IDOSport100SortModel(
    errCode: Int,
    operate: Int,
    minShowNum: Int,
    maxShowNum: Int,
    nowUserLocation: Int,
    items: List<IDOSport100SortItem>?
) : IDOBaseModel {
    @SerializedName("version")
    private var version: Int = 0

    /// 0: Success, Non-zero: Failure
    @SerializedName("err_code")
    var errCode: Int = errCode

    /// Operation <br />0: Invalid 1: Query 2: Set
    @SerializedName("operate")
    var operate: Int = operate

    /// Minimum number of items to be displayed, at least 1
    @SerializedName("min_show_num")
    var minShowNum: Int = minShowNum

    /// Maximum number of items to be displayed, maximum 20
    @SerializedName("max_show_num")
    var maxShowNum: Int = maxShowNum

    /// Current position of displayed added sports, app displays based on this position, with the devices added before corresponding to those positions, and those added later to the positions after this position. Only valid for queries
    @SerializedName("now_user_location")
    var nowUserLocation: Int = nowUserLocation

    @SerializedName("all_num")
    private var allNum: Int? = items?.size ?: 0

    @SerializedName("items")
    var items: List<IDOSport100SortItem>? = items

    override fun toJsonString(): String {
        val gosn =
            GsonBuilder().setFieldNamingStrategy(FieldNamingPolicy.LOWER_CASE_WITH_UNDERSCORES)
                .registerTypeAdapter(IDOSportType::class.java, SportTypeEnumToIntConverter())
                .create()
        return gosn.toJson(this).toString()
    }
}

// MARK: - IDOSport100SortItem
open class IDOSport100SortItem(type: IDOSportType, flag: Int) : Serializable {
    /// Type of sport
    @SerializedName("type")
    @JsonAdapter(SportTypeEnumToIntConverter::class)
    var type: IDOSportType = type

    /// 0: None downloaded for all<br />Bit0: Small icon downloaded<br />Bit1: Big icon downloaded<br />Bit2: Medium icon downloaded<br />Bit3: Smallest icon downloaded
    @SerializedName("flag")
    var flag: Int = flag

}

// MARK: - IDOSportSortModel
open class IDOSportSortModel(
    operate: Int,
    errCode: Int,
    sportType: IDOSportType,
    nowUserLocation: Int,
    items: List<Int>
) : IDOBaseModel {
    @SerializedName("version")
    private var version: Int = 0

    /// 0: Success, Non-zero: Failure
    @SerializedName("err_code")
    var errCode: Int = errCode

    /// Operation <br />0: Invalid 1: Query 2: Set
    @SerializedName("operate")
    var operate: Int = operate

    /// Type of sport
    @SerializedName("sport_type")
    var sportType: IDOSportType = sportType

    /// Current position of displayed added sports, app displays based on this position, with the devices added before corresponding to those positions, and those added later to the positions after this position. Only valid for queries
    @SerializedName("now_user_location")
    var nowUserLocation: Int = nowUserLocation

    @SerializedName("all_num")
    private var allNum: Int = items.size

    @SerializedName("item")
    var items: List<Int> = items

    override fun toJsonString(): String {
        val gosn = GsonBuilder().setFieldNamingStrategy(CustomFieldNamingStrategy())
            .registerTypeAdapter(IDOSportType::class.java, SportTypeEnumToIntConverter())
            .create()
        return gosn.toJson(this).toString()
    }

}

internal class SportTypeEnumToIntConverter : JsonSerializer<IDOSportType>,
    JsonDeserializer<IDOSportType> {

    override fun serialize(
        src: IDOSportType,
        typeOfSrc: Type,
        context: JsonSerializationContext
    ): JsonElement {
        return JsonPrimitive(src.raw)
    }

    override fun deserialize(
        json: JsonElement,
        typeOfT: Type,
        context: JsonDeserializationContext
    ): IDOSportType {
        val value = json.asInt
        // Safe decoding: return SPORTTYPEUNKONW if value is not found
        return IDOSportType.values().find { it.raw == value } ?: IDOSportType.SPORTTYPEUNKONW
    }
}

// MARK: - IDOSportType
enum class IDOSportType(val raw: Int) : Serializable {
    /** 未知类型 */
    SPORTTYPEUNKONW(-1),

    /** 无运动类型 */
    SPORTTYPENULL(0),

    /** 走路 */
    SPORTTYPEWALK(1),

    /** 跑步 */
    SPORTTYPERUN(2),

    /** 骑行 */
    SPORTTYPECYCLING(3),

    /** 徒步 */
    SPORTTYPEONFOOT(4),

    /** 游泳 */
    SPORTTYPESWIM(5),

    /** 爬山 */
    SPORTTYPECLIMB(6),

    /** 羽毛球 */
    SPORTTYPEBADMINTON(7),

    /** 其他 */
    SPORTTYPEOTHER(8),

    /** 健身 */
    SPORTTYPEFITNESS(9),

    /** 动感单车 */
    SPORTTYPEDYNAMIC(10),

    /** 椭圆球 */
    SPORTTYPEELLIPSOID(11),

    /** 跑步机 */
    SPORTTYPETREADMILL(12),

    /** 仰卧起坐 */
    SPORTTYPESITUP(13),

    /** 俯卧撑 */
    SPORTTYPEPUSHUP(14),

    /** 哑铃 */
    SPORTTYPEDUMBBELLS(15),

    /** 举重 */
    SPORTTYPELIFTING(16),

    /** 健身操 */
    SPORTTYPEAEROBICS(17),

    /** 瑜伽 */
    SPORTTYPEYOGA(18),

    /** 跳绳 */
    SPORTTYPEROPE(19),

    /** 乒乓球 */
    SPORTTYPEPINGPONG(20),

    /** 篮球 */
    SPORTTYPEBASKETBALL(21),

    /** 足球 */
    SPORTTYPESOCCER(22),

    /** 排球 */
    SPORTTYPEVOLLEYBALL(23),

    /** 网球 */
    SPORTTYPETENNISBALL(24),

    /** 高尔夫球 */
    SPORTTYPEGOLF(25),

    /** 棒球 */
    SPORTTYPEBASEBALL(26),

    /** 滑冰/滑雪 */
    SPORTTYPESKI(27),

    /** 轮滑 */
    SPORTTYPEROLLER(28),

    /** 跳舞 */
    SPORTTYPEDANCING(29),

    /** 笼式网球 */
    SPORTTYPECAGETENNIS(30),

    /** 滚轮训练机/室内划船 */
    SPORTTYPEROLLERMACHINE(31),

    /** 普拉提 */
    SPORTTYPEPILATES(32),

    /** 交叉训练 */
    SPORTTYPECROSSTRAIN(33),

    /** 有氧运动 */
    SPORTTYPECARDIO(34),

    /** 尊巴舞 */
    SPORTTYPEZUMBA(35),

    /** 广场舞 */
    SPORTTYPESQUAREDANCE(36),

    /** 平板支撑 */
    SPORTTYPEPLANK(37),

    /** 健身房 */
    SPORTTYPEGYM(38),

    /** 有氧健身操 */
    SPORTTYPEOXAEROBICS(39),

    /** 腰腹训练 */
    SPORTTYPEABDOMINALANDCORETRAINING(40),

    /** 下肢训练 */
    SPORTTYPELOWERBODYTRAINING(41),

    /** 跳水 */
    SPORTTYPEDIVING(43),

    /** 踏步训练 */
    SPORTTYPESTEPPINGTRAINING(44),

    /** 上肢训练 */
    SPORTTYPEUPPERBODYTRAINING(45),

    /** 混合有氧 */
    SPORTTYPEMIXEDCARDIO(46),

    /** 背部训练 */
    SPORTTYPEBACKTRAINING(47),

    /** 户外跑步 */
    SPORTTYPEOUTDOORRUN(48),

    /** 室内跑步 */
    SPORTTYPEINDOORRUN(49),

    /** 户外骑行 */
    SPORTTYPEOUTDOORCYCLE(50),

    /** 室内骑行 */
    SPORTTYPEINDOORCYCLE(51),

    /** 户外走路 */
    SPORTTYPEOUTDOORWALK(52),

    /** 室内走路 */
    SPORTTYPEINDOORWALK(53),

    /** 泳池游泳 */
    SPORTTYPEPOOLSWIM(54),

    /** 开放水域游泳 */
    SPORTTYPEWATERSWIM(55),

    /** 椭圆机 */
    SPORTTYPEELLIPTICAL(56),

    /** 划船机 */
    SPORTTYPEROWER(57),

    /** 高强度间歇训练法 */
    SPORTTYPEHIT(58),

    /** 踏步测试 */
    SPORTTYPESTEPPINGTEST(59),

    /** 游戏模式 */
    SPORTTYPEGAMEMODE(60),

    /** 板球运动 */
    SPORTTYPECRICKET(75),

    /** 自由训练 */
    SPORTTYPEFREETRAINING(100),

    /** 功能性力量训练 */
    SPORTTYPEFUNCTIONALSTRENGTHTRAINING(101),

    /** 核心训练 */
    SPORTTYPECORETRAINING(102),

    /** 踏步机 */
    SPORTTYPESTEPPER(103),

    /** 整理放松 */
    SPORTTYPEORGANIZEANDRELAX(104),

    /** 传统力量训练 */
    SPORTTYPETRADITIONALSTRENGTHTRAINING(110),

    /** 引体向上 */
    SPORTTYPEPULLUP(112),

    /** 开合跳 */
    SPORTTYPEOPENINGANDCLOSINGJUMP(114),

    /** 深蹲 */
    SPORTTYPESQUAT(115),

    /** 高抬腿 */
    SPORTTYPEHIGHLEGLIFT(116),

    /** 拳击 */
    SPORTTYPEBOXING(117),

    /** 杠铃 */
    SPORTTYPEBARBELL(118),

    /** 武术 */
    SPORTTYPEMARTIAL(119),

    /** 太极 */
    SPORTTYPETAIJI(120),

    /** 跆拳道 */
    SPORTTYPETAEKWONDO(121),

    /** 空手道 */
    SPORTTYPEKARATE(122),

    /** 自由搏击 */
    SPORTTYPEFREEFIGHT(123),

    /** 击剑 */
    SPORTTYPEFENCING(124),

    /** 射箭 */
    SPORTTYPEARCHERY(125),

    /** 体操 */
    SPORTTYPEARTISTICGYMNASTICS(126),

    /** 单杠 */
    SPORTTYPEHORIZONTALBAR(127),

    /** 双杠 */
    SPORTTYPEPARALLELBARS(128),

    /** 漫步机 */
    SPORTTYPEWALKINGMACHINE(129),

    /** 登山机 */
    SPORTTYPEMOUNTAINEERINGMACHINE(130),

    /** 保龄球 */
    SPORTTYPEBOWLING(131),

    /** 台球 */
    SPORTTYPEBILLIARDS(132),

    /** 曲棍球 */
    SPORTTYPEHOCKEY(133),

    /** 橄榄球 */
    SPORTTYPERUGBY(134),

    /** 壁球 */
    SPORTTYPESQUASH(135),

    /** 垒球 */
    SPORTTYPESOFTBALL(136),

    /** 手球 */
    SPORTTYPEHANDBALL(137),

    /** 毽球 */
    SPORTTYPESHUTTLECOCK(138),

    /** 沙滩足球 */
    SPORTTYPEBEACHSOCCER(139),

    /** 藤球 */
    SPORTTYPESEPAKTAKRAW(140),

    /** 躲避球 */
    SPORTTYPEDODGEBALL(141),

    /** 无挡板篮球 */
    SPORTTYPENETBALL(142),

    /** 箭步蹲(Lunge) */
    SPORTTYPELUNGE(149),

    /** 弓箭步 */
    SPORTTYPEARCHERSTEP(150),

    /** 拉伸 */
    SPORTTYPESTRETCHING(151),

    /** 街舞 */
    SPORTTYPEHIPHOP(152),

    /** 芭蕾 */
    SPORTTYPEBALLET(153),

    /** 社交舞 */
    SPORTTYPESOCIALDANCE(154),

    /** 飞盘 */
    SPORTTYPEFRISBEE(155),

    /** 飞镖 */
    SPORTTYPEDARTS(156),

    /** 骑马 */
    SPORTTYPERIDING(157),

    /** 爬楼 */
    SPORTTYPECLIMBBUILDING(158),

    /** 放风筝 */
    SPORTTYPEFLYKITE(159),

    /** 钓鱼 */
    SPORTTYPEGOFISHING(160),

    /** 雪橇 */
    SPORTTYPESLED(161),

    /** 雪车 */
    SPORTTYPESNOWMOBILE(162),

    /** 单板滑雪 */
    SPORTTYPESNOWBOARDING(163),

    /** 雪上运动 */
    SPORTTYPESNOWSPORTS(164),

    /** 高山滑雪 */
    SPORTTYPEALPINESKIING(165),

    /** 越野滑雪 */
    SPORTTYPECROSSCOUNTRYSKIING(166),

    /** 冰壶 */
    SPORTTYPECURLING(167),

    /** 冰球 */
    SPORTTYPEICEHOCKEY(168),

    /** 冬季两项 */
    SPORTTYPEWINTERBIATHLON(169),

    /** 冲浪 */
    SPORTTYPESURFING(170),

    /** 帆船 */
    SPORTTYPESAILBOAT(171),

    /** 帆板 */
    SPORTTYPESAILBOARD(172),

    /** 皮艇 */
    SPORTTYPEKAYAK(173),

    /** 摩托艇 */
    SPORTTYPEMOTORBOAT(174),

    /** 划艇 */
    SPORTTYPEROWBOAT(175),

    /** 赛艇 */
    SPORTTYPEROWING(176),

    /** 龙舟 */
    SPORTTYPEDRAGONBOAT(177),

    /** 水球 */
    SPORTTYPEWATERPOLO(178),

    /** 漂流 */
    SPORTTYPEDRIFT(179),

    /** 滑板 */
    SPORTTYPESKATE(180),

    /** 攀岩 */
    SPORTTYPEROCKCLIMBING(181),

    /** 蹦极 */
    SPORTTYPEBUNGEEJUMPING(182),

    /** 跑酷 */
    SPORTTYPEPARKOUR(183),

    /** BMX */
    SPORTTYPEBMX(184),

    /** 足排球 */
    SPORTTYPEFOOTVOLLEY(187),

    /** 站立滑水 */
    SPORTTYPESTANDINGSTROKE(188),

    /** 越野跑 */
    SPORTTYPETRAILRUNNING(189),

    /** 卷腹 */
    SPORTTYPECRUNCH(190),

    /** 波比跳 */
    SPORTTYPEBURPEE(191),

    /** 卡巴迪 */
    SPORTTYPEKABADDI(192),

    /** 户外玩耍 */
    SPORTTYPEOUTDOORFUN(193),

    /** 其他运动 */
    SPORTTYPEOTHERACTIVITY(194),

    /** 蹦床 */
    SPORTTYPETRAMPOLINE(195),

    /** 呼啦圈 */
    SPORTTYPEHULAHOOP(196),

    /** 赛车 */
    SPORTTYPERACING(197),

    /** 战绳 */
    SPORTTYPEBATTLEROPE(198),

    /** 跳伞 */
    SPORTTYPEPARACHUTING(199),

    /** 定向越野 */
    SPORTTYPEORIENTEERING(200),

    /** 山地骑行 */
    SPORTTYPEMOUNTAINBIKING(201),

    /** 沙滩网球 */
    BEACHTENNIS(202),

    /** 智能跳绳 */
    SMART_JUMP_ROPE(203),

    /** 匹克球 */
    PICKLEBALL(204),

    /** 轮椅运动 */
    WHEELCHAIR_SPORT(205),

    /** 体能训练 */
    FITNESS_TRAINING(206),

    /** 壶铃训练 */
    KETTLEBELL_TRAINING(207),

    /** 团体操 */
    GROUP_EXERCISE(208),

    /** Cross fit */
    CROSS_FIT(209),

    /** 障碍赛 */
    OBSTACLE_COURSE(210),

    /** 滑板车 */
    SCOOTER(211),

    /** 滑翔车 */
    GLIDER(212),

    /** 滑雪 */
    SKIING(213),

    /** 雪板滑雪 */
    SNOWBOARDING(214),

    /** 搏击操 */
    COMBAT_AEROBICS(215),

    /** 剑道 */
    KENDO(216),

    /** 太极拳 */
    TAI_CHI(217),

    /** 综合格斗 */
    MMA(218),

    /** 角力 */
    WRESTLING(219),

    /** 肚皮舞 */
    BELLY_DANCE(220),

    /** 爵士舞 */
    JAZZ_DANCE(221),

    /** 拉丁舞 */
    LATIN_DANCE(222),

    /** 踢踏舞 */
    TAP_DANCE(223),

    /** 其他舞蹈 */
    OTHER_DANCE(224),

    /** 沙滩排球 */
    BEACH_VOLLEYBALL(225),

    /** 门球 */
    GATE_BALL(226),

    /** 马球 */
    POLO(227),

    /** 袋棍球 */
    LACROSSE(228),

    /** 皮划艇 */
    KAYAKING(229),

    /** 桨板冲浪 */
    SUP_SURFING(230),

    /** 对战游戏 */
    COMBAT_GAME(231),

    /** 拔河 */
    TUG_OF_WAR(232),

    /** 秋千 */
    SWING(233),

    /** 马术运动 */
    EQUESTRIAN(234),

    /** 田径 */
    TRACK_AND_FIELD(235),

    /** 爬楼机 */
    STAIR_CLIMBER(236),

    /** 柔韧训练 */
    FLEXIBILITY_TRAINING(237),

    /** 国际象棋 */
    CHESS(238),

    /** 国际跳棋 */
    CHECKERS(239),

    /** 围棋 */
    GO(240),

    /** 桥牌 */
    BRIDGE(241),

    /** 桌游 */
    BOARD_GAME(242),

    /** 民族舞 */
    ETHNIC_DANCE(243),

    /** 嘻哈舞 */
    HIP_HOP_DANCE(244),

    /** 钢管舞 */
    POLE_DANCE(245),

    /** 霹雳舞 */
    BREAK_DANCE(246),

    /** 现代舞 */
    MODERN_DANCE(247),

    /** 泰拳 */
    MUAY_THAI(248),

    /** 柔道 */
    JUDO(249),

    /** 柔术 */
    JIU_JITSU(250),

    /** 回力球 */
    JAI_ALAI(251),

    /** 雪地摩托 */
    SNOWMOBILING(252),

    /** 滑翔伞 */
    PARAGLIDING(253),

    /** 长曲棍球 */
    LACROSSE_FIELD(254),

    /** 美式橄榄球 */
    AMERICAN_FOOTBALL(255);

    companion object {
        fun ofRaw(raw: Int): IDOSportType? {
            return IDOSportType.values().firstOrNull { it.raw == raw }
        }
    }
}