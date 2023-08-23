import 'dart:typed_data';
import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart' as pkg_ffi;
import 'package:protocol_ffi/src/logger/logger.dart';

import '../ido_protocol_fii.dart';

// 文件操作
extension IDOProtocolAPIExtFileOperation on IDOProtocolAPI {
  /// 图片压缩
  /// ```dart
  /// {
  ///    fileName,输入图片路径(包含文件名及后缀)
  ///    endName,输出图片后缀名(.sport)
  ///    format,图片格式
  ///    pic_num,图片个数
  ///   }
  ///
  ///  格式详情
  /// {
  /// #define FONT_FORMAT_ALPHA_MASK		(1 << 7)
  /// #define FONT_FORMAT_SWAP_COLOR		(1 << 6)
  ///
  /// #define FONT_FORMAT_NONE		0	//无效
  /// #define FONT_FORMAT_RGB111		1
  /// #define FONT_FORMAT_BGR111		(FONT_FORMAT_RGB111 | FONT_FORMAT_SWAP_COLOR)
  /// #define FONT_FORMAT_ARGB111		(FONT_FORMAT_RGB111 | FONT_FORMAT_ALPHA_MASK)
  /// #define FONT_FORMAT_ABGR111		(FONT_FORMAT_BGR111 | FONT_FORMAT_ALPHA_MASK)
  ///
  /// #define FONT_FORMAT_RGB222		2
  /// #define FONT_FORMAT_BGR222		(FONT_FORMAT_RGB222 | FONT_FORMAT_SWAP_COLOR)
  /// #define FONT_FORMAT_ARGB222		(FONT_FORMAT_RGB222 | FONT_FORMAT_ALPHA_MASK)
  /// #define FONT_FORMAT_ABGR222		(FONT_FORMAT_BGR222 | FONT_FORMAT_ALPHA_MASK)
  ///
  /// #define FONT_FORMAT_RGB565		5
  /// #define FONT_FORMAT_BGR565		(FONT_FORMAT_RGB565 | FONT_FORMAT_SWAP_COLOR)
  /// #define FONT_FORMAT_ARGB565		(FONT_FORMAT_RGB565 | FONT_FORMAT_ALPHA_MASK)
  /// #define FONT_FORMAT_ABGR565		(FONT_FORMAT_BGR565 | FONT_FORMAT_ALPHA_MASK)
  ///
  /// #define FONT_FORMAT_RGB888		8
  /// #define FONT_FORAMT_BGR888		(FONT_FORMAT_RGB888 | FONT_FORMAT_SWAP_COLOR)
  /// #define FONT_FORMAT_ARGB888		(FONT_FORMAT_RGB888 | FONT_FORMAT_ALPHA_MASK)
  /// #define FONT_FORAMT_ABGR888		(FONT_FORAMT_BGR888 | FONT_FORMAT_ALPHA_MASK)
  ///
  /// #define FONT_FORMAT_MONO1		100 //单色 1bit
  /// #define FONT_FORMAT_MONO2		101 //单色 2bit
  /// #define FONT_FORMAT_MONO4		102 //单色 4bit
  /// #define FONT_FORMAT_MONO8		103 //单色 8bit
  /// #define FONT_FORMAT_AUTO		0xff//自动模式,如果是8bit图片,采用4bit取模,或者采用rgb,或者rgba取模
  /// }
  /// ```dart
  int makeFileCompression(
      {required String fileName,
      required String endName,
      required int format}) {
    final fileNameUtf8 = fileName.toNativeUtf8();
    final endNameNameUtf8 = endName.toNativeUtf8();
    return bindings.makeFileCompression(
        fileNameUtf8.cast(), endNameNameUtf8.cast(), format);
  }

