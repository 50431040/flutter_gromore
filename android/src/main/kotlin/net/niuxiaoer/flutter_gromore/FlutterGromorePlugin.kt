package net.niuxiaoer.flutter_gromore

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import net.niuxiaoer.flutter_gromore.constants.FlutterGromoreConstants
import net.niuxiaoer.flutter_gromore.event.AdEventHandler
import net.niuxiaoer.flutter_gromore.factory.FlutterGromoreBannerFactory
import net.niuxiaoer.flutter_gromore.factory.FlutterGromoreFeedFactory
import net.niuxiaoer.flutter_gromore.factory.FlutterGromoreSplashFactory

/** FlutterGromorePlugin */
class FlutterGromorePlugin : FlutterPlugin, ActivityAware {

    // 通道实例
    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel

    // 代理
    private var pluginDelegate: PluginDelegate? = null
    private var adEventListener: AdEventHandler? = null

    private lateinit var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
    private lateinit var binaryMessenger: BinaryMessenger

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        this.flutterPluginBinding = flutterPluginBinding
        binaryMessenger = flutterPluginBinding.binaryMessenger

        methodChannel = MethodChannel(binaryMessenger, FlutterGromoreConstants.methodChannelName)
        eventChannel = EventChannel(binaryMessenger, FlutterGromoreConstants.eventChannelName)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        adEventListener = adEventListener ?: AdEventHandler.getInstance()
        pluginDelegate = pluginDelegate ?: PluginDelegate(
                flutterPluginBinding.applicationContext,
                binding.activity,
                binaryMessenger
        )

        methodChannel.setMethodCallHandler(pluginDelegate)
        eventChannel.setStreamHandler(adEventListener)

        // 注册PlatformView
        flutterPluginBinding
                .platformViewRegistry
                .registerViewFactory(
                        FlutterGromoreConstants.feedViewTypeId,
                        FlutterGromoreFeedFactory(binding.activity, binaryMessenger)
                )

        flutterPluginBinding
                .platformViewRegistry
                .registerViewFactory(
                        FlutterGromoreConstants.splashTypeId,
                        FlutterGromoreSplashFactory(binding.activity, binaryMessenger)
                )

        flutterPluginBinding
                .platformViewRegistry
                .registerViewFactory(
                        FlutterGromoreConstants.bannerTypeId,
                        FlutterGromoreBannerFactory(binding.activity, binaryMessenger)
                )
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
