package net.niuxiaoer.flutter_gromore

import android.app.Activity
import android.content.Intent
import com.bytedance.msdk.api.v2.GMAdConfig
import com.bytedance.msdk.api.v2.GMMediationAdSdk
import io.flutter.BuildConfig
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import net.niuxiaoer.flutter_gromore.view.FlutterGromoreSplash

class PluginDelegate(activity: Activity): MethodChannel.MethodCallHandler, EventChannel.StreamHandler {
    private var activity: Activity = activity


    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val method: String = call.method
        val arguments = call.arguments as? Map<String, Any?>

        when(method) {
            // 同时请求：READ_PHONE_STATE, COARSE_LOCATION, FINE_LOCATION, WRITE_EXTERNAL_STORAGE权限
            "requestPermissionIfNecessary" -> {
                GMMediationAdSdk.requestPermissionIfNecessary(activity)
                result.success(true)
            }
            // 初始化
            "initSDK" -> {
                initSDK(arguments)
                result.success(true)
            }
            // 开屏
            "showSplash" -> {
                showSplash(arguments)
                result.success(true)
            }
        }
    }

    // 初始化SDK
    private fun initSDK(arguments: Map<String, Any?>?) {
        val appId = arguments?.get("appId") as? String ?: ""
        val appName = arguments?.get("appName") as? String ?: ""
        val debug = arguments?.get("debug") as? Boolean ?: BuildConfig.DEBUG

        val config = GMAdConfig.Builder()
                .setAppId(appId)
                .setAppName(appName)
                .setDebug(debug)
                .build()

        GMMediationAdSdk.initialize(activity.applicationContext, config)
    }

    // 开屏广告
    private fun showSplash(arguments: Map<String, Any?>?) {

        val intent = Intent(activity, FlutterGromoreSplash::class.java)
        intent.putExtra("adUnitId", arguments?.get("adUnitId") as? String)
        intent.putExtra("muted", arguments?.get("muted") as? Boolean)
        intent.putExtra("preload", arguments?.get("preload") as? Boolean)
        intent.putExtra("volume", arguments?.get("volume") as? Float)
        intent.putExtra("timeout", arguments?.get("timeout") as? Int)

        activity.startActivity(intent)
        activity.overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out)
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {

    }

    override fun onCancel(arguments: Any?) {

    }

}