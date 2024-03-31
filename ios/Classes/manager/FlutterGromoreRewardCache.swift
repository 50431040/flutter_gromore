//
//  FlutterGromoreRewardCache.swift
//  flutter_gromore
//
//  Created by Stahsf on 2023/6/13.
//

import Foundation
import BUAdSDK

class FlutterGromoreRewardCache: NSObject {
    private static var ads: [String: BUNativeExpressRewardedVideoAd] = [:]
    
    static func addAd(key: String, ad: BUNativeExpressRewardedVideoAd) {
        ads[key] = ad
    }
    
    static func removeAd(key: String) {
        ads.removeValue(forKey: key)
    }
    
    static func getAd(key: String) -> BUNativeExpressRewardedVideoAd? {
        return ads[key]
    }
}
