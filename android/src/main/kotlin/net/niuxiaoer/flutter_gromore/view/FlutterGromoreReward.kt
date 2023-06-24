package net.niuxiaoer.flutter_gromore.view

import android.app.Activity
import android.os.Bundle
import android.util.Log
import com.bytedance.sdk.openadsdk.TTRewardVideoAd
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import net.niuxiaoer.flutter_gromore.constants.FlutterGromoreConstants
import net.niuxiaoer.flutter_gromore.manager.FlutterGromoreRewardCache

class FlutterGromoreReward(
        private val activity: Activity,
        messenger: BinaryMessenger,
        creationParams: Map<String, Any?>,
        private val result: MethodChannel.Result) :
        FlutterGromoreBase(messenger, "${FlutterGromoreConstants.rewardTypeId}/${creationParams["rewardId"]}"),
        TTRewardVideoAd.RewardAdInteractionListener {

    private val TAG: String = this::class.java.simpleName

    private var mttRewardAd: TTRewardVideoAd? = null
    private var rewardId: Int = 0

    init {
        rewardId = (creationParams["rewardId"] as String).toInt()
        mttRewardAd = FlutterGromoreRewardCache.getCacheAd(rewardId)

        initAd()
    }

    override fun initAd() {
        mttRewardAd?.takeIf {
            it.mediationManager.isReady
        }?.let {
            // 真正展示
            it.setRewardAdInteractionListener(this)
            it.showRewardVideoAd(activity)
        }
    }

    private fun destroyAd() {
        mttRewardAd?.mediationManager?.destroy()
        mttRewardAd = null

        FlutterGromoreRewardCache.removeCacheAd(rewardId)
    }

    override fun onAdShow() {
        Log.d(TAG, "onAdShow")
        postMessage("onAdShow")
    }

    // 广告的下载bar点击回调，非所有广告商的广告都会触发
    override fun onAdVideoBarClick() {
        Log.d(TAG, "onAdVideoBarClick")
        postMessage("onAdVideoBarClick")
    }

    // 广告关闭的回调
    override fun onAdClose() {
        Log.d(TAG, "onAdClose")
        postMessage("onAdClose")
        result.success(true)
        destroyAd()
    }

    // 视频播放完毕的回调，非所有广告商的广告都会触发
    override fun onVideoComplete() {
        Log.d(TAG, "onVideoComplete")
        postMessage("onVideoComplete")
    }

    // 视频播放失败的回调
    override fun onVideoError() {
        Log.d(TAG, "onVideoError")
        postMessage("onVideoError")
        result.error("0", "视频播放失败", "视频播放失败")
    }

    // 聚合不支持、激励视频播放完毕，验证是否有效发放奖励的回调
    override fun onRewardVerify(p0: Boolean, p1: Int, p2: String?, p3: Int, p4: String?) {
        Log.d(TAG, "onRewardVerify")
        postMessage("onRewardVerify", mapOf("verify" to p0))
    }

    // 激励视频播放完毕，验证是否有效发放奖励的回调
    override fun onRewardArrived(p0: Boolean, p1: Int, p2: Bundle?) {
        Log.d(TAG, "onRewardVerify")
        postMessage("onRewardVerify", mapOf("verify" to p0))
    }

    // 跳过广告
    override fun onSkippedVideo() {
        Log.d(TAG, "onSkippedVideo")
        postMessage("onSkippedVideo")
    }
}