package net.niuxiaoer.flutter_gromore.view

import android.app.Activity
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import com.bytedance.msdk.api.AdSlot
import com.bytedance.msdk.api.v2.GMDislikeCallback
import com.bytedance.msdk.api.v2.ad.nativeAd.GMNativeExpressAdListener
import com.bytedance.msdk.api.v2.ad.nativeAd.GMUnifiedNativeAd
import com.bytedance.msdk.api.v2.slot.GMAdSlotNative
import io.flutter.plugin.platform.PlatformView
import net.niuxiaoer.flutter_gromore.utils.Utils


class FlutterGromoreFeed(activity: Activity): PlatformView, GMNativeExpressAdListener, GMDislikeCallback {

    // 信息流广告容器
    private var container: FrameLayout = FrameLayout(activity)

    private lateinit var mTTAdNative: GMUnifiedNativeAd

    init {
        val params: FrameLayout.LayoutParams = FrameLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT)
        container.layoutParams = params

        // step1:创建GMUnifiedNativeAd对象，传递Context对象和广告位ID即mAdUnitId
        mTTAdNative = GMUnifiedNativeAd(activity, "")


        // 加载feed广告 1为模板，2为原生
        val adSlotNative : GMAdSlotNative = GMAdSlotNative.Builder()
                .setAdStyleType(AdSlot.TYPE_EXPRESS_AD)
                .setImageAdSize(Utils.getScreenWidthInPx(activity), 30)
                .setAdCount(3)
                .build()

//        mTTAdNative.loadAd(adSlotNative, this)
    }

    override fun getView(): View {
        return container
    }

    override fun dispose() {
    }

    override fun onAdClick() {

    }

    override fun onAdShow() {
    }

    override fun onRenderFail(p0: View?, p1: String?, p2: Int) {
    }

    override fun onRenderSuccess(p0: Float, p1: Float) {
    }

    override fun onSelected(p0: Int, p1: String?) {
        // 移除广告
    }

    override fun onCancel() {
    }

    override fun onRefuse() {
    }

    override fun onShow() {
    }
}