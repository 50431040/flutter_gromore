package net.niuxiaoer.flutter_gromore.manager

import com.bytedance.msdk.api.v2.ad.interstitialFull.GMInterstitialFullAd

class FlutterGromoreInterstitialCache {
    companion object {
        /// 缓存插屏广告
        private var cacheInterstitialAd: MutableMap<Int, GMInterstitialFullAd> = mutableMapOf()

        /// 添加缓存插屏广告
        fun addCacheInterstitialAd(id: Int, ad: GMInterstitialFullAd) {
            cacheInterstitialAd[id] = ad
        }

        /// 获取缓存插屏广告
        fun getCacheInterstitialAd(id: Int): GMInterstitialFullAd? {
            return cacheInterstitialAd[id]
        }

        /// 移除缓存插屏广告
        fun removeCacheInterstitialAd(id: Int) {
            cacheInterstitialAd.remove(id)
        }
    }
}