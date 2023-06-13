package net.niuxiaoer.flutter_gromore.view

import android.app.Activity
import android.util.Log
import com.bytedance.sdk.openadsdk.TTFullScreenVideoAd
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import net.niuxiaoer.flutter_gromore.constants.FlutterGromoreConstants
import net.niuxiaoer.flutter_gromore.manager.FlutterGromoreInterstitialCache


class FlutterGromoreInterstitial(private val activity: Activity,
                                 binaryMessenger: BinaryMessenger,
                                 creationParams: Map<String, Any?>,
                                 private val result: MethodChannel.Result) :
        FlutterGromoreBase(binaryMessenger, "${FlutterGromoreConstants.interstitialTypeId}/${creationParams["interstitialId"]}"), TTFullScreenVideoAd.FullScreenVideoAdInteractionListener {

    private val TAG: String = this::class.java.simpleName

    private var mInterstitialAd: TTFullScreenVideoAd? = null
    private var interstitialId: Int = 0

    init {
        interstitialId = (creationParams["interstitialId"] as String).toInt()
        mInterstitialAd = FlutterGromoreInterstitialCache.getCacheInterstitialAd(interstitialId)
        initAd()
    }

    private fun showAd() {
        mInterstitialAd.takeIf {
            it != null && it.mediationManager.isReady
        }?.let {
            // 真正展示
            it.setFullScreenVideoAdInteractionListener(this)
            it.showFullScreenVideoAd(activity)
        }
    }

    // 初始化插屏广告
    override fun initAd() {
        showAd()
    }

    private fun destroyAd() {
        mInterstitialAd?.mediationManager?.destroy()
        mInterstitialAd = null

        FlutterGromoreInterstitialCache.removeCacheInterstitialAd(interstitialId)
    }

    // 广告展示
    override fun onAdShow() {
        Log.d(TAG, "onInterstitialShow")
        postMessage("onInterstitialShow")
    }

    // 广告被点击
    override fun onAdVideoBarClick() {
        Log.d(TAG, "onInterstitialAdClick")
        postMessage("onInterstitialAdClick")
    }

    // 关闭广告
    override fun onAdClose() {
        Log.d(TAG, "onInterstitialClosed")
        result.success(true)
        postMessage("onInterstitialClosed")
        destroyAd()
    }

    // 跳过视频
    override fun onSkippedVideo() {
        Log.d(TAG, "onSkippedVideo")
    }

    // 播放视频完成
    override fun onVideoComplete() {
        Log.d(TAG, "onVideoComplete")
    }
}