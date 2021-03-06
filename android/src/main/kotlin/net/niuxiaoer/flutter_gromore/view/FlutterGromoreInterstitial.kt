package net.niuxiaoer.flutter_gromore.view

import android.app.Activity
import android.util.Log
import com.bytedance.msdk.api.AdError
import com.bytedance.msdk.api.reward.RewardItem
import com.bytedance.msdk.api.v2.ad.interstitialFull.GMInterstitialFullAd
import com.bytedance.msdk.api.v2.ad.interstitialFull.GMInterstitialFullAdListener
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import net.niuxiaoer.flutter_gromore.constants.FlutterGromoreConstants
import net.niuxiaoer.flutter_gromore.manager.FlutterGromoreInterstitialCache


class FlutterGromoreInterstitial(private val activity: Activity,
                                 binaryMessenger: BinaryMessenger,
                                 creationParams: Map<String, Any?>,
                                 private val result: MethodChannel.Result) :
        FlutterGromoreBase(binaryMessenger, "${FlutterGromoreConstants.interstitialTypeId}/${creationParams["interstitialId"]}"),
        GMInterstitialFullAdListener {

    private val TAG: String = this::class.java.simpleName

    private var mInterstitialAd: GMInterstitialFullAd? = null

    init {
        mInterstitialAd = FlutterGromoreInterstitialCache.getCacheInterstitialAd((creationParams["interstitialId"] as String).toInt())
        initAd()
    }

    private fun showAd() {
        mInterstitialAd.takeIf {
            it != null && it.isReady
        }?.let {
            // 真正展示
            it.setAdInterstitialFullListener(this)
            it.showAd(activity)
        }
    }

    // 初始化插屏广告
    override fun initAd() {
        showAd()
    }

    private fun destroyAd() {
        mInterstitialAd?.destroy()
        mInterstitialAd = null
    }

    // 广告展示
    override fun onInterstitialFullShow() {
        Log.d(TAG, "onInterstitialShow")
        postMessage("onInterstitialShow")
    }

    // 	show失败回调。如果show时发现无可用广告（比如广告过期或者isReady=false），会触发该回调。 开发者应该在该回调里进行重新请求。
    override fun onInterstitialFullShowFail(p0: AdError) {
        Log.d(TAG, "onInterstitialShowFail -- ${p0.message}")
        postMessage("onInterstitialShowFail")
        result.success(false)
    }

    // 广告被点击
    override fun onInterstitialFullClick() {
        Log.d(TAG, "onInterstitialAdClick")
        postMessage("onInterstitialAdClick")
    }

    // 关闭广告
    override fun onInterstitialFullClosed() {
        Log.d(TAG, "onInterstitialClosed")
        result.success(true)
        postMessage("onInterstitialClosed")
        destroyAd()
    }

    // 视频播放完毕(针对全屏广告)
    override fun onVideoComplete() {
    }

    // 视频播放失败(针对全屏广告)
    override fun onVideoError() {
    }

    // 跳过视频播放(针对全屏广告)
    override fun onSkippedVideo() {
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

    // 激励视频播放完毕，验证是否有效发放奖励的回调，可以通过rewardItem获取服务端验证返回的数据，首先区分是哪个adn，然后获取数据。
    override fun onRewardVerify(p0: RewardItem) {

    }
}