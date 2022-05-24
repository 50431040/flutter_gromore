package net.niuxiaoer.flutter_gromore

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterGromorePlugin */
class FlutterGromorePlugin: FlutterPlugin, ActivityAware {

  // 事件名
  val methodChannelName = "flutter_gromore"
  val eventChannelName = "flutter_gromore_event"

  // 通道实例
  var methodChannel: MethodChannel? = null
  var eventChannel: EventChannel? = null

  // 代理，处理事件
  var pluginDelegate: PluginDelegate? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, methodChannelName)
    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, eventChannelName)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel?.setMethodCallHandler(null)
    eventChannel?.setStreamHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    if (pluginDelegate == null) {
      pluginDelegate = PluginDelegate(binding.activity);
    }

    methodChannel?.setMethodCallHandler(pluginDelegate)
    eventChannel?.setStreamHandler(pluginDelegate)
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
