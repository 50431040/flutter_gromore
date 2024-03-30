package net.niuxiaoer.flutter_gromore.manager

import android.app.Activity
import android.util.Log
import com.bytedance.sdk.openadsdk.AdSlot
import com.bytedance.sdk.openadsdk.TTAdNative
import com.bytedance.sdk.openadsdk.TTAdSdk
import com.bytedance.sdk.openadsdk.TTRewardVideoAd
import com.bytedance.sdk.openadsdk.mediation.ad.MediationAdSlot
import io.flutter.plugin.common.MethodChannel

class FlutterGromoreRewardManager(
    private val params: Map<String, Any?>,
    private val activity: Activity,
    private val result: MethodChannel.Result
) :
    TTAdNative.RewardVideoAdListener {

    init {
        loadAd()
    }

    /// 加载激励广告
    private fun loadAd() {
        val adUnitId = params["adUnitId"] as? String
        // 是否静音，默认为true
        val muted = params["muted"] as? Boolean ?: true
        // 音量，默认为0
        val volume = params["volume"] as? Float ?: 0f
        // 播放方向。竖屏：1，横屏：2。默认竖屏
        val orientation = params["orientation"] as? Int ?: 1
        // 是否使用SurfaceView
        val useSurfaceView = params["useSurfaceView"] as? Boolean ?: true

        require(!adUnitId.isNullOrEmpty())

        val adNativeLoader = TTAdSdk.getAdManager().createAdNative(activity)

        val adslot = AdSlot.Builder()
            .setCodeId(adUnitId) // 广告位id
            .setAdCount(1) // 请求的广告数
            .setOrientation(orientation)
            .setMediationAdSlot(
                MediationAdSlot.Builder()
                    .setMuted(muted)
                    .setVolume(volume)
                    .setUseSurfaceView(useSurfaceView)
                    .build()
            ) // 聚合广告请求配置
            .build()

        adNativeLoader.loadRewardVideoAd(adslot, this)
    }

    override fun onError(p0: Int, p1: String?) {
        result.error(p0.toString(), p1, p0.toString())
    }

    override fun onRewardVideoAdLoad(p0: TTRewardVideoAd?) {

    }

    override fun onRewardVideoCached() {

    }

    // 官方建议在onRewardVideoCached回调后，展示广告，提升播放体验
    override fun onRewardVideoCached(ad: TTRewardVideoAd?) {
        ad?.let {
            FlutterGromoreRewardCache.addCacheAd(ad.hashCode(), it)
            result.success(ad.hashCode().toString())
        }
    }
}