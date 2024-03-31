package net.niuxiaoer.flutter_gromore.manager

import android.content.Context
import com.bytedance.sdk.openadsdk.AdSlot
import com.bytedance.sdk.openadsdk.TTAdNative
import com.bytedance.sdk.openadsdk.TTAdSdk
import com.bytedance.sdk.openadsdk.TTFeedAd
import com.bytedance.sdk.openadsdk.mediation.ad.MediationAdSlot
import io.flutter.plugin.common.MethodChannel
import net.niuxiaoer.flutter_gromore.utils.Utils

class FlutterGromoreFeedManager(
    private val params: Map<String, Any?>,
    private val context: Context,
    private val result: MethodChannel.Result
) :
    TTAdNative.FeedAdListener {

    init {
        loadAd()
    }

    /// 加载信息流广告
    fun loadAd() {

        // 广告位id
        val adUnitId = params["adUnitId"] as String
        // 加载数量
        var count = params["count"] as? Int ?: 3
        // 默认宽度占满
        val width = params["width"] as? Int ?: Utils.getScreenWidthInPx(context)
        // 0为高度选择自适应参数
        val height = params["height"] as? Int ?: 0
        // 是否使用SurfaceView
        val useSurfaceView = params["useSurfaceView"] as? Boolean ?: true

        require(adUnitId.isNotEmpty())
        require(count > 0)

        val adNativeLoader = TTAdSdk.getAdManager().createAdNative(context)

        val adslot = AdSlot.Builder()
            .setCodeId(adUnitId)
            .setImageAcceptedSize(width, Utils.dp2px(context, height.toFloat()))
            .setAdCount(count)
            .setMediationAdSlot(MediationAdSlot.Builder().setUseSurfaceView(useSurfaceView).build())
            .build()

        adNativeLoader.loadFeedAd(adslot, this)
    }

    // 信息流广告加载失败
    override fun onError(p0: Int, p1: String?) {
        result.error(p0.toString(), p1, p1)
    }

    // 信息流广告加载成功
    override fun onFeedAdLoad(ad: MutableList<TTFeedAd>?) {
        val feedIdList: MutableList<String> = ArrayList()
        val adUnitId = params["adUnitId"] as String

        ad?.forEach {
            val id = "${adUnitId}_${it.hashCode()}"
            feedIdList.add(id)
            FlutterGromoreFeedCache.addCacheFeedAd(id, it)
        }

        result.success(feedIdList)
    }
}