package net.niuxiaoer.flutter_gromore.manager

import com.bytedance.sdk.openadsdk.TTFeedAd

class FlutterGromoreFeedCache {
    companion object {
        /// 缓存信息流广告
        var cacheFeedAd: MutableMap<String, TTFeedAd> = mutableMapOf()

        /// 添加缓存信息流广告
        fun addCacheFeedAd(id: String, ad: TTFeedAd) {
            cacheFeedAd[id] = ad
        }

        /// 获取缓存信息流广告
        fun getCacheFeedAd(id: String): TTFeedAd? {
            return cacheFeedAd[id]
        }

        /// 移除缓存信息流广告
        fun removeCacheFeedAd(id: String) {
            cacheFeedAd.remove(id)
        }
    }
}