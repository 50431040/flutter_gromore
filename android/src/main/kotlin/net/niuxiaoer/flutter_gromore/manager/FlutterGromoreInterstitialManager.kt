package net.niuxiaoer.flutter_gromore.manager

import android.app.Activity
import android.util.Log
import com.bytedance.sdk.openadsdk.*
import com.bytedance.sdk.openadsdk.mediation.ad.MediationAdSlot
import io.flutter.plugin.common.MethodChannel

class FlutterGromoreInterstitialManager(
    private val params: Map<String, Any?>,
    private val activity: Activity,
    private val result: MethodChannel.Result
) : TTAdNative.FullScreenVideoAdListener {

    init {
        loadAd()
    }

    private fun loadAd() {
        val adUnitId = params["adUnitId"] as? String
        // 默认为竖
        val orientation = params["orientation"] as? Int ?: TTAdConstant.VERTICAL
        // 静音
        val muted = params["muted"] as? Boolean ?: true
        // 是否使用SurfaceView
        val useSurfaceView = params["useSurfaceView"] as? Boolean ?: true

        require(adUnitId != null && adUnitId.isNotEmpty())

        val adNativeLoader =
            TTAdSdk.getAdManager().createAdNative(activity)
        val adslot = AdSlot.Builder()
            .setCodeId(adUnitId) // 广告位id
            .setAdCount(1) // 请求的广告数
            .setOrientation(orientation)
            .setMediationAdSlot(
                MediationAdSlot.Builder()
                    .setMuted(muted)
                    .setUseSurfaceView(useSurfaceView)
                    .build()
            ) // 聚合广告请求配置
            .build()

        adNativeLoader.loadFullScreenVideoAd(adslot, this)
    }

    override fun onError(p0: Int, p1: String?) {
        Log.d("InterstitialManager", "onInterstitialLoadFail - $p0 - $p1")
        result.error(p0.toString(), p1, p1)
    }

    override fun onFullScreenVideoAdLoad(ad: TTFullScreenVideoAd?) {
        ad?.let {
            FlutterGromoreInterstitialCache.addCacheInterstitialAd(ad.hashCode(), it)
            result.success(ad.hashCode().toString())
        }
    }

    override fun onFullScreenVideoCached() {
    }

    override fun onFullScreenVideoCached(p0: TTFullScreenVideoAd?) {
    }
}