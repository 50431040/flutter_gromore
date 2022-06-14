//
//  FlutterGromoreFeedManager.swift
//  flutter_gromore
//
//  Created by Anand on 2022/6/7.
//

import ABUAdSDK

class FlutterGromoreFeedManager: NSObject, ABUNativeAdsManagerDelegate {
    private var args: [String: Any]
    private var result: FlutterResult
    
    init(args: [String: Any], result: @escaping FlutterResult) {
        self.args = args
        self.result = result
    }
    
    func loadAd() {
        let adUnitId: String = args["adUnitId"] as! String
        let adSize: CGSize = CGSize(
            width: args["width"] as? CGFloat ?? UIScreen.main.bounds.size.width,
            // 高度默认为零使用自适应
            height: args["height"] as? CGFloat ?? 0
        )
        let adManager: ABUNativeAdsManager = ABUNativeAdsManager(adUnitID: adUnitId, adSize: adSize)
        adManager.delegate = self
        adManager.rootViewController = Utils.getVC()
        // 静音播放
        adManager.startMutedIfCan = true
        // 模版广告
        adManager.getExpressAdIfCan = (args["type"] as? Int ?? 1) == 1
        adManager.loadAdData(withCount: 3)
    }
    
    /// 广告加载成功
    func nativeAdsManagerSuccess(toLoad adsManager: ABUNativeAdsManager, nativeAds nativeAdViewArray: [ABUNativeAdView]?) {
        // 将广告视图的 Key 返回给 Flutter 端
        var adsKey: [String] = []
        if let ads = nativeAdViewArray {
            ads.forEach { ad in
                adsKey.append(ad.adViewID)
                // 将广告存下来
                FlutterGromoreFeedCache.addAd(ad)
            }
        }
        result(adsKey)
    }
    
    /// 广告加载失败
    func nativeAdsManager(_ adsManager: ABUNativeAdsManager, didFailWithError error: Error?) {
        result(FlutterError())
    }
}
