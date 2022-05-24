package net.niuxiaoer.flutter_gromore.view

import android.app.Activity
import android.content.Context
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.FrameLayout
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.widget.AppCompatImageView
import com.bytedance.msdk.adapter.TTAdConstant
import com.bytedance.msdk.api.AdError
import com.bytedance.msdk.api.v2.ad.splash.GMSplashAd
import com.bytedance.msdk.api.v2.ad.splash.GMSplashAdListener
import com.bytedance.msdk.api.v2.ad.splash.GMSplashAdLoadCallback
import com.bytedance.msdk.api.v2.slot.GMAdSlotSplash
import net.niuxiaoer.flutter_gromore.R

class FlutterGromoreSplash: AppCompatActivity(), GMSplashAdListener, GMSplashAdLoadCallback {

    private val TAG: String = this::class.java.simpleName

    private lateinit var container: FrameLayout
    private lateinit var logo: AppCompatImageView
    private lateinit var mTTSplashAd: GMSplashAd

    init {
        val adUnitId = intent.getStringExtra("adUnitId") as? String

        if (adUnitId != null) {
            mTTSplashAd = GMSplashAd(this, adUnitId)
            mTTSplashAd.setAdSplashListener(this)

            val muted = intent.getBooleanExtra("muted", false)
            val preload = intent.getBooleanExtra("preload", true)
            val volume = intent.getFloatExtra("volume", 1f)
            val timeout = intent.getIntExtra("timeout", 3000)

            val adSlot = GMAdSlotSplash.Builder()
//                    .setImageAdSize()
                    .setSplashPreLoad(preload)
                    .setMuted(muted)
                    .setVolume(volume)
                    .setTimeOut(timeout)
//                    .setSplashButtonType()
//                    .setDownloadType()
                    .build()

//            mTTSplashAd.loadAd(adSlot, this)

        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        initView()
    }

    private fun initView() {
        setContentView(R.layout.splash)
        container = findViewById(R.id.splash_ad_container)
        logo = findViewById(R.id.splash_ad_logo)
    }

    override fun onAdClicked() {
        Log.d(TAG, "onAdClicked")
    }

    override fun onAdShow() {
        Log.d(TAG, "onAdShow")
    }

    override fun onAdShowFail(p0: AdError) {
        Log.d(TAG, "onAdShowFail")
    }

    override fun onAdSkip() {
        Log.d(TAG, "onAdSkip")
    }

    override fun onAdDismiss() {
        Log.d(TAG, "onAdDismiss")
    }

    override fun onSplashAdLoadFail(p0: AdError) {
        Log.d(TAG, "onSplashAdLoadFail")
    }

    override fun onSplashAdLoadSuccess() {
        mTTSplashAd.showAd(container)
    }

    override fun onAdLoadTimeout() {
        Log.d(TAG, "onAdLoadTimeout")
    }

}