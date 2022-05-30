package net.niuxiaoer.flutter_gromore.view

import android.app.Activity
import android.content.Context
import android.util.Log
import android.view.View
import android.widget.FrameLayout
import com.bytedance.msdk.api.AdError
import com.bytedance.msdk.api.TTAdConstant
import com.bytedance.msdk.api.v2.ad.splash.GMSplashAd
import com.bytedance.msdk.api.v2.ad.splash.GMSplashAdListener
import com.bytedance.msdk.api.v2.ad.splash.GMSplashAdLoadCallback
import com.bytedance.msdk.api.v2.slot.GMAdSlotSplash
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformView
import net.niuxiaoer.flutter_gromore.constants.FlutterGromoreConstants
import net.niuxiaoer.flutter_gromore.utils.Utils


class FlutterGromoreSplashView(private val context: Context, viewId: Int, private val creationParams: Map<String?, Any?>?, binaryMessenger: BinaryMessenger) :
        FlutterGromoreBase(binaryMessenger, "${FlutterGromoreConstants.splashTypeId}/$viewId"),
        PlatformView,
        GMSplashAdListener,
        GMSplashAdLoadCallback {

    private val TAG: String = this::class.java.simpleName

    // 开屏广告容器
    private var container: FrameLayout = FrameLayout(context)

    private var mTTSplashAd: GMSplashAd? = null

    init {
        initAd()
    }

    override fun initAd() {
        require(creationParams != null)

        val adUnitId = creationParams["adUnitId"] as String
        require(adUnitId.isNotEmpty())

        mTTSplashAd = GMSplashAd(context as Activity, adUnitId)
        mTTSplashAd?.setAdSplashListener(this)

        // 注意开屏广告view：width >=70%屏幕宽；height >=50%屏幕高，否则会影响计费。
        // 开屏广告可支持的尺寸：图片尺寸传入与展示区域大小保持一致，避免素材变形
        val containerWidth = creationParams["width"] as? Int ?: Utils.getScreenWidthInPx(context)
        val containerHeight = creationParams["height"] as? Int ?: Utils.getScreenHeightInPx(context)
        val muted = creationParams["muted"] as? Boolean ?: false
        val preload = creationParams["preload"] as? Boolean ?: true
        val volume = creationParams["volume"] as? Float ?: 1f
        val timeout = creationParams["timeout"] as? Int ?: 3000
        val buttonType = creationParams["buttonType"] as? Int ?: TTAdConstant.SPLASH_BUTTON_TYPE_FULL_SCREEN
        val downloadType = creationParams["downloadType"] as? Int ?: TTAdConstant.DOWNLOAD_TYPE_POPUP

        container.layoutParams = FrameLayout.LayoutParams(containerWidth, containerHeight)

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

    private fun finishSplash() {
        // 销毁
        mTTSplashAd?.destroy()
        mTTSplashAd = null

        postMessage("onAdEnd")
    }

    override fun getView(): View {
        return container
    }

    override fun dispose() {
        finishSplash()
    }

    override fun onAdClicked() {
        Log.d(TAG, "onAdClicked")
        postMessage("onAdClicked")
    }

    override fun onAdShow() {
        Log.d(TAG, "onAdShow")
        postMessage("onAdShow")
    }

    override fun onAdShowFail(p0: AdError) {
        Log.d(TAG, "onAdShowFail")

        finishSplash()
        postMessage("onAdShowFail")
    }

    override fun onAdSkip() {
        Log.d(TAG, "onAdSkip")

        finishSplash()
        postMessage("onAdSkip")
    }

    override fun onAdDismiss() {
        Log.d(TAG, "onAdDismiss")

        finishSplash()
        postMessage("onAdDismiss")
    }

    override fun onSplashAdLoadFail(p0: AdError) {
        Log.d(TAG, "onSplashAdLoadFail")

        finishSplash()
        postMessage("onSplashAdLoadFail")
    }

    override fun onSplashAdLoadSuccess() {
        Log.d(TAG, "onSplashAdLoadSuccess")

        container.removeAllViews()
        mTTSplashAd?.showAd(container)

        postMessage("onSplashAdLoadSuccess")
    }

    override fun onAdLoadTimeout() {
        Log.d(TAG, "onAdLoadTimeout")

        finishSplash()
        postMessage("onAdLoadTimeout")
    }

}