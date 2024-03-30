package net.niuxiaoer.flutter_gromore.view

import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.FrameLayout
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.widget.AppCompatImageView
import com.bytedance.sdk.openadsdk.AdSlot
import com.bytedance.sdk.openadsdk.CSJAdError
import com.bytedance.sdk.openadsdk.CSJSplashAd
import com.bytedance.sdk.openadsdk.TTAdNative.CSJSplashAdListener
import com.bytedance.sdk.openadsdk.TTAdSdk
import com.bytedance.sdk.openadsdk.mediation.ad.MediationAdSlot
import net.niuxiaoer.flutter_gromore.R
import net.niuxiaoer.flutter_gromore.event.AdEvent
import net.niuxiaoer.flutter_gromore.event.AdEventHandler
import net.niuxiaoer.flutter_gromore.utils.Utils
import java.util.*
import kotlin.concurrent.schedule

// Activity实例
class FlutterGromoreSplash : AppCompatActivity() {

    private val TAG: String = this::class.java.simpleName

    // 广告容器
    private lateinit var container: FrameLayout
    private lateinit var logoContainer: AppCompatImageView
    private var splashAd: CSJSplashAd? = null

    // activity id
    private lateinit var id: String

    // 广告容器宽高
    private var containerWidth: Int = 0
    private var containerHeight: Int = 0

    // 广告未展示时 自动关闭广告的延时器
    private var closeAdTimer = Timer()

    // 广告已经展示时 自动关闭广告的延时器
    private var skipAdTimer = Timer()

    // 广告已经展示
    private var adShow = false

    // 初始化广告
    private fun initAd() {
        var tmp = intent.getStringExtra("id")
        require(tmp != null)
        id = tmp

        val adUnitId = intent.getStringExtra("adUnitId")
        require(adUnitId != null && adUnitId.isNotEmpty())

        val muted = intent.getBooleanExtra("muted", true)
        val preload = intent.getBooleanExtra("preload", true)
        val volume = intent.getFloatExtra("volume", 1f)
        val isSplashShakeButton = intent.getBooleanExtra("splashShakeButton", true)
        val isBidNotify = intent.getBooleanExtra("bidNotify", false)
        val timeout = intent.getIntExtra("timeout", 3500);
        val useSurfaceView = intent.getBooleanExtra("useSurfaceView", true)

        val adNativeLoader = TTAdSdk.getAdManager().createAdNative(this)

        val adSlot = AdSlot.Builder()
            .setCodeId(adUnitId)
            .setImageAcceptedSize(containerWidth, containerHeight)
            .setMediationAdSlot(
                MediationAdSlot.Builder()
                    .setSplashPreLoad(preload)
                    .setMuted(muted)
                    .setVolume(volume)
                    .setSplashShakeButton(isSplashShakeButton)
                    .setBidNotify(isBidNotify)
                    .setUseSurfaceView(useSurfaceView)
                    .build()
            )
            .build()

        adNativeLoader.loadSplashAd(adSlot, getCSJSplashAdListener(), timeout)

        // 6秒后广告未展示，延时自动关闭
        closeAdTimer.schedule(6000) {
            if (!isFinishing && !adShow) {
                runOnUiThread {
                    Log.d(TAG, "closeAdTimer exec")
                    sendEvent("onAutoClose")
                    finishActivity()
                }
            }
        }
    }

    // 初始化
    private fun init() {
        setContentView(R.layout.splash)
        container = findViewById(R.id.splash_ad_container)
        logoContainer = findViewById(R.id.splash_ad_logo)
        containerWidth = Utils.getScreenWidthInPx(this)
        containerHeight = Utils.getScreenHeightInPx(this)
        // logo显示
        handleLogo()
        // 初始化开屏广告
        initAd()
    }

    // logo的显示与否
    private fun handleLogo() {
        val logo = intent.getStringExtra("logo")

        val id = logo.takeIf {
            logo != null && logo.isNotEmpty()
        }?.let {
            getMipmapId(it)
        }

        if (id != null && id > 0) {
            // 找得到图片资源，设置
            logoContainer.apply {
                visibility = View.VISIBLE
                setImageResource(id)
            }

            containerHeight -= logoContainer.layoutParams.height
        } else {
            logoContainer.visibility = View.GONE
            Log.e(TAG, "Logo 名称不匹配或不在 mipmap 文件夹下，展示全屏")
        }

    }

    /**
     * 获取图片资源的id
     * @param resName 资源名称，不带后缀
     * @return 返回资源id
     */
    private fun getMipmapId(resName: String) =
        resources.getIdentifier(resName, "mipmap", packageName)

    // 发送事件
    private fun sendEvent(msg: String) = AdEventHandler.getInstance().sendEvent(AdEvent(id, msg))

    @Synchronized
    private fun finishActivity() {
        if (isFinishing) {
            return
        }

        finish()
        // 设置退出动画
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out)
    }

    override fun onDestroy() {
        super.onDestroy()
        closeAdTimer.cancel()
        skipAdTimer.cancel()

        splashAd?.mediationManager?.destroy()
        splashAd = null
        Utils.splashResult?.success(true);
        Utils.splashResult = null;
        sendEvent("onAdEnd")
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        init()
    }

    private fun getCSJSplashAdListener(): CSJSplashAdListener {
        return object : CSJSplashAdListener {
            // 加载成功
            override fun onSplashLoadSuccess(ad: CSJSplashAd) {
                splashAd = ad

                if (ad.splashView != null) {
                    Log.d(TAG, "onSplashAdLoadSuccess")
                    sendEvent("onSplashAdLoadSuccess")
                    container.addView(ad.splashView)
                } else {
                    Log.d(TAG, "splashView is null")
                    finishActivity()
                }
            }

            // 加载失败
            override fun onSplashLoadFail(error: CSJAdError) {
                Log.d(TAG, "onSplashAdLoadFail ${error.msg}")
                sendEvent("onSplashAdLoadFail")

                finishActivity()
            }

            // 渲染成功
            override fun onSplashRenderSuccess(ad: CSJSplashAd) {
                Log.d(TAG, "onSplashRenderSuccess")
                sendEvent("onSplashRenderSuccess")
                ad.setSplashAdListener(getSplashAdListener())
            }

            override fun onSplashRenderFail(ad: CSJSplashAd, csjAdError: CSJAdError) {
                Log.d(TAG, "onSplashRenderFail ${csjAdError.msg}")
                sendEvent("onSplashRenderFail")

                finishActivity()
            }
        }
    }

    private fun getSplashAdListener(): CSJSplashAd.SplashAdListener {
        return object : CSJSplashAd.SplashAdListener {

            // 开屏展示
            override fun onSplashAdShow(p0: CSJSplashAd?) {
                adShow = true
                closeAdTimer.cancel()

                Log.d(TAG, "onAdShow")
                sendEvent("onAdShow")

                // 6s后自动跳过广告
                skipAdTimer.schedule(6000) {
                    if (!isFinishing) {
                        runOnUiThread {
                            Log.d(TAG, "skipAdTimer exec")
                            sendEvent("onAutoSkip")
                            finishActivity()
                        }
                    }
                }
            }

            // 开屏点击
            override fun onSplashAdClick(p0: CSJSplashAd?) {
                Log.d(TAG, "onAdClicked")
                sendEvent("onAdClicked")
            }

            // 开屏关闭，有些ADN会调用多次close回调需要开发者特殊处理
            override fun onSplashAdClose(p0: CSJSplashAd?, p1: Int) {
                Log.d(TAG, "onSplashAdClose")
                sendEvent("onSplashAdClose")

                finishActivity()
            }

        }
    }


}