//
//  FlutterGromoreFeedManager.swift
//  flutter_gromore
//
//  Created by Anand on 2022/6/7.
//

import Foundation
import BUAdSDK

class FlutterGromoreFeedManager: NSObject, BUNativeAdsManagerDelegate {

    private var args: [String: Any]
    private var result: FlutterResult
    private var manager: BUNativeAdsManager?
    
    init(args: [String: Any], result: @escaping FlutterResult) {
        self.args = args
        self.result = result
    }
    
    deinit {
        manager?.mediation?.destory()
    }
    
    func loadAd() {
        let adUnitId: String = args["adUnitId"] as! String
        let adSize: CGSize = CGSize(
            width: args["width"] as? CGFloat ?? UIScreen.main.bounds.size.width,
            // 高度默认为零使用自适应
            height: args["height"] as? CGFloat ?? 0
        )
        let buSize = BUSize()
        buSize.width = 1080;
        buSize.height = 1920
        
        let slot: BUAdSlot = BUAdSlot()
        slot.id = adUnitId
        slot.adSize = adSize
        // 静音播放
        slot.mediation.mutedIfCan = true
        
        manager = BUNativeAdsManager.init(slot: slot)
        
        manager?.delegate = self
        manager?.mediation?.rootViewController = Utils.getVC()
        manager?.loadAdData(withCount: args["count"] as? Int ?? 3)
        
        // 保存引用，不让实例销毁。如果销毁了的话广告的某些事件回调不会触发（巨坑！）
        FlutterGromoreFeedCache.addManager(String(self.hash), self)
    }
    
    func nativeAdsManagerSuccess(toLoad adsManager: BUNativeAdsManager, nativeAds nativeAdDataArray: [BUNativeAd]?) {
        // 将广告视图的 Key 返回给 Flutter 端
        var adsKey: [String] = []
        let adUnitId: String = args["adUnitId"] as! String
        if let ads = nativeAdDataArray {
            ads.forEach { ad in
                let adId: String = "\(adUnitId)_\(ad.hash)"
                adsKey.append(adId)
                // 将广告存下来
                FlutterGromoreFeedCache.addAd(adId, ad)
                FlutterGromoreFeedCache.updateManager(managerAddress: String(self.hash), adAddress: adId)
            }
        }
        
        result(adsKey)
    }

    func nativeAdsManagerDidFinishLoadAdnAd(_ adsManager: BUNativeAdsManager, nativeAd: BUNativeAd?, error: Error?) {
        result(FlutterError(code: "0", message: error?.localizedDescription ?? "", details: error?.localizedDescription ?? ""))
    }
    
}
