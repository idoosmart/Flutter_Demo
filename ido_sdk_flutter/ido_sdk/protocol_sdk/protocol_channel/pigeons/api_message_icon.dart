import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class MessageIconDelegate {

  /// 监听消息图标更新状态
  void listenMessageIconState(bool updating);

  /// 监听消息图标目录地址
  void listenIconDirPath(String path);

}

@FlutterApi()
abstract class MessageIcon {

  /// ios 配置
  /// countryCode：国家编码
  /// baseUrlPath：base url 缓存服务器地址
  /// appKey：后台请求分配 appKey
  /// language：语言单位
  /// 语言单位 无效:0,中文:1,英文:2,法语:3,德语:4,意大利语:5,西班牙语:6,日语:7,
  /// 波兰语:8,捷克语:9,罗马尼亚:10,立陶宛语:11,荷兰语:12,斯洛文尼亚:13,
  /// 匈牙利语:14,俄罗斯语:15,乌克兰语:16,斯洛伐克语:17,丹麦语:18,克罗地亚:19,印尼语:20,
  /// 韩语:21,印地语:22,葡萄牙语:23,土耳其:24,泰国语:25,越南语:26,缅甸语:27,
  /// 菲律宾语:28,繁体中文:29,希腊语:30,阿拉伯语:31,瑞典语:32,芬兰语:33,波斯语:34,挪威语:35
  /// 未设语言单位，默认为英文
  void iOSConfig(String? countryCode,String? baseUrlPath,String? appKey,int? language);

  /// 正在更新图标和名字
  @async
  bool updating();

  /// 设置默认app信息集合(ios专用，仅限支持的设备使用)
  void setDefaultAppInfoList(List<AppIconItemModel> models);

  /// 设备支持默认app信息集合
  /// ios 只有默认的包名
  /// android 会包含默认的event_type 如果已经安装的应用则包含图标地址
  @async
  List<AppIconItemModel> getDefaultAppInfo();

  /// android 已安装所有app信息集合 force: 强制更新Android 消息图标和名字
  /// ios 需要执行获取默认的APP包名列表信息，因为event_type是固件分配的 force 强制更新应用名称
  @async
  List<AppIconItemModel> firstGetAllAppInfo(bool force);

  /// 获取缓存的app信息数据
  /// 如果有动态更新app图标则会缓存数据，获取数据显示到开关控制列表
  @async
  AppIconInfoModel getCacheAppInfoModel();

  /// 获取icon图片存放目录地址
  @async
  String getIconDirPath();

  /// 重置APP图标信息（删除本地沙盒缓存的图片）
  /// macAddress 需要清除数据的MAC地址
  /// deleteIcon 是否删除icon 图片文件，默认删除
  @async
  bool resetIconInfoData(String macAddress, bool deleteIcon);

  /// android 当有收到通知时下发消息图标到设备
  @async
  bool androidSendMessageIconToDevice(int eventType);

}


class AppIconItemModel {

  /// 事件类型
  int? evtType;

  /// 应用包名
  String? packName;

  /// 应用名称
  String? appName;

  /// icon 沙盒小图标地址 (设备使用)
  String? iconLocalPath;

  /// 每个包名给一个id 由0开始
  int? itemId;

  /// 消息收到次数
  int? msgCount;

  /// icon 云端地址
  String? iconCloudPath;

  /// 消息图标更新状态
  /// 0：不需要更新 1：需要更新icon ，2：需要更新app名，3：icon和app都需要更新
  int? state;

  /// icon 沙盒大图标地址 (app 列表上展示)
  String? iconLocalPathBig;

  /// 国家编码
  String? countryCode;

  /// 应用版本号
  String? appVersion;

  /// 是否已经下载APP信息
  bool? isDownloadAppInfo;

  /// 是否已经更新应用名称
  bool? isUpdateAppName;

  /// 是否已经更新应用图标
  bool? isUpdateAppIcon;

  /// 是否为默认应用
  bool? isDefault;
}

class AppIconInfoModel {
  ///版本号
  int? version;

  /// icon宽度
  int? iconWidth;

  /// icon高度
  int? iconHeight;

  /// 颜色格式
  int? colorFormat;

  /// 压缩块大小
  int? blockSize;

  /// 总个数
  int? totalNum;

  /// 包名详情集合
  List<AppIconItemModel?>? items;
}
