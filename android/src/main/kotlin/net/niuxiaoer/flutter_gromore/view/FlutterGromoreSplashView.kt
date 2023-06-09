package net.niuxiaoer.flutter_gromore.view

import android.app.Activity
import android.content.Context
import android.util.Log
import android.view.View
import android.widget.FrameLayout
import com.bytedance.sdk.openadsdk.AdSlot
import com.bytedance.sdk.openadsdk.TTAdNative
import com.bytedance.sdk.openadsdk.TTAdSdk
import com.bytedance.sdk.openadsdk.TTSplashAd
import com.bytedance.sdk.openadsdk.mediation.ad.MediationAdSlot
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformView
import net.niuxiaoer.flutter_gromore.constants.FlutterGromoreConstants
import net.niuxiaoer.flutter_gromore.utils.Utils


class FlutterGromoreSplashView(
        private val context: Context,
        private val activity: Activity,
        viewId: Int,
        private val creationParams: Map<String?, Any?>?,
        binaryMessenger: BinaryMessenger
) :
        FlutterGromoreBase(binaryMessenger, "${FlutterGromoreConstants.splashTypeId}/$viewId"),
        PlatformView, TTAdNative.SplashAdListener, TTSplashAd.AdInteractionListener {

    private val TAG: String = this::class.java.simpleName

    // 开屏广告容器
    private var container: FrameLayout = FrameLayout(context)

    private var splashAd: TTSplashAd? = null

    init {
        initAd()
    }

    override fun initAd() {
        require(creationParams != null)

        val adUnitId = creationParams["adUnitId"] as String
        require(adUnitId.isNotEmpty())

        val adNativeLoader = TTAdSdk.getAdManager().createAdNative(activity)

        // 注意开屏广告view：width >=70%屏幕宽；height >=50%屏幕高，否则会影响计费。
        // 开屏广告可支持的尺寸：图片尺寸传入与展示区域大小保持一致，避免素材变形
        val containerWidth = creationParams["width"] as? Int ?: Utils.getScreenWidthInPx(context)
        val containerHeight = creationParams["height"] as? Int ?: Utils.getScreenHeightInPx(context)
        val muted = creationParams["muted"] as? Boolean ?: false
        val preload = creationParams["preload"] as? Boolean ?: true
        val volume = creationParams["volume"] as? Float ?: 1f
        val isSplashShakeButton = creationParams["splashShakeButton"] as? Boolean ?: true
        val isBidNotify = creationParams["bidNotify"] as? Boolean ?: false

        container.layoutParams = FrameLayout.LayoutParams(containerWidth, containerHeight)

        val adSlot = AdSlot.Builder()
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
    }

    private fun finishSplash() {
        // 销毁
        splashAd?.mediationManager?.destroy()
        splashAd = null

        postMessage("onAdEnd")
    }

    override fun getView(): View {
        return container
    }

    override fun dispose() {
        finishSplash()
    }

    override fun onAdClicked(p0: View?, p1: Int) {
        Log.d(TAG, "onAdClicked")
        postMessage("onAdClicked")
    }

    override fun onAdShow(p0: View?, p1: Int) {
        Log.d(TAG, "onAdShow")
        postMessage("onAdShow")
    }

    override fun onAdSkip() {
        Log.d(TAG, "onAdSkip")

        finishSplash()
        postMessage("onAdSkip")
    }

    override fun onAdTimeOver() {
        Log.d(TAG, "onAdDismiss")

        finishSplash()
        postMessage("onAdDismiss")
    }

    override fun onError(p0: Int, p1: String?) {
        Log.d(TAG, "onSplashAdLoadFail")

        finishSplash()
        postMessage("onSplashAdLoadFail")
    }

    override fun onTimeout() {
        Log.d(TAG, "onAdLoadTimeout")

        finishSplash()
        postMessage("onAdLoadTimeout")
    }

    override fun onSplashAdLoad(ad: TTSplashAd?) {
        Log.d(TAG, "onSplashAdLoadSuccess")
        postMessage("onSplashAdLoadSuccess")

        ad?.let {
            splashAd = it
            it.setSplashInteractionListener(this)

            container.removeAllViews()
            it.splashView?.let {  splashView ->
                container.addView(splashView)
            }
        }
    }

}