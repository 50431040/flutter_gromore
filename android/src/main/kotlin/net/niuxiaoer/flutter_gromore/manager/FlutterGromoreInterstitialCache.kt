package net.niuxiaoer.flutter_gromore.manager

import com.bytedance.sdk.openadsdk.TTFullScreenVideoAd


class FlutterGromoreInterstitialCache {
    companion object {
        /// 缓存插屏广告
        private var cacheInterstitialAd: MutableMap<Int, TTFullScreenVideoAd> = mutableMapOf()

        /// 添加缓存插屏广告
        fun addCacheInterstitialAd(id: Int, ad: TTFullScreenVideoAd) {
            cacheInterstitialAd[id] = ad
        }

        /// 获取缓存插屏广告
        fun getCacheInterstitialAd(id: Int): TTFullScreenVideoAd? {
            return cacheInterstitialAd[id]
        }

        /// 移除缓存插屏广告
        fun removeCacheInterstitialAd(id: Int) {
            cacheInterstitialAd.remove(id)
        }
    }
}