package net.niuxiaoer.flutter_gromore.manager

import android.app.Activity
import android.content.Context
import android.view.View
import com.bytedance.sdk.openadsdk.*
import com.bytedance.sdk.openadsdk.mediation.ad.IMediationNativeAdInfo
import com.bytedance.sdk.openadsdk.mediation.ad.MediationAdSlot
import com.bytedance.sdk.openadsdk.mediation.ad.MediationNativeToBannerListener
import io.flutter.plugin.common.MethodChannel
import net.niuxiaoer.flutter_gromore.utils.Utils

class FlutterGromoreBannerManager(private val params: Map<String, Any?>,
                                  private val context: Context,
                                  private val activity: Activity,
                                  private val result: MethodChannel.Result) : TTAdNative.NativeExpressAdListener {

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

        require(adUnitId.isNotEmpty())
        require(count > 0)

        val adNativeLoader = TTAdSdk.getAdManager().createAdNative(activity)

        val adslot = AdSlot.Builder()
                .setCodeId(adUnitId)
                .setImageAcceptedSize(width, height)
                .setAdCount(count)
                .setMediationAdSlot(MediationAdSlot.Builder()
                        .setMediationNativeToBannerListener(object : MediationNativeToBannerListener() {
                            override fun getMediationBannerViewFromNativeAd(p0: IMediationNativeAdInfo?): View? {
                                return null
                            }
                        }).build())
                .build()

        adNativeLoader.loadBannerExpressAd(adslot, this)
    }

    // banner广告加载失败
    override fun onError(p0: Int, p1: String?) {
        result.error(p0.toString(), p1, p1)
    }

    // banner广告加载成功
    override fun onNativeExpressAdLoad(ads: MutableList<TTNativeExpressAd>?) {
        val feedIdList: MutableList<String> = ArrayList()
        val adUnitId = params["adUnitId"] as String

        ads?.forEach {
            val id = "${adUnitId}_${it.hashCode()}"
            feedIdList.add(id)
            FlutterGromoreBannerCache.addCacheBannerAd(id, it)
        }

        result.success(feedIdList)
    }
}