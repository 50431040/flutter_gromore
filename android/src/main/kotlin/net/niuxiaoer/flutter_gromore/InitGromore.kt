package net.niuxiaoer.flutter_gromore

import android.content.Context
import android.util.Log
import com.bytedance.sdk.openadsdk.TTAdConfig
import com.bytedance.sdk.openadsdk.TTAdSdk
import com.bytedance.sdk.openadsdk.mediation.init.MediationConfig
import io.flutter.BuildConfig
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject
import java.io.InputStream

class InitGromore(private val context: Context) : TTAdSdk.InitCallback {
    private val TAG: String = this::class.java.simpleName
    private lateinit var initResult: MethodChannel.Result
    // 由于失败后会进行重试，可能会回调多次。这个flag标识是否调用
    private var resultCalled: Boolean = false

    // 初始化SDK
    fun initSDK(arguments: Map<String, Any?>?, result: MethodChannel.Result) {
        // 已经初始化成功
        if (TTAdSdk.isInitSuccess()) {
            resultCalled = true
            result.success(true)
            return
        }

        require(arguments != null)

        initResult = result

        // 取出传递的参数
        val appId = arguments["appId"] as? String ?: ""
        val appName = arguments["appName"] as? String ?: ""
        val debug = arguments["debug"] as? Boolean ?: BuildConfig.DEBUG
        // 是否使用聚合，默认为false
        val useMediation = arguments["useMediation"] as? Boolean ?: false

        require(appId.isNotEmpty())

        val config = TTAdConfig.Builder()
                .appId(appId)
                .appName(appName)
                .useMediation(useMediation)
                .setMediationConfig(MediationConfig.Builder().setCustomLocalConfig(loadLocalConfig()).build())
                .debug(debug)
                .build()

        TTAdSdk.init(context, config, this)
    }

    /**
     * GroMore 本地缓存配置
     * 由穿山甲后台导出配置信息，减少配置拉取失败率
     */
    private fun loadLocalConfig(): JSONObject? {
        return try {
            val inputStream: InputStream = context.assets.open("gromore_local_config")
            val text: String = inputStream.bufferedReader().use {
                it.readText()
            }
            JSONObject(text)
        } catch (error: Exception) {
            Log.d(TAG, "gromore_local_config read fail")
            null;
        }
    }

    override fun success() {
        Log.d(TAG, "init-success")
        if (resultCalled) {
            return
        }
        resultCalled = true
        initResult.success(true)
    }

    override fun fail(p0: Int, p1: String?) {
        Log.d(TAG, "init-fail")
        if (resultCalled) {
            return
        }
        resultCalled = true
        initResult.error(p0.toString(), p1, p1)
    }
}