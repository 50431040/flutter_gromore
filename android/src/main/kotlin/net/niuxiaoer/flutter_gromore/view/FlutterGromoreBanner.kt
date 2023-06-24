package net.niuxiaoer.flutter_gromore.view

import android.app.Activity
import android.content.Context
import android.graphics.Color
import android.util.Log
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import com.bytedance.sdk.openadsdk.TTAdDislike
import com.bytedance.sdk.openadsdk.TTNativeExpressAd
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformView
import net.niuxiaoer.flutter_gromore.constants.FlutterGromoreConstants
import net.niuxiaoer.flutter_gromore.manager.FlutterGromoreBannerCache
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
        TTAdDislike.DislikeInteractionCallback, TTNativeExpressAd.ExpressAdInteractionListener {

    private val TAG: String = this::class.java.simpleName

    // 信息流广告容器
    private var container: FrameLayout = FrameLayout(activity)

    // 广告model
    private var bannerAd: TTNativeExpressAd? = null

    private var layoutParams: FrameLayout.LayoutParams = FrameLayout.LayoutParams(
            ViewGroup.LayoutParams.WRAP_CONTENT,
            ViewGroup.LayoutParams.WRAP_CONTENT
    )

    private val cachedAdId: String

    init {
        container.layoutParams = layoutParams
        cachedAdId = creationParams["bannerId"] as String
        // 从缓存中取广告
        bannerAd =
                FlutterGromoreBannerCache.getCacheBannerAd(cachedAdId)
        initAd()
    }

    private fun showAd() {

        bannerAd?.let {
            if (it.mediationManager.hasDislike()) {
                it.setDislikeCallback(activity, this)
            }
            it.setExpressInteractionListener(this)
            it.render()
        }
    }

    private fun removeAdView() {
        Log.e(TAG, "removeAdView")
        container.removeAllViews()
        bannerAd?.destroy()
        bannerAd = null
        FlutterGromoreBannerCache.removeCacheBannerAd(cachedAdId)
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
        Log.d(TAG, "onRenderSuccess - $width - $height - ${p0?.measuredHeight}")

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

        ad?.apply {
            // 计算渲染后的高度
            measure(View.MeasureSpec.makeMeasureSpec(
                    0,
                    View.MeasureSpec.UNSPECIFIED
            ),
                    View.MeasureSpec.makeMeasureSpec(
                            0,
                            View.MeasureSpec.UNSPECIFIED)
            )
            Log.d(TAG, "measuredHeight - $measuredHeight")
        }?.takeIf {
            it.measuredHeight > 0
        }?.let {
            postMessage(
                    "onRenderSuccess",
                    mapOf("height" to it.measuredHeight / Utils.getDensity(context))
            )
        }
    }


    override fun onCancel() {
        Log.d(TAG, "dislike-onCancel")
        postMessage("onCancel")
    }

    override fun onShow() {
        Log.d(TAG, "dislike-onShow")
        postMessage("onShow")
    }

    // 用户选择不喜欢原因后，移除广告展示
    override fun onSelected(p0: Int, p1: String?, p2: Boolean) {
        Log.d(TAG, "dislike-onSelected")
        postMessage("onSelected")
        removeAdView()
    }

    override fun initAd() {
        showAd()
    }
}