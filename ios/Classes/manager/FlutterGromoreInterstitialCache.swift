//
//  FlutterGromoreInterstitialCache.swift
//  flutter_gromore
//
//  Created by jlq on 2022/6/16.
//

import Foundation
import BUAdSDK

class FlutterGromoreInterstitialCache: NSObject {
    private static var ads: [String: BUNativeExpressFullscreenVideoAd] = [:]
    
    static func addAd(key: String, ad: BUNativeExpressFullscreenVideoAd) {
        ads[key] = ad
    }
    
    static func removeAd(key: String) {
        ads.removeValue(forKey: key)
    }
    
    static func getAd(key: String) -> BUNativeExpressFullscreenVideoAd? {
        return ads[key]
    }
}
