import 'package:demo/UI/function/function_index.dart';
import 'package:demo/UI/home/home_page.dart';
import 'package:demo/utility/bind_state_storage.dart';
import 'package:demo/utility/connection_status_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth/ido_bluetooth.dart';

/// 已绑定设备首页（冷启动入口）
class BoundDevicesPage extends StatefulWidget {
  const BoundDevicesPage({super.key});

  @override
  State<BoundDevicesPage> createState() => _BoundDevicesPageState();
}

class _BoundDevicesPageState extends State<BoundDevicesPage>
    with WidgetsBindingObserver {
  List<BoundDeviceRecord> _devices = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ConnectionStatusController.instance.addListener(_onStatusChanged);
    _reload();
  }

  @override
  void dispose() {
    ConnectionStatusController.instance.removeListener(_onStatusChanged);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _onStatusChanged() {
    if (mounted) setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _reload();
    }
  }

  Future<void> _reload() async {
    final list = await BindStateStorage.loadAll();
    if (!mounted) return;
    setState(() {
      _devices = list;
      _loading = false;
    });
  }

  Future<void> _openScan() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
    await _reload();
  }

  Future<void> _openDevice(BoundDeviceRecord record) async {
    final device = record.toDeviceModel();
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FunctionIndex(device)),
    );
    await _reload();
  }

  Future<void> _confirmRemove(BoundDeviceRecord record) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('移除本地记录'),
        content: Text(
          '仅清除本机「${record.name}」记录，不会向设备发送解绑。\n真正解绑请进入功能页操作。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('移除'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await BindStateStorage.remove(record.macAddress);
    await _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的设备'),
        actions: [
          IconButton(
            tooltip: '添加设备',
            icon: const Icon(Icons.add),
            onPressed: _openScan,
          ),
        ],
      ),
      body: Column(
        children: [
          const ConnectionStatusBanner(),
          Expanded(child: _buildBody()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openScan,
        icon: const Icon(Icons.bluetooth_searching),
        label: const Text('添加设备'),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_devices.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.devices_other, size: 56, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              Text(
                '暂无已绑定设备',
                style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 8),
              Text(
                '点击右上角「+」或下方「添加设备」扫描并绑定',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      );
    }

    final currentMac = bluetoothManager.currentDevice?.macAddress;
    final status = ConnectionStatusController.instance;

    return RefreshIndicator(
      onRefresh: _reload,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 88),
        itemCount: _devices.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final record = _devices[index];
          final isCurrent = currentMac != null &&
              currentMac.isNotEmpty &&
              currentMac == record.macAddress &&
              status.isConnected;

          return Dismissible(
            key: ValueKey(record.macAddress),
            direction: DismissDirection.endToStart,
            confirmDismiss: (_) async {
              await _confirmRemove(record);
              return false;
            },
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                color: Colors.red.shade400,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: Card(
              elevation: 1,
              child: ListTile(
                leading: Icon(
                  Icons.watch,
                  color: isCurrent ? Colors.green : Colors.blueGrey,
                ),
                title: Text(
                  record.name.isNotEmpty ? record.name : record.macAddress,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  record.macAddress,
                  style: const TextStyle(color: Colors.redAccent),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isCurrent)
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Text(
                          '当前',
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    Chip(
                      label: Text(
                        record.isBinded ? '已绑定' : '未绑定',
                        style: const TextStyle(fontSize: 11),
                      ),
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      backgroundColor: record.isBinded
                          ? Colors.green.shade50
                          : Colors.grey.shade200,
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
                onTap: () => _openDevice(record),
                onLongPress: () => _confirmRemove(record),
              ),
            ),
          );
        },
      ),
    );
  }
}