  /// 制作压缩多张运动图片
  /// ```dart
  /// {
  ///    fileName,输入图片路径(包含文件名及后缀)
  ///    endName,输出图片后缀名(.sport)
  ///    format,图片格式
  ///    pic_num,图片个数
  ///   }
  ///
  ///  格式详情
  /// {
  /// #define FONT_FORMAT_ALPHA_MASK		(1 << 7)
  /// #define FONT_FORMAT_SWAP_COLOR		(1 << 6)
  ///
  /// #define FONT_FORMAT_NONE		0	//无效
  /// #define FONT_FORMAT_RGB111		1
  /// #define FONT_FORMAT_BGR111		(FONT_FORMAT_RGB111 | FONT_FORMAT_SWAP_COLOR)
  /// #define FONT_FORMAT_ARGB111		(FONT_FORMAT_RGB111 | FONT_FORMAT_ALPHA_MASK)
  /// #define FONT_FORMAT_ABGR111		(FONT_FORMAT_BGR111 | FONT_FORMAT_ALPHA_MASK)
  ///
  /// #define FONT_FORMAT_RGB222		2
  /// #define FONT_FORMAT_BGR222		(FONT_FORMAT_RGB222 | FONT_FORMAT_SWAP_COLOR)
  /// #define FONT_FORMAT_ARGB222		(FONT_FORMAT_RGB222 | FONT_FORMAT_ALPHA_MASK)
  /// #define FONT_FORMAT_ABGR222		(FONT_FORMAT_BGR222 | FONT_FORMAT_ALPHA_MASK)
  ///
  /// #define FONT_FORMAT_RGB565		5
  /// #define FONT_FORMAT_BGR565		(FONT_FORMAT_RGB565 | FONT_FORMAT_SWAP_COLOR)
  /// #define FONT_FORMAT_ARGB565		(FONT_FORMAT_RGB565 | FONT_FORMAT_ALPHA_MASK)
  /// #define FONT_FORMAT_ABGR565		(FONT_FORMAT_BGR565 | FONT_FORMAT_ALPHA_MASK)
  ///
  /// #define FONT_FORMAT_RGB888		8
  /// #define FONT_FORAMT_BGR888		(FONT_FORMAT_RGB888 | FONT_FORMAT_SWAP_COLOR)
  /// #define FONT_FORMAT_ARGB888		(FONT_FORMAT_RGB888 | FONT_FORMAT_ALPHA_MASK)
  /// #define FONT_FORAMT_ABGR888		(FONT_FORAMT_BGR888 | FONT_FORMAT_ALPHA_MASK)
  ///
  /// #define FONT_FORMAT_MONO1		100 //单色 1bit
  /// #define FONT_FORMAT_MONO2		101 //单色 2bit
  /// #define FONT_FORMAT_MONO4		102 //单色 4bit
  /// #define FONT_FORMAT_MONO8		103 //单色 8bit
  /// #define FONT_FORMAT_AUTO		0xff//自动模式,如果是8bit图片,采用4bit取模,或者采用rgb,或者rgba取模
  /// }
  /// ```dart
  int makeSportFileCompression(
      {required String fileName,
      required String endName,
      required int format,
      required int picNum}) {
    final fileNameUtf8 = fileName.toNativeUtf8();
    final endNameNameUtf8 = endName.toNativeUtf8();
    return bindings.makeSportFileCompression(
        fileNameUtf8.cast(), endNameNameUtf8.cast(), format, picNum);
  }

  /// 制作表盘压缩文件(iwf.lz) 压缩文件会自动添加文件名.lz后缀
  /// ```dart
  /// {
  ///    filePath,素材路径
  ///    saveFileName,文件名
  ///    format,取模图片的格式
  ///    block_size,压缩块大小{1024,4096}
  ///   }
  ///
  ///  格式详情
  /// {
  /// #define FONT_FORMAT_ALPHA_MASK		(1 << 7)
  /// #define FONT_FORMAT_SWAP_COLOR		(1 << 6)
  ///
  /// #define FONT_FORMAT_NONE		0	//无效
  /// #define FONT_FORMAT_RGB111		1
  /// #define FONT_FORMAT_BGR111		(FONT_FORMAT_RGB111 | FONT_FORMAT_SWAP_COLOR)
  /// #define FONT_FORMAT_ARGB111		(FONT_FORMAT_RGB111 | FONT_FORMAT_ALPHA_MASK)
  /// #define FONT_FORMAT_ABGR111		(FONT_FORMAT_BGR111 | FONT_FORMAT_ALPHA_MASK)
  ///
  /// #define FONT_FORMAT_RGB222		2
  /// #define FONT_FORMAT_BGR222		(FONT_FORMAT_RGB222 | FONT_FORMAT_SWAP_COLOR)
  /// #define FONT_FORMAT_ARGB222		(FONT_FORMAT_RGB222 | FONT_FORMAT_ALPHA_MASK)
  /// #define FONT_FORMAT_ABGR222		(FONT_FORMAT_BGR222 | FONT_FORMAT_ALPHA_MASK)
  ///
  /// #define FONT_FORMAT_RGB565		5
  /// #define FONT_FORMAT_BGR565		(FONT_FORMAT_RGB565 | FONT_FORMAT_SWAP_COLOR)
  /// #define FONT_FORMAT_ARGB565		(FONT_FORMAT_RGB565 | FONT_FORMAT_ALPHA_MASK)
  /// #define FONT_FORMAT_ABGR565		(FONT_FORMAT_BGR565 | FONT_FORMAT_ALPHA_MASK)
  ///
  /// #define FONT_FORMAT_RGB888		8
  /// #define FONT_FORAMT_BGR888		(FONT_FORMAT_RGB888 | FONT_FORMAT_SWAP_COLOR)
  /// #define FONT_FORMAT_ARGB888		(FONT_FORMAT_RGB888 | FONT_FORMAT_ALPHA_MASK)
  /// #define FONT_FORAMT_ABGR888		(FONT_FORAMT_BGR888 | FONT_FORMAT_ALPHA_MASK)
  ///
  /// #define FONT_FORMAT_MONO1		100 //单色 1bit
  /// #define FONT_FORMAT_MONO2		101 //单色 2bit
  /// #define FONT_FORMAT_MONO4		102 //单色 4bit
  /// #define FONT_FORMAT_MONO8		103 //单色 8bit
  /// #define FONT_FORMAT_AUTO		0xff//自动模式,如果是8bit图片,采用4bit取模,或者采用rgb,或者rgba取模
  /// }
  /// ```dart
  int makeWatchDialFileCompression(
      {required String filePath,
      required String saveFileName,
      required int format,
      required int blockSize}) {
    final filePathUtf8 = filePath.toNativeUtf8();
    final saveFileNameUtf8 = saveFileName.toNativeUtf8();
    return bindings.mkWatchDialFileCompression(
        filePathUtf8.cast(), saveFileNameUtf8.cast(), format, blockSize);
  }

