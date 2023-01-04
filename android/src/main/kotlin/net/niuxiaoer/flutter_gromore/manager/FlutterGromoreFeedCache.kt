package net.niuxiaoer.flutter_gromore.manager

import com.bytedance.msdk.api.v2.ad.nativeAd.GMNativeAd

class FlutterGromoreFeedCache {
    companion object {
        /// 缓存信息流广告
        var cacheFeedAd: MutableMap<String, GMNativeAd> = mutableMapOf()

        /// 添加缓存信息流广告
        fun addCacheFeedAd(id: String, ad: GMNativeAd) {
            cacheFeedAd[id] = ad
        }

        /// 获取缓存信息流广告
        fun getCacheFeedAd(id: String): GMNativeAd? {
            return cacheFeedAd[id]
        }

        /// 移除缓存信息流广告
        fun removeCacheFeedAd(id: String) {
            cacheFeedAd.remove(id)
        }
    }
}