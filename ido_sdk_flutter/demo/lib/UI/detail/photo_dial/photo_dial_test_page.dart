import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:protocol_lib/protocol_lib.dart';

/// 照片云表盘联调页 — prepare + install（思澈 / Actions 平台自动分流）
class PhotoDialTestPage extends StatefulWidget {
  const PhotoDialTestPage({super.key});

  @override
  State<PhotoDialTestPage> createState() => _PhotoDialTestPageState();
}

class _PhotoDialTestPageState extends State<PhotoDialTestPage> {
  final _logBuffer = StringBuffer();
  final _dialNameCtrl = TextEditingController(text: 'wallpaper.z');
  
  String _packagePath = '';
  String? _bgPicPath;
  String? _previewPicPath;
  
  IDOPhotoDialUiPreset? _preset;
  int _timeColorIndex = 0;
  int _funcColorIndex = 0;
  int _position = IDOPhotoDialWidgetPosition.rightTop;
  int _showFunction = IDOPhotoDialWidgetFunction.weekDate;
  
  double? _transferProgress;
  bool _installing = false;
  bool _preparing = false;
  String? _lastPreparedDialName;
  
  void _resetDialUiState() {
    _preset = null;
    _bgPicPath = null;
    _previewPicPath = null;
    _timeColorIndex = 0;
    _funcColorIndex = 0;
    _position = IDOPhotoDialWidgetPosition.rightTop;
    _showFunction = IDOPhotoDialWidgetFunction.weekDate;
    _transferProgress = null;
  }
  
  @override
  void dispose() {
    _dialNameCtrl.dispose();
    super.dispose();
  }
  
  String get _dialName => _dialNameCtrl.text.trim();
  
  void _log(String msg) {
    _logBuffer.writeln(msg);
    debugPrint('[PhotoDialTest] $msg');
    if (mounted) setState(() {});
  }
  
  void _clearLog() {
    _logBuffer.clear();
    setState(() {});
  }
  
  bool _ensureConnected() {
    if (libManager.isConnected) return true;
    EasyLoading.showError('未连接设备');
    _log('错误：设备未连接');
    return false;
  }
  
  /// 将 [FilePicker] 结果转为本地可读绝对路径（iOS FileProvider 须完整读入再写入）
  Future<String?> _materializePickedFile(
    PlatformFile file, {
    bool forceLocalCopy = false,
  }) async {
    final dir = await getTemporaryDirectory();
    final safeName = file.name.isNotEmpty ? file.name : 'picked_file';
    final dest = p.join(
      dir.path,
      'photo_dial_${DateTime.now().millisecondsSinceEpoch}_$safeName',
    );
  
    List<int>? bytes = file.bytes;
    if ((bytes == null || bytes.isEmpty) &&
        file.path != null &&
        file.path!.isNotEmpty) {
      final src = File(file.path!);
      if (await src.exists()) {
        bytes = await src.readAsBytes();
      }
    }
    if (bytes != null && bytes.isNotEmpty) {
      await File(dest).writeAsBytes(bytes);
      return dest;
    }
  
    if (!forceLocalCopy &&
        file.path != null &&
        file.path!.isNotEmpty &&
        await File(file.path!).exists()) {
      return file.path;
    }
    return null;
  }
  
  bool _isZipHeader(List<int> bytes) =>
      bytes.length >= 2 && bytes[0] == 0x50 && bytes[1] == 0x4B;
  
