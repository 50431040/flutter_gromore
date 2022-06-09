package net.niuxiaoer.flutter_gromore.manager

import android.content.Context
import android.util.Log
import com.bytedance.msdk.api.AdError
import com.bytedance.msdk.api.AdSlot
import com.bytedance.msdk.api.v2.GMMediationAdSdk
import com.bytedance.msdk.api.v2.GMSettingConfigCallback
import com.bytedance.msdk.api.v2.ad.nativeAd.GMNativeAd
import com.bytedance.msdk.api.v2.ad.nativeAd.GMNativeAdLoadCallback
import com.bytedance.msdk.api.v2.ad.nativeAd.GMUnifiedNativeAd
import com.bytedance.msdk.api.v2.slot.GMAdOptionUtil
import com.bytedance.msdk.api.v2.slot.GMAdSlotNative
import io.flutter.plugin.common.MethodChannel
import net.niuxiaoer.flutter_gromore.utils.Utils

class FlutterGromoreFeedManager(private val params: Map<String, Any?>,
                                private val context: Context,
                                private val result: MethodChannel.Result):
        GMNativeAdLoadCallback,
        GMSettingConfigCallback {

    init {
        loadAdWithCallback()
    }

    /// 加载信息流广告，如果没有config配置会等到加载完config配置后才去请求广告
    private fun loadAdWithCallback() {
        if (GMMediationAdSdk.configLoadSuccess()) {
            loadAd()
        } else {
            GMMediationAdSdk.registerConfigCallback(this)
        }
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
        // 默认为模板信息流
        var adStyleType = params["type"] as? Int ?: AdSlot.TYPE_EXPRESS_AD

        require(adUnitId.isNotEmpty())
        require(count > 0)

        // step1:创建GMUnifiedNativeAd对象，传递Context对象和广告位ID即mAdUnitId
        val mTTAdNative = GMUnifiedNativeAd(context, adUnitId)

        // 加载feed广告 1为模板，2为原生
        GMAdSlotNative.Builder()
                .setAdStyleType(adStyleType)
                .setGMAdSlotGDTOption(GMAdOptionUtil.getGMAdSlotGDTOption().build())
                .setGMAdSlotBaiduOption(GMAdOptionUtil.getGMAdSlotBaiduOption().build())
                // 1:如果是信息流自渲染广告，设置广告图片期望的图片宽高 ，不能为0
                // 2:如果是信息流模板广告，宽度设置为希望的宽度，高度设置为0(0为高度选择自适应参数)
                .setImageAdSize(width, height)
                .setAdCount(count)
                .build()
                .let {
                    mTTAdNative.loadAd(it, this)
                }
    }

    /// 信息流广告加载成功
    override fun onAdLoaded(p0: MutableList<GMNativeAd>) {
        var feedIdList: MutableList<String> = ArrayList()

        p0.forEach {
            val id: Int = it.hashCode()
            feedIdList.add(id.toString())
            FlutterGromoreFeedCache.addCacheFeedAd(id, it)
        }

        result.success(feedIdList)
    }

    /// 信息流广告加载失败
    override fun onAdLoadedFail(p0: AdError) {
        result.error(p0.code.toString(), p0.message, p0.toString())
    }

    override fun configLoad() {
        loadAd()
    }
}