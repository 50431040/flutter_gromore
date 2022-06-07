package net.niuxiaoer.flutter_gromore.view

import android.app.Activity
import android.util.Log
import com.bytedance.msdk.api.AdError
import com.bytedance.msdk.api.v2.ad.interstitial.GMInterstitialAd
import com.bytedance.msdk.api.v2.ad.interstitial.GMInterstitialAdListener
import com.bytedance.msdk.api.v2.ad.interstitial.GMInterstitialAdLoadCallback
import com.bytedance.msdk.api.v2.slot.GMAdOptionUtil
import com.bytedance.msdk.api.v2.slot.GMAdSlotInterstitial
import io.flutter.plugin.common.BinaryMessenger
import net.niuxiaoer.flutter_gromore.constants.FlutterGromoreConstants

class FlutterGromoreInterstitial(private val activity: Activity,
                                 binaryMessenger: BinaryMessenger,
                                 private val arguments: Map<String, Any?>) :
        FlutterGromoreBase(binaryMessenger, "${FlutterGromoreConstants.interstitialTypeId}/${arguments["id"]}"),
        GMInterstitialAdLoadCallback,
        GMInterstitialAdListener {

    private val TAG: String = this::class.java.simpleName

    private var mInterstitialAd: GMInterstitialAd? = null

    init {
        initAd()
    }

    // 初始化插屏广告
    override fun initAd() {
        val adUnitId = arguments["adUnitId"] as? String
        val width = arguments["width"] as? Double
        val height = arguments["height"] as? Double

        require(adUnitId != null && adUnitId.isNotEmpty() && width != null && height != null)

        mInterstitialAd = GMInterstitialAd(activity, adUnitId)

        var adSlotInterstitial = GMAdSlotInterstitial.Builder()
                .setGMAdSlotBaiduOption(GMAdOptionUtil.getGMAdSlotBaiduOption().build())
                .setGMAdSlotGDTOption(GMAdOptionUtil.getGMAdSlotGDTOption().build())
                .setImageAdSize(width.toInt(), height.toInt())
                .build()

        mInterstitialAd?.loadAd(adSlotInterstitial, this)
    }

    fun destroyAd() {
        mInterstitialAd?.destroy()
        mInterstitialAd = null
    }

    override fun onInterstitialLoadFail(error: AdError) {
        Log.d(TAG, "onInterstitialLoadFail - ${error.code} - ${error.message}")
        postMessage("onInterstitialLoadFail")
        destroyAd()
    }

    override fun onInterstitialLoad() {
        Log.d(TAG, "onInterstitialLoad")
        postMessage("onInterstitialLoad")

        mInterstitialAd.takeIf {
            it != null && it.isReady
        }?.let {
            // 真正展示
            it.setAdInterstitialListener(this)
            it.showAd(activity)
        }

    }

    // 广告展示
    override fun onInterstitialShow() {
        Log.d(TAG, "onInterstitialShow")
        postMessage("onInterstitialShow")
    }

    // 如果show时发现无可用广告（比如广告过期或者isReady=false），会触发该回调。 开发者应该在该回调里进行重新请求。
    override fun onInterstitialShowFail(p0: AdError) {
        Log.d(TAG, "onInterstitialShowFail -- ${p0.message}")
        postMessage("onInterstitialShowFail")
    }

    // 广告被点击
    override fun onInterstitialAdClick() {
        Log.d(TAG, "onInterstitialAdClick")
        postMessage("onInterstitialAdClick")
    }

    // 广告关闭
    override fun onInterstitialClosed() {
        Log.d(TAG, "onInterstitialClosed")
        postMessage("onInterstitialClosed")
        destroyAd()
    }

    // 当广告打开浮层时调用，如打开内置浏览器、内容展示浮层，一般发生在点击之后,常常在onAdLeftApplication之前调用，并非百分百回调，优量汇sdk支持，穿山甲SDK、baidu SDK、mintegral SDK、admob sdk暂时不支持
    override fun onAdOpened() {
        Log.d(TAG, "onAdOpened")
        postMessage("onAdOpened")
    }

    // 此方法会在用户点击打开其他应用（例如 Google Play）时于 onAdOpened() 之后调用，从而在后台运行当前应用。并非百分百回调，优量汇sdk和admob sdk支持，穿山甲SDK、baidu SDK、mintegral SDK暂时不支持
    override fun onAdLeftApplication() {
        Log.d(TAG, "onAdLeftApplication")
        postMessage("onAdLeftApplication")
    }
}