  /// 制作(IWF)文件,根据表盘包获取到IWF文件接口
  /// ```dart
  /// filePath 素材路径
  /// saveFileName 文件名(包含文件名后缀)
  /// format 取模图片的格式
  /// ```dart
  int makeWatchDialFile(
      {required String filePath,
      required String saveFileName,
      required int format}) {
    final filePathUtf8 = filePath.toNativeUtf8();
    final saveFileNameUtf8 = saveFileName.toNativeUtf8();
    return bindings.mkWatchDialFile(
        filePathUtf8.cast(), saveFileNameUtf8.cast(), format);
  }

  /// 制作(EPO.DAT)文件
  /// ```dart
  /// filePath 素材路径
  /// saveFileName,输出文件名,一般为EPO.DAT
  /// ```dart
  int makeEpoFile({required String filePath, required String saveFileName}) {
    final inPathUtf8 = filePath.toNativeUtf8();
    final outPathUtf8 = saveFileName.toNativeUtf8();
    return bindings.mkEpoFile(inPathUtf8.cast(), outPathUtf8.cast());
  }

  /// 图片转换格式 png->bmp
  /// ```dart
  /// inPath 用于转换的png路径(包含文件名及后缀)
  /// outPath 转换完的bmp路径(包含文件名及后缀)
  /// format 转换成bmp的文件格式
  /// ```dart
  int png2Bmp(
      {required String inPath, required String outPath, required int format}) {
    final inPathUtf8 = inPath.toNativeUtf8();
    final outPathUtf8 = outPath.toNativeUtf8();
    return bindings.Png2Bmp(inPathUtf8.cast(), outPathUtf8.cast(), format);
  }

  /// 压缩png图片质量
  /// ```dart
  /// inputFilePath   输入文件路径
  /// outputFilePath 输出文件路径
  /// int 成功 SUCCESS
  /// ```
  int compressToPNG(
      {required String inputFilePath, required String outputFilePath}) {
    ffi.Pointer<ffi.Char> inPathUtf8 = inputFilePath.toNativeUtf8().cast();
    ffi.Pointer<ffi.Char> outPathUtf8 = outputFilePath.toNativeUtf8().cast();
    final rs = bindings.compressToPNG(inPathUtf8, outPathUtf8);
    pkg_ffi.calloc.free(inPathUtf8);
    pkg_ffi.calloc.free(outPathUtf8);
    return rs;
  }

  /// 制作壁纸图片文件
  /// ```dart
  /// file_path 素材路径
  /// save_file_path 输出文件名
  /// format 预留
  /// ```dart
  int makePhotoFile(
      {required String filePath, required String saveFilePath, int? format}) {
    final filePathUtf8 = filePath.toNativeUtf8();
    final saveFilePathUtf8 = saveFilePath.toNativeUtf8();
    return bindings.mkPhotoFile(
        filePathUtf8.cast(), saveFilePathUtf8.cast(), format ?? 0);
  }

