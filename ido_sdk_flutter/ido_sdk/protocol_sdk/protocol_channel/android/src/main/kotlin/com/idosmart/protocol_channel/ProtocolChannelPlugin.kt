package com.idosmart.protocol_channel

import com.idosmart.pigeon_implement.*
import com.idosmart.pigeongen.api_alexa.Alexa
import com.idosmart.pigeongen.api_alexa.AlexaAuthDelegate
import com.idosmart.pigeongen.api_bind.Bind
import io.flutter.embedding.engine.plugins.FlutterPlugin

import com.idosmart.pigeongen.api_bluetooth.Bluetooth
import com.idosmart.pigeongen.api_bluetooth.BluetoothDelegate
import com.idosmart.pigeongen.api_bridge.Bridge
import com.idosmart.pigeongen.api_bridge.BridgeDelegate
import com.idosmart.pigeongen.api_cache.Cache
import com.idosmart.pigeongen.api_cmd.Cmd
import com.idosmart.pigeongen.api_data_sync.SyncData
import com.idosmart.pigeongen.api_data_sync.SyncDataDelegate
import com.idosmart.pigeongen.api_device.DeviceDelegate
import com.idosmart.pigeongen.api_device_log.DeviceLog
import com.idosmart.pigeongen.api_file_transfer.FileTransfer
import com.idosmart.pigeongen.api_file_transfer.FileTransferDelegate
import com.idosmart.pigeongen.api_message_icon.MessageIcon
import com.idosmart.pigeongen.api_data_exchange.ApiExchangeData
import com.idosmart.pigeongen.api_data_exchange.ApiExchangeDataDelegate
import com.idosmart.pigeongen.api_device.Device
import com.idosmart.pigeongen.api_func_table.FuncTableDelegate
import com.idosmart.pigeongen.api_message_icon.MessageIconDelegate
import com.idosmart.pigeongen.api_device_log.DeviceLogDelegate
import com.idosmart.pigeongen.api_epo.ApiEPOManager
import com.idosmart.pigeongen.api_epo.ApiEpoManagerDelegate
import com.idosmart.pigeongen.api_tools.*
import com.idosmart.pigeongen.api_measure.Measure
import com.idosmart.pigeongen.api_measure.MeasureDelegate
import com.idosmart.pigeon_implement.EpoManagerDelegateImpl
import io.flutter.plugin.common.BinaryMessenger

val plugin: ProtocolChannelPlugin = ProtocolChannelPlugin.instance()

/** ProtocolChannelPlugin */
class ProtocolChannelPlugin: FlutterPlugin {

  private var messenger: BinaryMessenger? = null

  internal var verInfo: VersionInfo? = null

  private fun getMessenger(): BinaryMessenger? {
    return messenger
  }

  //==============do not edit directly begin==============
  private var _bluetooth: Bluetooth? = null
  internal fun bluetooth(): Bluetooth? {
    if (_bluetooth == null) {
        _bluetooth = getMessenger()?.let { Bluetooth(it) }
    }
    return _bluetooth
  }
  //==============do not edit directly end==============

  private var _bridge: Bridge? = null
  internal fun bridge(): Bridge? {
    if (_bridge == null) {
        _bridge = getMessenger()?.let { Bridge(it) }
    }
    return _bridge
  }

  private var _bind: Bind? = null
  internal fun bind(): Bind? {
    if (_bind == null) {
      _bind = getMessenger()?.let { Bind(it) }
    }
    return _bind
  }

  private var _alexa: Alexa? = null

  internal fun alexa(): Alexa? {
    if (_alexa == null) {
      _alexa = getMessenger()?.let { Alexa(it) }
    }
    return _alexa
  }

  private  var _deviceLog: DeviceLog? = null
  internal  fun deviceLog(): DeviceLog? {
    if (_deviceLog == null) {
      _deviceLog = getMessenger()?.let { DeviceLog(it) }
    }
    return _deviceLog
  }

