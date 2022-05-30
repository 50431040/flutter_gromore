package net.niuxiaoer.flutter_gromore

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import net.niuxiaoer.flutter_gromore.constants.FlutterGromoreConstants
import net.niuxiaoer.flutter_gromore.event.AdEventHandler
import net.niuxiaoer.flutter_gromore.factory.FlutterGromoreFeedFactory
import net.niuxiaoer.flutter_gromore.factory.FlutterGromoreSplashFactory

/** FlutterGromorePlugin */
class FlutterGromorePlugin: FlutterPlugin, ActivityAware {

  // 通道实例
  private var methodChannel: MethodChannel? = null
  private var eventChannel: EventChannel? = null

  // 代理
  private var pluginDelegate: PluginDelegate? = null
  private var adEventListener: AdEventHandler? = null

  private lateinit var binaryMessenger: BinaryMessenger

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    binaryMessenger = flutterPluginBinding.binaryMessenger

    methodChannel = MethodChannel(binaryMessenger, FlutterGromoreConstants.methodChannelName)
    eventChannel = EventChannel(binaryMessenger, FlutterGromoreConstants.eventChannelName)

    // 注册PlatformView
    flutterPluginBinding
            .platformViewRegistry
            .registerViewFactory(FlutterGromoreConstants.feedViewTypeId, FlutterGromoreFeedFactory(binaryMessenger))

    flutterPluginBinding
            .platformViewRegistry
            .registerViewFactory(FlutterGromoreConstants.splashTypeId, FlutterGromoreSplashFactory(binaryMessenger))
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel?.setMethodCallHandler(null)
    eventChannel?.setStreamHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    adEventListener = adEventListener ?: AdEventHandler.getInstance()
    pluginDelegate = pluginDelegate ?: PluginDelegate(binding.activity, binaryMessenger)

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