  /// 将功能表输出到json文件
  /// path 输出文件路径(包含文件名及后缀)
  int funcTableOutputOnJsonFile(String filePath) {
    final filePathUtf8 = filePath.toNativeUtf8();
    return bindings.funcTableOutputOnJsonFile(filePathUtf8.cast());
  }

  ///  制作联系人文件 v2_conta.ml
  /// ```dart jsondata json数据
  /// {
  /// 当前文件保存的年 ：year , month , day , hour , minute , second
  /// 联系人详情个数     ：contact_item_num
  /// 联系人详情            ：items
  /// 联系人详情姓名     ：name
  /// 纤细人详情号码     ：phone
  /// }
  /// return 成功：生成的联系人文件路径(持久化路径目录+v2_conta.ml) 失败：NULL
  /// ```
  String? makeContactFile({required String jsonData}) {
    ffi.Pointer<ffi.Char> jsonDataUtf8 = jsonData.toNativeUtf8().cast();
    // logger?.d('jsonDataUtf8 addr: 0x${jsonDataUtf8.address.toRadixString(16)}');
    final rs = bindings.mkConnactFile(jsonDataUtf8);
    final str = rs.cast<pkg_ffi.Utf8>().toDartString();
    pkg_ffi.calloc.free(jsonDataUtf8);
    if (str == 'fileis_null') {
      return null;
    }
    return str;
  }

  /// 音频文件采样率转换  将采样率转化为44.1khz
  /// ```dart
  /// inPath   音频输入文件路径 目录及文件名、文件名后缀
  /// outPath  音频输出文件路径 目录及文件名、文件名后缀
  /// inSize   音频输入文件大小
  /// return   0 成功
  /// ```
  int audioSamplingRateConversion(
      {required String inPath,
      required String outPath,
      required int fileSize}) {
    ffi.Pointer<ffi.Char> inPathUtf8 = inPath.toNativeUtf8().cast();
    ffi.Pointer<ffi.Char> outPathUtf8 = outPath.toNativeUtf8().cast();
    final rs = bindings.AudioSamplingRateConversion(
        inPathUtf8.cast(), outPathUtf8, fileSize);
    pkg_ffi.calloc.free(inPathUtf8);
    pkg_ffi.calloc.free(outPathUtf8);
    return rs;
  }

  /// 音频文件格式转换 mp3转pcm
  /// ```dart
  /// inPath   音频输入文件路径 目录及文件名、文件名后缀
  /// outPath  音频输出文件路径 目录及文件名、文件名后缀
  /// return   0 成功
  /// ```
  int audioFormatConversionMp32Pcm(
      {required String inPath, required String outPath}) {
    ffi.Pointer<ffi.Char> inPathUtf8 = inPath.toNativeUtf8().cast();
    ffi.Pointer<ffi.Char> outPathUtf8 = outPath.toNativeUtf8().cast();
    final rs = bindings.AudioFormatConversionMp32Pcm(inPathUtf8, outPathUtf8);
    pkg_ffi.calloc.free(inPathUtf8);
    pkg_ffi.calloc.free(outPathUtf8);
    return rs;
  }

  /// 获取mp3音频采样率
  /// ```dart
  /// mp3FilePath 输入带路径MP3文件名
  /// return int 输入的MP3文件的采样率
  /// ```
  int audioGetMp3SamplingRate({required String mp3FilePath}) {
    ffi.Pointer<ffi.Char> mp3FilePathUtf8 = mp3FilePath.toNativeUtf8().cast();
    final rs = bindings.AduioGetMp3SamplingRate(mp3FilePathUtf8);
    pkg_ffi.calloc.free(mp3FilePathUtf8);
    return rs;
  }

  /// pcm音频文件采样率转换
  /// configPath 采样率转换配置文件的路径包括文件名
  /// outPath 采样率转换后的目标文件输出路径(包括文件名 .pcm)
  /// sampleRate 采样率大小 默认44100hz
  /// return 0 成功
  int pcmFileSamplingRateConversion(
      {required String configPath, required String outPath}) {
    ffi.Pointer<ffi.Char> configPathUtf8 = configPath.toNativeUtf8().cast();
    ffi.Pointer<ffi.Char> outPathUtf8 = outPath.toNativeUtf8().cast();
    final rs =
        bindings.PcmFileSamplingRateConversion(configPathUtf8, outPathUtf8);
    pkg_ffi.calloc.free(configPathUtf8);
    pkg_ffi.calloc.free(outPathUtf8);
    return rs;
  }
}
