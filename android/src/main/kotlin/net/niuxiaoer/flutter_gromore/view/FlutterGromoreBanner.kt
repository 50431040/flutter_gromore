package net.niuxiaoer.flutter_gromore.view

import android.app.Activity
import android.content.Context
import android.graphics.Color
import android.util.Log
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import com.bytedance.sdk.openadsdk.*
import com.bytedance.sdk.openadsdk.mediation.ad.IMediationNativeAdInfo
import com.bytedance.sdk.openadsdk.mediation.ad.MediationAdSlot
import com.bytedance.sdk.openadsdk.mediation.ad.MediationNativeToBannerListener
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformView
import net.niuxiaoer.flutter_gromore.constants.FlutterGromoreConstants
import net.niuxiaoer.flutter_gromore.utils.Utils


class FlutterGromoreBanner(
        private val context: Context,
        private val activity: Activity,
        viewId: Int,
        creationParams: Map<String?, Any?>,
        binaryMessenger: BinaryMessenger
) :
        FlutterGromoreBase(binaryMessenger, "${FlutterGromoreConstants.bannerTypeId}/$viewId"),
        PlatformView,
        TTAdDislike.DislikeInteractionCallback, TTNativeExpressAd.ExpressAdInteractionListener, TTAdNative.NativeExpressAdListener {

    private val TAG: String = this::class.java.simpleName

    // 信息流广告容器
    private var container: FrameLayout = FrameLayout(activity)

    // 广告model
    private var bannerAd: TTNativeExpressAd? = null

    private var layoutParams: FrameLayout.LayoutParams = FrameLayout.LayoutParams(
            ViewGroup.LayoutParams.WRAP_CONTENT,
            ViewGroup.LayoutParams.WRAP_CONTENT
    )

    init {
        // 广告位id
        val adUnitId = creationParams["adUnitId"] as String
        // 默认宽度为屏幕宽度
        val width: Int = if (creationParams["width"] == null) {
            Utils.getScreenWidthInPx(context)
        } else {
            Utils.dp2px(context, (creationParams["width"] as String).toFloat())
        }

        // 默认高度为150
        val height = creationParams["height"] as? Int ?: 150
        require(adUnitId.isNotEmpty())

        val adNativeLoader = TTAdSdk.getAdManager().createAdNative(activity)

        val adslot = AdSlot.Builder()
                .setCodeId(adUnitId)
                .setImageAcceptedSize(width, Utils.dp2px(context, height.toFloat()))
                .setAdCount(1)
                .setMediationAdSlot(MediationAdSlot.Builder()
                        .setMediationNativeToBannerListener(object : MediationNativeToBannerListener() {
                            override fun getMediationBannerViewFromNativeAd(p0: IMediationNativeAdInfo?): View? {
                                return null
                            }
                        }).build())
                .build()

        adNativeLoader.loadBannerExpressAd(adslot, this)

        container.layoutParams = layoutParams
        initAd()
    }

    private fun removeAdView() {
        Log.e(TAG, "removeAdView")
        container.removeAllViews()
        bannerAd?.destroy()
        bannerAd = null
    }

    override fun getView(): View {
        return container
    }

    override fun dispose() {
        removeAdView()
    }

    override fun onAdClicked(p0: View?, p1: Int) {
        Log.d(TAG, "onAdClick")
        postMessage("onAdClick")
    }

    override fun onAdShow(p0: View?, p1: Int) {
        Log.d(TAG, "onAdShow")
        postMessage("onAdShow")
    }

    override fun onRenderFail(p0: View?, p1: String?, p2: Int) {
        Log.d(TAG, "onRenderFail - $p2 - $p1")
        postMessage("onRenderFail")
    }

    override fun onRenderSuccess(p0: View?, width: Float, height: Float) {
        Log.d(TAG, "onRenderSuccess")

        val ad = bannerAd?.expressAdView
        ad?.let {
            (it as? ViewGroup)?.removeView(ad)
            container.removeAllViews()
            container.setBackgroundColor(Color.WHITE)
            container.addView(ad, FrameLayout.LayoutParams(
                    ViewGroup.LayoutParams.WRAP_CONTENT,
                    ViewGroup.LayoutParams.WRAP_CONTENT
            ))
        }

        postMessage("onRenderSuccess")
    }


    override fun onCancel() {}

    override fun onShow() {}

    // 用户选择不喜欢原因后，移除广告展示
    override fun onSelected(p0: Int, p1: String?, p2: Boolean) {
        Log.d(TAG, "dislike-onSelected")
        postMessage("onSelected")
        removeAdView()
    }

    override fun initAd() {}

    override fun onError(p0: Int, p1: String?) {
        postMessage("onLoadError")
    }

    override fun onNativeExpressAdLoad(ads: MutableList<TTNativeExpressAd>?) {
        ads?.let {
            val ad = it.first()

            bannerAd = ad
            ad.setDislikeCallback(activity, this)
            ad.setExpressInteractionListener(this)
            ad.render()
        }
    }
}