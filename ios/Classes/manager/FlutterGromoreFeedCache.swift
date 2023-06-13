//
//  FlutterGromoreFeedCache.swift
//  flutter_gromore
//
//  Created by Anand on 2022/6/7.
//

import BUAdSDK

class FlutterGromoreFeedCache: NSObject {
    private static var ads: [String: BUNativeAd] = [:]
    private static var adManager: [String: FlutterGromoreFeedManager] = [:]
    
    static func addAd(_ id: String,_ ad: BUNativeAd) {
        ads[id] = ad
    }
    
    static func removeAd(key: String) {
        ads.removeValue(forKey: key)
        // 移除manager引用 -> 当一个manager实例不被引用时会自动销毁
        adManager.removeValue(forKey: key)
    }
    
    static func getAd(key: String) -> BUNativeAd? {
        return ads[key]
    }
    
    // 保存引用。key为manager引用地址，value为对应的manager实例
    static func addManager(_ id: String,_ manager: FlutterGromoreFeedManager) {
        adManager[id] = manager
    }
    
    // 更新引用，更新后：key为广告id，value为对应的manager实例。这里的目的是方便后面在广告回调中移除
    static func updateManager(managerAddress: String, adAddress: String) {
        let manager = adManager[managerAddress]
        adManager.removeValue(forKey: managerAddress)
        adManager[adAddress] = manager
    }
}