  Future<void> _pickZipPackage() async {
    if (_preparing) return;
    if (!_ensureConnected()) return;
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['zip'],
        withData: true,
        allowMultiple: false,
      );
      if (result == null || result.files.isEmpty) return;
      final file = result.files.first;
      final path = await _materializePickedFile(file, forceLocalCopy: true);
      if (path == null) {
        EasyLoading.showError('无法读取 zip 文件');
        return;
      }
      final zipHead = await File(path).openRead(0, 4).fold(<int>[], (p, e) => p..addAll(e));
      if (!_isZipHeader(zipHead)) {
        EasyLoading.showError('zip 文件无效或未下载完成');
        _log('zip 头校验失败: $path');
        return;
      }
      if (_dialNameCtrl.text.trim().isEmpty ||
          _dialNameCtrl.text.trim() == 'wallpaper.z') {
        final guessed = p.basenameWithoutExtension(file.name);
        if (guessed.isNotEmpty) {
          _dialNameCtrl.text = guessed;
        }
      }
      final newDialName = _dialName;
      if (_installing) {
        IDODialManager().dialPhoto.cancelInstall();
        _installing = false;
      }
      // 切换表盘名时清理上一份本地缓存；同名新 zip 由 prepare 内再次清理
      if (_lastPreparedDialName != null &&
          _lastPreparedDialName!.isNotEmpty &&
          _lastPreparedDialName != newDialName) {
        _log('清理旧表盘本地缓存: $_lastPreparedDialName');
        await IDODialManager()
            .dialPhoto
            .clearLocalResources(_lastPreparedDialName!);
      }
      setState(() {
        _packagePath = path;
        _resetDialUiState();
      });
      _log('已选表盘包: $path');
      if (_dialName.isNotEmpty) {
        _log('  dialName: $_dialName');
      }
      await _prepare();
      _lastPreparedDialName = _dialName;
    } catch (e) {
      _log('选择 zip 失败: $e');
      EasyLoading.showError('$e');
    }
  }
  
  Future<void> _pickImage({required bool isPreview}) async {
    if (_preset == null || _dialName.isEmpty) {
      EasyLoading.showToast('请先选择表盘 zip（将自动解析）');
      return;
    }
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
        allowMultiple: false,
      );
      if (result == null || result.files.isEmpty) return;
      final file = result.files.first;
      final path = await _materializePickedFile(file);
      if (path == null) {
        EasyLoading.showError('无法读取图片');
        return;
      }
      EasyLoading.show(status: '裁剪中…');
      final cropped = await IDODialManager().dialPhoto.cropSelectedImage(
        dialName: _dialName,
        sourcePath: path,
        isPreview: isPreview,
        preset: _preset,
      );
      if (cropped == null || !File(cropped).existsSync()) {
        _log('裁剪失败: 无法解析表盘参考尺寸');
        EasyLoading.showError('裁剪失败，请重新选择表盘 zip');
        return;
      }
      setState(() {
        if (isPreview) {
          _previewPicPath = cropped;
        } else {
          _bgPicPath = cropped;
        }
      });
      _log(isPreview ? '已选预览图(已裁剪): $cropped' : '已选背景图(已裁剪): $cropped');
      EasyLoading.showSuccess('已裁剪');
    } catch (e) {
      _log('选择图片失败: $e');
      EasyLoading.showError('$e');
    } finally {
      EasyLoading.dismiss();
    }
  }
  
  Future<void> _prepare() async {
    if (!_ensureConnected()) return;
    if (_dialName.isEmpty || _packagePath.isEmpty) {
      EasyLoading.showToast('请选择表盘 zip 并填写表盘名');
      return;
    }
    setState(() => _preparing = true);
    EasyLoading.show(status: '解析表盘包…');
    try {
      final preset =
          await IDODialManager().dialPhoto.prepare(_dialName, _packagePath);
      _preset = preset;
      if (preset == null) {
        _log('prepare 失败');
        EasyLoading.showError('解析失败');
        return;
      }
      _applyPresetDefaults(preset);
      if (mounted) setState(() {});
      _log('prepare 成功: dial=${preset.dialName}');
      _log('  平台: ${libManager.deviceInfo.isSilfiPlatform() ? "思澈" : "Actions"}');
      _log('  位置: $_position  功能: $_showFunction (${IDOPhotoDialWidgetFunction.labelOf(_showFunction)})');
      _log('  可选位置(${preset.supportPositions.length}): ${preset.supportPositions}');
      _log('  颜色数: ${preset.timeColorList.length}');
      _log('  能力: 颜色=${preset.supportColorSetting} '
          '位置=${preset.supportLocation} '
          '功能选择=${preset.canSelectFunction} '
          '功能颜色=${preset.supportFunctionColorSetting}');
      EasyLoading.showSuccess('解析成功');
    } catch (e) {
      _log('prepare 异常: $e');
      EasyLoading.showError('$e');
    } finally {
      if (mounted) setState(() => _preparing = false);
      EasyLoading.dismiss();
    }
  }
  
  /// prepare 后加载外壳 images/ 下默认背景（bg.png 或 image.png）与 preview.png
  void _applyPresetDefaults(IDOPhotoDialUiPreset preset) {
    _timeColorIndex = preset.timeColorList.indexOf(preset.timeColor);
    if (_timeColorIndex < 0) _timeColorIndex = 0;
    _funcColorIndex =
        preset.functionWidgetColorList.indexOf(preset.defaultFunctionWidgetColor);
    if (_funcColorIndex < 0) _funcColorIndex = _timeColorIndex;
    _position = _normalizePosition(preset);
    _showFunction = _normalizeFunction(preset);
  
    _bgPicPath = _resolveExistingImagePath(preset.bg);
    _previewPicPath = _resolveExistingImagePath(preset.preview);
  
    if (_bgPicPath != null) {
      _log('  默认背景: $_bgPicPath');
    } else {
      _log('  默认背景: 未找到');
    }
    if (_previewPicPath != null) {
      _log('  默认预览: $_previewPicPath');
    } else {
      _log('  默认预览: 未找到');
    }
  }
  
  String? _resolveExistingImagePath(String path) {
    if (path.isEmpty || !File(path).existsSync()) return null;
    return path;
  }
  
  Future<void> _install() async {
    if (!_ensureConnected()) return;
    if (_preset == null) {
      EasyLoading.showToast('请先选择表盘 zip');
      return;
    }
    if (_bgPicPath == null || _bgPicPath!.isEmpty) {
      EasyLoading.showToast('请选择背景图');
      return;
    }
    final colors = _preset!.timeColorList;
    final config = IDOPhotoDialConfig(
      dialName: _dialName,
      bgPicPath: _bgPicPath,
      previewPicPath: _previewPicPath,
      timeColor: colors[_timeColorIndex.clamp(0, colors.length - 1)],
      functionColor: colors[_funcColorIndex.clamp(0, colors.length - 1)],
      position: _position,
      showFunction: _showFunction,
    );
    setState(() {
      _installing = true;
      _transferProgress = 0;
    });
    _log('--- install 开始 ---');
    IDODialManager().dialPhoto.install(
      config,
      onProgress: (prog) {
        setState(() => _transferProgress = prog / 100.0);
        _log('进度: $prog%');
      },
      onSuccess: () {
        _log('install 成功');
        EasyLoading.showSuccess('安装成功');
        setState(() => _installing = false);
      },
      onFailed: (code, msg) {
        _log('install 失败: code=$code msg=$msg');
        EasyLoading.showError('失败 $code');
        setState(() => _installing = false);
      },
    );
  }
  
  void _cancelInstall() {
    IDODialManager().dialPhoto.cancelInstall();
    setState(() => _installing = false);
    _log('已取消安装');
  }
  
  /// 位置下拉：严格使用表盘包 app.json locations[].type（对齐 Demo mLocationValues）
  List<int> _positionOptions(IDOPhotoDialUiPreset preset) =>
      preset.supportPositions
          .where((e) => e != IDOPhotoDialWidgetPosition.invalid)
          .toList();
  
  int _normalizePosition(IDOPhotoDialUiPreset preset) {
    final options = _positionOptions(preset);
    if (options.isEmpty) return preset.position;
    final raw = preset.position;
    if (raw != IDOPhotoDialWidgetPosition.invalid && options.contains(raw)) {
      return raw;
    }
    return options.first;
  }
  
  String _positionLabel(int value) {
    switch (value) {
      case IDOPhotoDialWidgetPosition.leftTop:
        return '左上';
      case IDOPhotoDialWidgetPosition.centerTop:
        return '上中';
      case IDOPhotoDialWidgetPosition.rightTop:
        return '右上';
      case IDOPhotoDialWidgetPosition.leftCenter:
        return '左中';
      case IDOPhotoDialWidgetPosition.center:
        return '居中';
      case IDOPhotoDialWidgetPosition.rightCenter:
        return '右中';
      case IDOPhotoDialWidgetPosition.leftBottom:
        return '左下';
      case IDOPhotoDialWidgetPosition.centerBottom:
        return '下中';
      case IDOPhotoDialWidgetPosition.rightBottom:
        return '右下';
      case IDOPhotoDialWidgetPosition.center55:
        return '居中竖排';
      default:
        return '位置 $value';
    }
  }
  
  /// 功能 id 列表，来自 preset（对齐 Android generateConfig 1~6）
  List<int> _functionOptions(IDOPhotoDialUiPreset preset) =>
      preset.supportFunctionTypeList
          .where(IDOPhotoDialWidgetFunction.all.contains)
          .toList();
  
  int _normalizeFunction(IDOPhotoDialUiPreset preset) {
    final options = _functionOptions(preset);
    if (options.contains(preset.defaultFunctionType)) {
      return preset.defaultFunctionType;
    }
    if (options.contains(_showFunction)) return _showFunction;
    return options.first;
  }
  
  Widget _filePickTile({
    required String title,
    required String? path,
    required VoidCallback onPick,
    VoidCallback? onClear,
    Widget? trailing,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(title, style: Theme.of(context).textTheme.titleSmall),
                ),
                TextButton(onPressed: onPick, child: const Text('选择')),
                if (path != null && path.isNotEmpty && onClear != null)
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: onClear,
                    tooltip: '清除',
                  ),
              ],
            ),
            Text(
              path == null || path.isEmpty ? '未选择' : path,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade700,
                  ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (trailing != null) ...[
              const SizedBox(height: 8),
              trailing,
            ],
          ],
        ),
      ),
    );
  }
  
  Widget? _imagePreview(String? path, {required bool isPreview}) {
    if (path == null || path.isEmpty || !File(path).existsSync()) {
      return null;
    }
    final radius = isPreview
        ? (_preset?.previewRadius ?? 16)
        : (_preset?.screenCorner ?? 0) > 0
            ? _preset!.screenCorner
            : (_preset?.previewRadius ?? 16);
    return Container(
      width: double.infinity,
      color: Colors.grey.shade300,
      padding: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.file(
          File(path),
          height: 160,
          width: double.infinity,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final colors = _preset?.timeColorList ?? IDOPhotoDialWidgetColor.defaults;
    return Scaffold(
      appBar: AppBar(title: const Text('照片表盘联调')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: '表盘名 (dialName)',
              hintText: '可与 zip 文件名一致，如 wallpaper.z',
            ),
            controller: _dialNameCtrl,
          ),
          const SizedBox(height: 8),
          _filePickTile(
            title: '表盘外壳 zip（选完自动 Prepare）',
            path: _packagePath.isEmpty ? null : _packagePath,
            onPick: _pickZipPackage,
            onClear: _packagePath.isEmpty || _preparing
                ? null
                : () async {
                    if (_installing) {
                      IDODialManager().dialPhoto.cancelInstall();
                    }
                    if (_lastPreparedDialName != null &&
                        _lastPreparedDialName!.isNotEmpty) {
                      await IDODialManager()
                          .dialPhoto
                          .clearLocalResources(_lastPreparedDialName!);
                    }
                    setState(() {
                      _packagePath = '';
                      _lastPreparedDialName = null;
                      _installing = false;
                      _resetDialUiState();
                    });
                  },
          ),
          _filePickTile(
            title: '背景图（prepare 后自动加载表盘包默认）',
            path: _bgPicPath,
            onPick: () => _pickImage(isPreview: false),
            onClear: _bgPicPath == null
                ? null
                : () => setState(() => _bgPicPath = null),
            trailing: _imagePreview(_bgPicPath, isPreview: false),
          ),
          _filePickTile(
            title: '预览图（可选，prepare 后自动加载表盘包默认）',
            path: _previewPicPath,
            onPick: () => _pickImage(isPreview: true),
            onClear: _previewPicPath == null
                ? null
                : () => setState(() => _previewPicPath = null),
            trailing: _imagePreview(_previewPicPath, isPreview: true),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton(
                onPressed: _installing || _preparing ? null : _install,
                child: const Text('Install'),
              ),
              OutlinedButton(
                onPressed: _installing ? _cancelInstall : null,
                child: const Text('Cancel'),
              ),
              TextButton(onPressed: _clearLog, child: const Text('清空日志')),
            ],
          ),
          if (_preparing)
            const LinearProgressIndicator(),
          if (_installing && _transferProgress != null)
            LinearProgressIndicator(value: _transferProgress),
          if (_preset != null) ...[
            const Divider(),
            Text(
              '表盘能力（对齐原生 cloudWallpaper / function_support_new）',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(
              '颜色: ${_preset!.supportColorSetting ? "支持" : "不支持"} · '
              '位置: ${_preset!.supportLocation ? "支持" : "不支持"} · '
              '功能选择: ${_preset!.canSelectFunction ? "支持" : "不支持"} · '
              '功能颜色: ${_preset!.supportFunctionColorSetting ? "支持" : "不支持"}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (_preset!.supportColorSetting) ...[
              const SizedBox(height: 8),
              const Text('时间颜色'),
              DropdownButton<int>(
                value: _timeColorIndex.clamp(0, colors.length - 1),
                isExpanded: true,
                items: [
                  for (var i = 0; i < colors.length; i++)
                    DropdownMenuItem(value: i, child: Text(colors[i])),
                ],
                onChanged: (v) => setState(() => _timeColorIndex = v ?? 0),
              ),
            ],
            if (_preset!.supportFunctionColorSetting) ...[
              const Text('功能颜色'),
              DropdownButton<int>(
                value: _funcColorIndex.clamp(0, colors.length - 1),
                isExpanded: true,
                items: [
                  for (var i = 0; i < colors.length; i++)
                    DropdownMenuItem(value: i, child: Text(colors[i])),
                ],
                onChanged: (v) => setState(() => _funcColorIndex = v ?? 0),
              ),
            ],
            if (_preset!.supportLocation &&
                _positionOptions(_preset!).isNotEmpty) ...[
              const Text('位置'),
              DropdownButton<int>(
                value: _positionOptions(_preset!).contains(_position)
                    ? _position
                    : _positionOptions(_preset!).first,
                isExpanded: true,
                items: [
                  for (final pos in _positionOptions(_preset!))
                    DropdownMenuItem(
                      value: pos,
                      child: Text(_positionLabel(pos)),
                    ),
                ],
                onChanged: (v) => setState(() => _position = v ?? _position),
              ),
            ],
            if (_preset!.canSelectFunction) ...[
              const Text('功能'),
              DropdownButton<int>(
                value: _functionOptions(_preset!).contains(_showFunction)
                    ? _showFunction
                    : _functionOptions(_preset!).first,
                isExpanded: true,
                items: [
                  for (final func in _functionOptions(_preset!))
                    DropdownMenuItem(
                      value: func,
                      child: Text(IDOPhotoDialWidgetFunction.labelOf(func)),
                    ),
                ],
                onChanged: (v) =>
                    setState(() => _showFunction = v ?? _showFunction),
              ),
            ],
          ],
          const Divider(),
          SelectableText(
            _logBuffer.toString().isEmpty ? '（日志）' : _logBuffer.toString(),
          ),
        ],
      ),
    );
  }
}
