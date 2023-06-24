package net.niuxiaoer.flutter_gromore.manager

import com.bytedance.sdk.openadsdk.TTNativeExpressAd

class FlutterGromoreBannerCache {
    companion object {
        /// 缓存banner广告
        var cacheBannerAd: MutableMap<String, TTNativeExpressAd> = mutableMapOf()

        /// 添加缓存banner广告
        fun addCacheBannerAd(id: String, ad: TTNativeExpressAd) {
            cacheBannerAd[id] = ad
        }

        /// 获取缓存banner广告
        fun getCacheBannerAd(id: String): TTNativeExpressAd? {
            return cacheBannerAd[id]
        }

        /// 移除缓存banner广告
        fun removeCacheBannerAd(id: String) {
            cacheBannerAd.remove(id)
        }
    }
}