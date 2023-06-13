package net.niuxiaoer.flutter_gromore.manager

import com.bytedance.sdk.openadsdk.TTRewardVideoAd

class FlutterGromoreRewardCache {
    companion object {
        /// 缓存插屏广告
        private var cacheAd: MutableMap<Int, TTRewardVideoAd> = mutableMapOf()

        /// 添加缓存插屏广告
        fun addCacheAd(id: Int, ad: TTRewardVideoAd) {
            cacheAd[id] = ad
        }

        /// 获取缓存插屏广告
        fun getCacheAd(id: Int): TTRewardVideoAd? {
            return cacheAd[id]
        }

        /// 移除缓存插屏广告
        fun removeCacheAd(id: Int) {
            cacheAd.remove(id)
        }
    }
}