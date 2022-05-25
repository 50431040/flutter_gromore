package net.niuxiaoer.flutter_gromore.view

import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.FrameLayout
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.widget.AppCompatImageView
import com.bytedance.msdk.adapter.util.UIUtils
import com.bytedance.msdk.api.AdError
import com.bytedance.msdk.api.TTAdConstant
import com.bytedance.msdk.api.v2.ad.splash.GMSplashAd
import com.bytedance.msdk.api.v2.ad.splash.GMSplashAdListener
import com.bytedance.msdk.api.v2.ad.splash.GMSplashAdLoadCallback
import com.bytedance.msdk.api.v2.slot.GMAdSlotSplash
import net.niuxiaoer.flutter_gromore.R
import net.niuxiaoer.flutter_gromore.event.AdEvent
import net.niuxiaoer.flutter_gromore.event.AdEventHandler
import net.niuxiaoer.flutter_gromore.utils.Utils

class FlutterGromoreSplash: AppCompatActivity(), GMSplashAdListener, GMSplashAdLoadCallback {

    private val TAG: String = this::class.java.simpleName

    // 广告容器
    private lateinit var container: FrameLayout
    private lateinit var logoContainer: AppCompatImageView
    private var mTTSplashAd: GMSplashAd? = null

    // activity id
    private lateinit var id: String

    // 广告容器宽高
    private var containerWidth: Int = 0
    private var containerHeight: Int = 0

    // 初始化广告
    private fun initAd() {
        id = intent.getStringExtra("id") ?: ""
        val adUnitId = intent.getStringExtra("adUnitId")

        Log.d(TAG, "initAd $id")

        if (adUnitId?.length ?: 0 > 0) {
            mTTSplashAd = GMSplashAd(this, adUnitId)
            mTTSplashAd?.setAdSplashListener(this)

            val muted = intent.getBooleanExtra("muted", false)
            val preload = intent.getBooleanExtra("preload", true)
            val volume = intent.getFloatExtra("volume", 1f)
            val timeout = intent.getIntExtra("timeout", 3000)
            val buttonType = intent.getIntExtra("buttonType", TTAdConstant.SPLASH_BUTTON_TYPE_FULL_SCREEN)
            val downloadType = intent.getIntExtra("downloadType", TTAdConstant.DOWNLOAD_TYPE_POPUP)

            val adSlot = GMAdSlotSplash.Builder()
                    .setImageAdSize(containerWidth, containerHeight)
                    .setSplashPreLoad(preload)
                    .setMuted(muted)
                    .setVolume(volume)
                    .setTimeOut(timeout)
                    .setSplashButtonType(buttonType)
                    .setDownloadType(downloadType)
                    .build()

            mTTSplashAd?.loadAd(adSlot, this)

        }
    }

    // 初始化
    private fun init() {
        setContentView(R.layout.splash)
        container = findViewById(R.id.splash_ad_container)
        logoContainer = findViewById(R.id.splash_ad_logo)
        containerWidth = Utils.getScreenWidthInPx(this)
        containerHeight = Utils.getScreenHeightInPx(this)
        // 隐藏底部菜单
        UIUtils.hideBottomUIMenu(this)
        // 状态栏透明
        Utils.setTranslucent(this)
        // logo显示
        handleLogo()
        // 初始化开屏广告
        initAd()
    }

    // logo的显示与否
    private fun handleLogo() {
        val logo = intent.getStringExtra("logo")

        // 传入了logo参数
        if (logo != null && logo.isNotEmpty()) {
            val id = getMipmapId(logo)

            // 资源存在
            if (id > 0) {
                logoContainer.apply {
                    visibility = View.VISIBLE
                    setImageResource(id)
                }
                containerHeight -= logoContainer.layoutParams.height
            } else {
                logoContainer.visibility = View.GONE
                Log.e(TAG, "Logo 名称不匹配或不在 mipmap 文件夹下，展示全屏")
            }

        } else {
            logoContainer.visibility = View.GONE
        }
    }

    /**
     * 获取图片资源的id
     * @param resName 资源名称，不带后缀
     * @return 返回资源id
     */
    private fun getMipmapId(resName: String): Int {
        return resources.getIdentifier(resName, "mipmap", packageName)
    }

    // 发送事件
    private fun sendEvent(msg: String) {
        AdEventHandler.getInstance().sendEvent(AdEvent(id, msg))
    }

    private fun finishActivity() {
        finish()
        // 设置退出动画
        overridePendingTransition(0, 0)
        // 销毁
        mTTSplashAd?.destroy()
        mTTSplashAd = null

        sendEvent("onAdEnd")
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        init()
    }

    override fun onAdClicked() {
        Log.d(TAG, "onAdClicked")
        sendEvent("onAdClicked")
    }

    override fun onAdShow() {
        Log.d(TAG, "onAdShow")
        sendEvent("onAdShow")
    }

    override fun onAdShowFail(p0: AdError) {
        Log.d(TAG, "onAdShowFail")
        sendEvent("onAdShowFail")
    }

    override fun onAdSkip() {
        Log.d(TAG, "onAdSkip")

        finishActivity()
        sendEvent("onAdSkip")
    }

    override fun onAdDismiss() {
        Log.d(TAG, "onAdDismiss")

        finishActivity()
        sendEvent("onAdDismiss")
    }

    override fun onSplashAdLoadFail(p0: AdError) {
        Log.d(TAG, "onSplashAdLoadFail")

        finishActivity()
        sendEvent("onSplashAdLoadFail")
    }

    override fun onSplashAdLoadSuccess() {
        Log.d(TAG, "onSplashAdLoadSuccess")

        if (!isFinishing) {
            container.removeAllViews()
            mTTSplashAd?.showAd(container)
        } else {
            finishActivity()
        }

        sendEvent("onSplashAdLoadSuccess")
    }

    override fun onAdLoadTimeout() {
        Log.d(TAG, "onAdLoadTimeout")

        finishActivity()
        sendEvent("onAdLoadTimeout")
    }

}