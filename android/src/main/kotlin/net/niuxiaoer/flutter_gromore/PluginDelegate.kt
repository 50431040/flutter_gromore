package net.niuxiaoer.flutter_gromore

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.util.Log
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import net.niuxiaoer.flutter_gromore.manager.*
import net.niuxiaoer.flutter_gromore.utils.Utils
import net.niuxiaoer.flutter_gromore.view.FlutterGromoreInterstitial
import net.niuxiaoer.flutter_gromore.view.FlutterGromoreReward
import net.niuxiaoer.flutter_gromore.view.FlutterGromoreSplash

class PluginDelegate(
        private val context: Context,
        private val activity: Activity,
        private val binaryMessenger: BinaryMessenger
) : MethodChannel.MethodCallHandler {
    private val TAG: String = this::class.java.simpleName

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val method: String = call.method
        val arguments = call.arguments as? Map<String, Any?>

        Log.d(TAG, method)

        when (method) {
            // 同时请求：READ_PHONE_STATE, COARSE_LOCATION, FINE_LOCATION, WRITE_EXTERNAL_STORAGE权限
            "requestPermissionIfNecessary" -> {
                result.success(true)
            }
            // 初始化
            "initSDK" -> {
                InitGromore(context).initSDK(arguments, result)
            }
            // 开屏
            "showSplashAd" -> {
                showSplash(arguments)
                // 在开屏广告关闭后才会调用result.success
                Utils.splashResult = result
            }
            // 加载插屏广告
            "loadInterstitialAd" -> {
                require(arguments != null && arguments["adUnitId"] != null)
                FlutterGromoreInterstitialManager(arguments, activity, result)
            }
            // 展示插屏广告
            "showInterstitialAd" -> {
                require(arguments != null && arguments["interstitialId"] != null)
                FlutterGromoreInterstitial(activity, binaryMessenger, arguments, result)
            }
            // 移除插屏广告
            "removeInterstitialAd" -> {
                require(arguments != null && arguments["interstitialId"] != null)
                FlutterGromoreInterstitialCache.removeCacheInterstitialAd((arguments["interstitialId"] as String).toInt())
                result.success(true)
            }
            // 加载信息流广告
            "loadFeedAd" -> {
                require(arguments != null && arguments["adUnitId"] != null)
                FlutterGromoreFeedManager(arguments, context, result)
            }
            // 移除信息流广告
            "removeFeedAd" -> {
                require(arguments != null && arguments["feedId"] != null)
                FlutterGromoreFeedCache.removeCacheFeedAd(arguments["feedId"] as String)
                result.success(true)
            }
            // 加载激励广告
            "loadRewardAd" -> {
                require(arguments != null && arguments["adUnitId"] != null)
                FlutterGromoreRewardManager(arguments, activity, result)
            }
            // 展示激励广告
            "showRewardAd" -> {
                require(arguments != null && arguments["rewardId"] != null)
                FlutterGromoreReward(activity, binaryMessenger, arguments, result)
            }
            else -> {
                Log.d(TAG, "unknown method $method")
                result.success(true)
            }
        }
    }

    // 开屏广告
    private fun showSplash(arguments: Map<String, Any?>?) {

        require(arguments != null)

        val intent = Intent(context, FlutterGromoreSplash::class.java).apply {
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