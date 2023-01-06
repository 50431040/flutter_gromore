//
//  FlutterGromoreFeedCache.swift
//  flutter_gromore
//
//  Created by Anand on 2022/6/7.
//

import ABUAdSDK

class FlutterGromoreFeedCache: NSObject {
    private static var ads: [String: ABUNativeAdView] = [:]
    
    static func addAd(_ id: String,_ ad: ABUNativeAdView) {
        ads[id] = ad
    }
    
    static func removeAd(key: String) {
        ads.removeValue(forKey: key)
    }
    
    static func getAd(key: String) -> ABUNativeAdView? {
        return ads[key]
    }
}
