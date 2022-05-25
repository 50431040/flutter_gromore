package net.niuxiaoer.flutter_gromore

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import net.niuxiaoer.flutter_gromore.event.AdEventHandler

/** FlutterGromorePlugin */
class FlutterGromorePlugin: FlutterPlugin, ActivityAware {

  // 事件名
  private val methodChannelName = "flutter_gromore"
  private val eventChannelName = "flutter_gromore_event"

  // 通道实例
  private var methodChannel: MethodChannel? = null
  private var eventChannel: EventChannel? = null

  // 代理
  private var pluginDelegate: PluginDelegate? = null
  private var adEventListener: AdEventHandler? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, methodChannelName)
    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, eventChannelName)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel?.setMethodCallHandler(null)
    eventChannel?.setStreamHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    adEventListener = adEventListener ?: AdEventHandler.getInstance()
    pluginDelegate = pluginDelegate ?: PluginDelegate(binding.activity)

    methodChannel?.setMethodCallHandler(pluginDelegate)
    eventChannel?.setStreamHandler(adEventListener)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity()
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onAttachedToActivity(binding)
  }

  override fun onDetachedFromActivity() {
    pluginDelegate = null
  }
}
