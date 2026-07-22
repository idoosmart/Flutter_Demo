/// 思澈 dial_config.json 模型，对齐 Android [IDOCwdDialConfigBean.kt]
class IDOCwdDialConfigBean {
  final int project;
  final int version;
  final String name;
  final int id;
  final String? dialPath;
  final String? postfix;
  int? posType;
  final List<IDODialDataBean> dialData;

  IDOCwdDialConfigBean({
    required this.project,
    required this.version,
    required this.name,
    required this.id,
    this.dialPath,
    this.postfix,
    this.posType,
    required this.dialData,
  });

  factory IDOCwdDialConfigBean.fromJson(Map<String, dynamic> json) {
    final rows = (json['dial_data'] as List?)
            ?.map((e) => IDODialDataBean.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList() ??
        [];
    return IDOCwdDialConfigBean(
      project: (json['project'] as num?)?.toInt() ?? 0,
      version: (json['version'] as num?)?.toInt() ?? 1,
      name: json['name'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      dialPath: json['dial_path'] as String?,
      postfix: json['postfix'] as String?,
      posType: (json['pos_type'] as num?)?.toInt(),
      dialData: rows,
    );
  }

  Map<String, dynamic> toJson() => {
        'project': project,
        'version': version,
        'name': name,
        'id': id,
        if (dialPath != null) 'dial_path': dialPath,
        if (postfix != null) 'postfix': postfix,
        if (posType != null) 'pos_type': posType,
        'dial_data': dialData.map((e) => e.toJson()).toList(),
      };
}

class IDODialDataBean {
  int user;
  int wtype;
  int xdata;
  int dtype;
  int x;
  int y;
  int w;
  int h;
  String? file;
  int fontSize;
  int r;
  int g;
  int b;
  int showType;

  IDODialDataBean({
    this.user = 1,
    this.wtype = 9,
    this.xdata = 0,
    this.dtype = 0,
    this.x = 0,
    this.y = 0,
    this.w = 0,
    this.h = 0,
    this.file = '',
    this.fontSize = 0,
    this.r = 255,
    this.g = 255,
    this.b = 255,
    this.showType = 0,
  });

  factory IDODialDataBean.fromJson(Map<String, dynamic> json) => IDODialDataBean(
        user: (json['user'] as num?)?.toInt() ?? 1,
        wtype: (json['wtype'] as num?)?.toInt() ?? 9,
        xdata: (json['xdata'] as num?)?.toInt() ?? 0,
        dtype: (json['dtype'] as num?)?.toInt() ?? 0,
        x: (json['x'] as num?)?.toInt() ?? 0,
        y: (json['y'] as num?)?.toInt() ?? 0,
        w: (json['w'] as num?)?.toInt() ?? 0,
        h: (json['h'] as num?)?.toInt() ?? 0,
        file: json['file'] as String? ?? '',
        fontSize: (json['font_size'] as num?)?.toInt() ?? 0,
        r: (json['r'] as num?)?.toInt() ?? 255,
        g: (json['g'] as num?)?.toInt() ?? 255,
        b: (json['b'] as num?)?.toInt() ?? 255,
        showType: (json['show_type'] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'user': user,
        'wtype': wtype,
        'xdata': xdata,
        'dtype': dtype,
        'x': x,
        'y': y,
        'w': w,
        'h': h,
        'file': file ?? '',
        'font_size': fontSize,
        'r': r,
        'g': g,
        'b': b,
        'show_type': showType,
      };
}

/// dial_config dtype，对齐固件枚举
class IDODialDataType {
  IDODialDataType._();

  static const int hm = 12;
  static const int week = 7;
  static const int day = 3;
  static const int hour = 4;
  static const int minute = 5;
  static const int dayStep = 18;
  static const int dayDistance = 20;
  static const int hrvalLast = 33;
  static const int dayKcal = 43;
  static const int battery = 44;
  static const int batteryBar = 45;
  static const int batteryWithBar = 46;
}
