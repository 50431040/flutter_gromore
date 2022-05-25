package net.niuxiaoer.flutter_gromore

import android.app.Activity
import android.content.Intent
import android.util.Log
import com.bytedance.msdk.api.v2.GMAdConfig
import com.bytedance.msdk.api.v2.GMMediationAdSdk
import io.flutter.BuildConfig
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import net.niuxiaoer.flutter_gromore.event.AdEventHandler
import net.niuxiaoer.flutter_gromore.view.FlutterGromoreSplash

class PluginDelegate(private val activity: Activity): MethodChannel.MethodCallHandler {
    private val TAG: String = this::class.java.simpleName
    private var eventSink: EventChannel.EventSink? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val method: String = call.method
        val arguments = call.arguments as? Map<String, Any?>

        Log.d(TAG, method)

        when(method) {
            // 同时请求：READ_PHONE_STATE, COARSE_LOCATION, FINE_LOCATION, WRITE_EXTERNAL_STORAGE权限
            "requestPermissionIfNecessary" -> {
                Log.d(TAG, "requestPermissionIfNecessary")
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
        // 取出传递的参数
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

        val intent = Intent(activity, FlutterGromoreSplash::class.java).apply {
            putExtra("id", arguments?.get("id") as? String)
            putExtra("adUnitId", arguments?.get("adUnitId") as? String)
            putExtra("logo", arguments?.get("logo") as? String)
            putExtra("muted", arguments?.get("muted") as? Boolean)
            putExtra("preload", arguments?.get("preload") as? Boolean)
            putExtra("volume", arguments?.get("volume") as? Float)
            putExtra("timeout", arguments?.get("timeout") as? Int)
            putExtra("buttonType", arguments?.get("buttonType") as? Int)
            putExtra("downloadType", arguments?.get("downloadType") as? Int)
        }

        activity.startActivity(intent)
        activity.overridePendingTransition(0, 0)
    }

    fun sendEvent() {

    }

}