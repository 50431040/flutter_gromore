package net.niuxiaoer.flutter_gromore

import android.app.Activity
import android.content.Intent
import android.util.Log
import com.bytedance.msdk.api.v2.GMAdConfig
import com.bytedance.msdk.api.v2.GMMediationAdSdk
import io.flutter.BuildConfig
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import net.niuxiaoer.flutter_gromore.event.AdEventHandler
import net.niuxiaoer.flutter_gromore.view.FlutterGromoreInterstitial
import net.niuxiaoer.flutter_gromore.view.FlutterGromoreSplash

class PluginDelegate(private val activity: Activity, private val binaryMessenger: BinaryMessenger): MethodChannel.MethodCallHandler {
    private val TAG: String = this::class.java.simpleName

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val method: String = call.method
        val arguments = call.arguments as? Map<String, Any?>

        Log.d(TAG, method)

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
            "showSplashAd" -> {
                showSplash(arguments)
                result.success(true)
            }
            // 插屏
            "showInterstitialAd" -> {
                require(arguments != null && arguments["id"] != null)
                FlutterGromoreInterstitial(activity, binaryMessenger, arguments)
                result.success(true)
            }
        }
    }

    // 初始化SDK
    private fun initSDK(arguments: Map<String, Any?>?) {
        require(arguments != null)

        // 取出传递的参数
        val appId = arguments["appId"] as? String ?: ""
        val appName = arguments["appName"] as? String ?: ""
        val debug = arguments["debug"] as? Boolean ?: BuildConfig.DEBUG

        require(appId.isNotEmpty())

        val config = GMAdConfig.Builder()
                .setAppId(appId)
                .setAppName(appName)
                .setDebug(debug)
                .build()

        GMMediationAdSdk.initialize(activity.applicationContext, config)
    }

    // 开屏广告
    private fun showSplash(arguments: Map<String, Any?>?) {

        require(arguments != null)

        val intent = Intent(activity, FlutterGromoreSplash::class.java).apply {
            putExtra("id", arguments["id"] as? String)
            putExtra("adUnitId", arguments["adUnitId"] as? String)
            putExtra("logo", arguments["logo"] as? String)
            putExtra("muted", arguments["muted"] as? Boolean)
            putExtra("preload", arguments["preload"] as? Boolean)
            putExtra("volume", arguments["volume"] as? Float)
            putExtra("timeout", arguments["timeout"] as? Int)
            putExtra("buttonType", arguments["buttonType"] as? Int)
            putExtra("downloadType", arguments["downloadType"] as? Int)
        }

        activity.apply {
            startActivity(intent)
            activity.overridePendingTransition(0, 0)
        }

    }

}