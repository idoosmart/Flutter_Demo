/// 图片格式
enum ImageFormatType{
  alphaMask(realValue: _Dx.alpha_mask),
  swapColor(realValue: _Dx.swap_color),

  /// 无效
  none(realValue: _Dx.none),
  rgb111(realValue: _Dx.rgb111),
  bgr111(realValue: _Dx.bgr111),
  argb111(realValue: _Dx.argb111),
  abgr111(realValue: _Dx.abgr111),

  rgb222(realValue: _Dx.rgb222),
  bgr222(realValue: _Dx.bgr222),
  argb222(realValue: _Dx.argb222),
  abgr222(realValue: _Dx.abgr222),

  rgb565(realValue: _Dx.rgb565),
  bgr565(realValue: _Dx.bgr565),
  argb565(realValue: _Dx.argb565),
  abgr565(realValue: _Dx.abgr565),

  rgb888(realValue: _Dx.rgb888),
  bgr888(realValue: _Dx.bgr888),
  argb888(realValue: _Dx.argb888),
  abgr888(realValue: _Dx.abgr888),

  /// 单色 1bit
  mono1(realValue: _Dx.mono1),
  /// 单色 2bit
  mono2(realValue: _Dx.mono2),
  /// 单色 4bit
  mono4(realValue: _Dx.mono4),
  /// 单色 8bit
  mono8(realValue: _Dx.mono8),

  /// 自动模式,如果是8bit图片,采用4bit取模,或者采用rgb,或者rgba取模
  auto(realValue: _Dx.auto);

  const ImageFormatType({
    required this.realValue
  });

  final int realValue;
}

abstract class _Dx {

  static const int alpha_mask	=	(1 << 7);
  static const int swap_color	=	(1 << 6);

  static const int none	=	0;	//无效
  static const int rgb111	= 1;
  static const int bgr111	=	(rgb111 | swap_color);
  static const int argb111	=	(rgb111 | alpha_mask);
  static const int abgr111	=	(bgr111 | alpha_mask);

  static const int rgb222	=	2;
  static const int bgr222	=	(rgb222 | swap_color);
  static const int argb222 =		(rgb222 | alpha_mask);
  static const int abgr222	=	(bgr222 | alpha_mask);

  static const int rgb565	=	5;
  static const int bgr565	=	(rgb565 | swap_color);
  static const int argb565 =		(rgb565 | alpha_mask);
  static const int abgr565=	(bgr565 | alpha_mask);

  static const int rgb888	=	8;
  static const int bgr888	=	(rgb888 | swap_color);
  static const int argb888 =		(rgb888 | alpha_mask);
  static const int abgr888=	(bgr888 | alpha_mask);

  static const int mono1 =		100; //单色 1bit
  static const int mono2 = 		101; //单色 2bit
  static const int mono4 =		102; //单色 4bit
  static const int mono8 =		103; //单色 8bit
  static const int auto =		0xff; //自动模式,如果是8bit图片,采用4bit取模,或者采用rgb,或者rgba取模
}