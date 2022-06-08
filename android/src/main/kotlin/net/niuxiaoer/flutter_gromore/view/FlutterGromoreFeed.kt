package net.niuxiaoer.flutter_gromore.view

import android.app.Activity
import android.content.Context
import android.util.Log
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import com.bytedance.msdk.api.AdError
import com.bytedance.msdk.api.AdSlot
import com.bytedance.msdk.api.v2.GMDislikeCallback
import com.bytedance.msdk.api.v2.GMMediationAdSdk
import com.bytedance.msdk.api.v2.GMSettingConfigCallback
import com.bytedance.msdk.api.v2.ad.nativeAd.GMNativeAd
import com.bytedance.msdk.api.v2.ad.nativeAd.GMNativeAdLoadCallback
import com.bytedance.msdk.api.v2.ad.nativeAd.GMNativeExpressAdListener
import com.bytedance.msdk.api.v2.ad.nativeAd.GMUnifiedNativeAd
import com.bytedance.msdk.api.v2.slot.GMAdOptionUtil
import com.bytedance.msdk.api.v2.slot.GMAdSlotNative
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import net.niuxiaoer.flutter_gromore.constants.FlutterGromoreConstants
import net.niuxiaoer.flutter_gromore.manager.FlutterGromoreFeedCache
import net.niuxiaoer.flutter_gromore.manager.FlutterGromoreFeedManager
import net.niuxiaoer.flutter_gromore.utils.Utils


class FlutterGromoreFeed(private val context: Context, viewId: Int, creationParams: Map<String?, Any?>, binaryMessenger: BinaryMessenger) :
        FlutterGromoreBase(binaryMessenger, "${FlutterGromoreConstants.feedViewTypeId}/$viewId"),
        PlatformView,
        GMNativeExpressAdListener,
        GMDislikeCallback {

    private val TAG: String = this::class.java.simpleName

    // 信息流广告容器
    private var container: FrameLayout = FrameLayout(context)

    // 广告model
    private var mGMNativeAd: GMNativeAd? = null

    private var layoutParams: FrameLayout.LayoutParams = FrameLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT)

    init {
        container.layoutParams = layoutParams
        // 从缓存中取广告
        mGMNativeAd = FlutterGromoreFeedCache.getCacheFeedAd(creationParams["feedId"] as Int)
        initAd()
    }

    private fun showAd() {

        mGMNativeAd?.takeIf {
            it.isReady
        }?.let {

            // 是否有不喜欢按钮
            if (it.hasDislike()) {
                it.setDislikeCallback(context as Activity?, this)
            }

            it.setNativeAdListener(this)
            it.render()
        }
    }

    private fun removeAdView() {
        container.removeAllViews()
        mGMNativeAd?.destroy()
        mGMNativeAd = null
    }

    override fun getView(): View {
        return container
    }

    override fun dispose() {
    }

    override fun onAdClick() {
        Log.d(TAG, "onAdClick")
        postMessage("onAdClick")
    }

    override fun onAdShow() {
        Log.d(TAG, "onAdShow")
        postMessage("onAdShow")
    }

    override fun onRenderFail(p0: View?, p1: String?, p2: Int) {
        Log.d(TAG, "onRenderFail - $p2 - $p1")
        postMessage("onRenderFail")
    }

    // 必须在onRenderSuccess进行广告展示，否则会导致广告无法展示
    override fun onRenderSuccess(width: Float, height: Float) {
        Log.d(TAG, "onRenderSuccess - $width - $height")

        val ad: View? = mGMNativeAd?.expressView

        ad?.parent?.let {
            (it as? ViewGroup)?.removeView(ad)
        }

        if (ad != null) {
            container.removeAllViews()
            container.addView(ad, layoutParams)
        }

        ad?.apply {
            // 计算渲染后的高度
            measure(View.MeasureSpec.UNSPECIFIED, View.MeasureSpec.UNSPECIFIED)
            Log.d(TAG, "measuredHeight - $measuredHeight")
        }?.takeIf {
            it.measuredHeight > 0
        }?.let {
            postMessage("onRenderSuccess", mapOf("height" to it.measuredHeight / Utils.getDensity(context)))
        }

    }

    // 用户选择不喜欢原因后，移除广告展示
    override fun onSelected(p0: Int, p1: String?) {
        Log.d(TAG, "dislike-onSelected")
        postMessage("onSelected")
        removeAdView()
    }

    override fun onCancel() {
        Log.d(TAG, "dislike-onCancel")
        postMessage("onCancel")
    }

    override fun onRefuse() {
        Log.d(TAG, "dislike-onRefuse")
        postMessage("onRefuse")
    }

    override fun onShow() {
        Log.d(TAG, "dislike-onShow")
        postMessage("onShow")
    }

    override fun initAd() {
        showAd()
    }
}