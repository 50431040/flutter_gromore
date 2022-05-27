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
import net.niuxiaoer.flutter_gromore.utils.Utils


class FlutterGromoreFeed(private val context: Context, viewId: Int, private val creationParams: Map<String?, Any?>?, binaryMessenger: BinaryMessenger) :
        FlutterGromoreBase(binaryMessenger, "${FlutterGromoreConstants.feedViewTypeId}/$viewId"),
        PlatformView,
        GMNativeExpressAdListener,
        GMNativeAdLoadCallback,
        GMDislikeCallback,
        GMSettingConfigCallback {

    private val TAG: String = this::class.java.simpleName

    // 信息流广告容器
    private var container: FrameLayout = FrameLayout(context)

    private lateinit var mTTAdNative: GMUnifiedNativeAd

    // 广告model
    private var mGMNativeAd: GMNativeAd? = null

    private var layoutParams: FrameLayout.LayoutParams = FrameLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT)

    init {
        container.layoutParams = layoutParams
        loadAdWithCallback()
    }

    // 加载信息流广告，如果没有config配置会等到加载完config配置后才去请求广告
    private fun loadAdWithCallback() {
        if (GMMediationAdSdk.configLoadSuccess()) {
            Log.d(TAG, "loadAdWithCallback - configLoadSuccess")
            initAd()
        } else {
            Log.d(TAG, "loadAdWithCallback - registerConfigCallback")
            GMMediationAdSdk.registerConfigCallback(this)
        }
    }

    override fun initAd() {
        val adUnitId: String
        var count: Int
        val width: Int
        val height: Int
        var adStyleType: Int

        require(creationParams != null)

        creationParams.apply {
            adUnitId = get("adUnitId") as String
            count = get("count") as? Int ?: 3
            // 默认宽度占满
            width = get("width") as? Int ?: Utils.getScreenWidthInPx(context)
            // 0为高度选择自适应参数
            height = get("height") as? Int ?: 0
            // 默认为模板信息流
            adStyleType = get("type") as? Int ?: AdSlot.TYPE_EXPRESS_AD
        }

        require(adUnitId.isNotEmpty())
        require(count > 0)

        // step1:创建GMUnifiedNativeAd对象，传递Context对象和广告位ID即mAdUnitId
        mTTAdNative = GMUnifiedNativeAd(context, adUnitId)

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
        mTTAdNative.destroy()
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

    // 拉取广告成功
    override fun onAdLoaded(p0: MutableList<GMNativeAd>) {

        p0.takeIf {
            p0.isNotEmpty()
        }?.apply {
            Log.d(TAG, "onAdLoaded")

            mGMNativeAd = this.random()
            showAd()
            postMessage("onAdLoaded")
        }
    }

    // 拉取广告失败
    override fun onAdLoadedFail(p0: AdError) {
        Log.d(TAG, "广告加载失败 - ${p0.code} - ${p0.message}")
        postMessage("onAdLoadedFail")
    }

    override fun configLoad() {
        Log.d(TAG, "loadAdWithCallback - configLoad")
        postMessage("configLoad")
        initAd()
    }
}