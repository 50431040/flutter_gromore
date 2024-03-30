package net.niuxiaoer.flutter_gromore

import android.content.Context
import android.util.Log
import com.bytedance.sdk.openadsdk.TTAdConfig
import com.bytedance.sdk.openadsdk.TTAdSdk
import com.bytedance.sdk.openadsdk.TTCustomController
import com.bytedance.sdk.openadsdk.mediation.init.MediationConfig
import io.flutter.BuildConfig
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject
import java.io.InputStream


class InitGromore(private val context: Context) : TTAdSdk.Callback {
    private val TAG: String = this::class.java.simpleName
    private lateinit var initResult: MethodChannel.Result

    // 由于失败后会进行重试，可能会回调多次。这个flag标识是否调用
    private var resultCalled: Boolean = false

    // 初始化SDK
    fun initSDK(arguments: Map<String, Any?>?, result: MethodChannel.Result) {
        // 已经初始化成功

        if (TTAdSdk.isSdkReady()) {
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
        // 是否为计费用户
        val paid = arguments["paid"] as? Boolean ?: false
        // 是否允许SDK弹出通知
        val allowShowNotify = arguments["allowShowNotify"] as? Boolean ?: false
        // 是否使用TextureView播放视频
        val useTextureView = arguments["useTextureView"] as? Boolean ?: true
        // 是否支持多进程
        val supportMultiProcess = arguments["supportMultiProcess"] as? Boolean ?: true
        // 是否使用聚合，默认为false
        val useMediation = arguments["useMediation"] as? Boolean ?: true
        // 主体模式设置，0是正常模式；1是夜间模式；
        val themeStatus = arguments["themeStatus"] as? Int ?: 0

        require(appId.isNotEmpty())

        val config = TTAdConfig.Builder()
            .appId(appId)
            .appName(appName)
            .paid(paid)
            .allowShowNotify(allowShowNotify)
            .useTextureView(useTextureView)
            .debug(debug)
            .supportMultiProcess(supportMultiProcess)
            .customController(getTTCustomController(arguments))
            .useMediation(useMediation)
            .setMediationConfig(
                MediationConfig.Builder().setCustomLocalConfig(loadLocalConfig()).build()
            )
            .themeStatus(themeStatus)
            .build()

        TTAdSdk.init(context, config)
        TTAdSdk.start(this)
    }

    // 函数返回值表示隐私开关开启状态，未重写函数使用默认值
    private fun getTTCustomController(arguments: Map<String, Any?>): TTCustomController {
        return object : TTCustomController() {
            // 是否允许SDK主动使用地理位置信息
            override fun isCanUseLocation(): Boolean {
                val value = arguments["isCanUseLocation"] as? Boolean
                if (value != null) {
                    return value
                }
                return super.isCanUseLocation()
            }

            // 是否允许sdk上报手机app安装列表
            override fun alist(): Boolean {
                val value = arguments["alist"] as? Boolean
                if (value != null) {
                    return value
                }
                return super.alist()
            }

            // 是否允许SDK主动使用手机硬件参数
            override fun isCanUsePhoneState(): Boolean {
                val value = arguments["isCanUsePhoneState"] as? Boolean
                if (value != null) {
                    return value
                }

                return super.isCanUsePhoneState()
            }

            // 当isCanUsePhoneState=false时，可传入IME信息
            override fun getDevImei(): String? {
                val value = arguments["devImei"] as? String
                if (value != null) {
                    return value
                }
                return super.getDevImei()
            }

            // 是否允许SDK主动使用ACCESS_WIFI_STATE权限
            override fun isCanUseWifiState(): Boolean {
                val value = arguments["isCanUseWifiState"] as? Boolean
                if (value != null) {
                    return value
                }
                return super.isCanUseWifiState()
            }

            // 当isCanUseWifiState=false时，可传入Mac地址信息
            override fun getMacAddress(): String? {
                val value = arguments["macAddress"] as? String
                if (value != null) {
                    return value
                }

                return super.getMacAddress()
            }

            // 是否允许SDK主动使用WRITE_EXTERNAL_STORAGE权限
            override fun isCanUseWriteExternal(): Boolean {
                val value = arguments["isCanUseWriteExternal"] as? Boolean
                if (value != null) {
                    return value
                }
                return super.isCanUseWriteExternal()
            }

            // 开发者可以传入OAID
            override fun getDevOaid(): String? {
                val value = arguments["devOaid"] as? String
                if (value != null) {
                    return value
                }
                return super.getDevOaid()
            }

            override fun isCanUseAndroidId(): Boolean {
                val value = arguments["isCanUseAndroidId"] as? Boolean
                if (value != null) {
                    return value
                }
                return super.isCanUseAndroidId()
            }

            // 开发者可以传入android ID
            override fun getAndroidId(): String? {
                val value = arguments["androidId"] as? String
                if (value != null) {
                    return value
                }
                return super.getAndroidId()
            }

            // 是否允许SDK在申明和授权了的情况下使用录音权限
            override fun isCanUsePermissionRecordAudio(): Boolean {
                val value = arguments["isCanUsePermissionRecordAudio"] as? Boolean
                if (value != null) {
                    return value
                }
                return super.isCanUsePermissionRecordAudio()
            }
        }
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