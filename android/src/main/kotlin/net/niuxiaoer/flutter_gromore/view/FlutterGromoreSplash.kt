package net.niuxiaoer.flutter_gromore.view

import android.os.Bundle
import android.util.Log
import android.view.MotionEvent
import android.view.View
import android.widget.FrameLayout
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.widget.AppCompatImageView
import com.bytedance.sdk.openadsdk.AdSlot
import com.bytedance.sdk.openadsdk.TTAdNative
import com.bytedance.sdk.openadsdk.TTAdSdk
import com.bytedance.sdk.openadsdk.TTSplashAd
import com.bytedance.sdk.openadsdk.mediation.ad.MediationAdSlot
import net.niuxiaoer.flutter_gromore.R
import net.niuxiaoer.flutter_gromore.event.AdEvent
import net.niuxiaoer.flutter_gromore.event.AdEventHandler
import net.niuxiaoer.flutter_gromore.utils.Utils
import java.util.*
import kotlin.concurrent.schedule

// Activity实例
class FlutterGromoreSplash : AppCompatActivity(), TTAdNative.SplashAdListener, TTSplashAd.AdInteractionListener {

    private val TAG: String = this::class.java.simpleName

    // 广告容器
    private lateinit var container: FrameLayout
    private lateinit var logoContainer: AppCompatImageView
    private var splashAd: TTSplashAd? = null

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

        val adNativeLoader = TTAdSdk.getAdManager().createAdNative(this)

        val adSlot = AdSlot.Builder()
                .setCodeId(adUnitId)
                .setImageAcceptedSize(containerWidth, containerHeight)
                .setMediationAdSlot(MediationAdSlot.Builder()
                        .setSplashPreLoad(preload)
                        .setMuted(muted)
                        .setVolume(volume)
                        .setSplashShakeButton(isSplashShakeButton)
                        .setBidNotify(isBidNotify)
                        .build())
                .build()

        adNativeLoader.loadSplashAd(adSlot, this)

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

    override fun onAdClicked(p0: View?, p1: Int) {
        Log.d(TAG, "onAdClicked")
        sendEvent("onAdClicked")
    }

    override fun onAdShow(p0: View?, p1: Int) {
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

    override fun onAdSkip() {
        Log.d(TAG, "onAdSkip")
        sendEvent("onAdSkip")

        finishActivity()
    }

    override fun onAdTimeOver() {
        Log.d(TAG, "onAdDismiss")
        sendEvent("onAdDismiss")

        finishActivity()
    }

    override fun onError(p0: Int, p1: String?) {
        Log.d(TAG, "onSplashAdLoadFail")
        sendEvent("onSplashAdLoadFail")

        finishActivity()
    }

    override fun onTimeout() {
        Log.d(TAG, "onAdLoadTimeout")
        sendEvent("onAdLoadTimeout")

        finishActivity()
    }

    override fun onSplashAdLoad(ad: TTSplashAd?) {
        Log.d(TAG, "onSplashAdLoadSuccess")
        sendEvent("onSplashAdLoadSuccess")

        if (ad != null) {
            splashAd = ad
            ad.setSplashInteractionListener(this)

            if (ad.splashView != null) {
                container.addView(ad.splashView)
            } else {
                Log.d(TAG, "splashView is null")
                finishActivity()
            }
        } else {
            Log.d(TAG, "ad is null")
            finishActivity()
        }
    }

}