  private  var _messageIcon: MessageIcon? = null
  internal  fun messageIcon(): MessageIcon? {
     if (_messageIcon == null) {
         _messageIcon = getMessenger()?.let { MessageIcon(it) }
     }
    return _messageIcon
  }

  private  var _syncData: SyncData? = null
  internal  fun syncData(): SyncData? {
    if (_syncData == null) {
      _syncData = getMessenger()?.let { SyncData(it) }
    }
    return _syncData
  }

  private  var _fileTransfer: FileTransfer? = null
  internal  fun fileTransfer(): FileTransfer? {
    if (_fileTransfer == null) {
      _fileTransfer = getMessenger()?.let { FileTransfer(it) }
    }
    return _fileTransfer
  }

  private  var _exchange: ApiExchangeData? = null
  internal  fun exchnage(): ApiExchangeData? {
    if (_exchange == null) {
      _exchange = getMessenger()?.let { ApiExchangeData(it) }
    }
    return _exchange
  }

  private  var _cmd: Cmd? = null
  internal  fun cmd(): Cmd? {
    if (_cmd == null) {
      _cmd = getMessenger()?.let { Cmd(it) }
    }
    return _cmd
  }

  private  var _tool: Tool? = null
  internal  fun tool(): Tool? {
    if (_tool == null) {
      _tool = getMessenger()?.let { Tool(it) }
    }
    return _tool
  }

  private  var _cache: Cache? = null
  internal  fun cache(): Cache? {
    if (_cache == null) {
      _cache = getMessenger()?.let { Cache(it) }
    }
    return _cache
  }

  private  var _device: Device? = null
  internal  fun device(): Device? {
    if (_device == null) {
      _device = getMessenger()?.let { Device(it) }
    }
    return _device
  }
  private var _epo: ApiEPOManager? = null
  internal fun epo(): ApiEPOManager? {
    if (_epo == null) {
      _epo = getMessenger()?.let { ApiEPOManager(it) }
    }
    return _epo
  }

  private var _measure: Measure? = null
  internal fun measure(): Measure? {
    if (_measure == null) {
      _measure = getMessenger()?.let { Measure(it) }
    }
    return _measure
  }




  companion object {
    @Volatile
    private var instance: ProtocolChannelPlugin? = null
    fun instance(): ProtocolChannelPlugin {
      return instance ?: synchronized(this) {
        instance ?: ProtocolChannelPlugin().also { instance = it }
      }
    }
  }

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
      instance().messenger = flutterPluginBinding.binaryMessenger
      BluetoothDelegate.setUp(flutterPluginBinding.binaryMessenger,BluetoothDelegateImpl.instance())
      BridgeDelegate.setUp(flutterPluginBinding.binaryMessenger,BridgeDelegateImpl.instance())
      DeviceDelegate.setUp(flutterPluginBinding.binaryMessenger,DeviceDelegateImpl.instance())
      FuncTableDelegate.setUp(flutterPluginBinding.binaryMessenger,FuncTableDelegateImpl.instance())
      AlexaAuthDelegate.setUp(flutterPluginBinding.binaryMessenger,AlexaAuthDelegateImpl.instance())
      SyncDataDelegate.setUp(flutterPluginBinding.binaryMessenger,SyncDataDelegateImpl.instance())
      ApiExchangeDataDelegate.setUp(flutterPluginBinding.binaryMessenger,ExchangeDataDelegateImpl.instance())
      FileTransferDelegate.setUp(flutterPluginBinding.binaryMessenger,FileTransferDelegateImpl.instance())
      MessageIconDelegate.setUp(flutterPluginBinding.binaryMessenger,MessageIconDelegateImpl.instance())
      DeviceLogDelegate.setUp(flutterPluginBinding.binaryMessenger,DeviceLogDelegateImpl.instance())
      ApiEpoManagerDelegate.setUp(flutterPluginBinding.binaryMessenger,EpoManagerDelegateImpl.instance())
      MeasureDelegate.setUp(flutterPluginBinding.binaryMessenger, MeasureDelegateImpl.instance())
      tool()?.getSDKVersionInfo {
        verInfo = it
      }

  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {

  }
}
