//
//  FlutterGromoreInterstitialCache.swift
//  flutter_gromore
//
//  Created by jlq on 2022/6/16.
//

import Foundation
import ABUAdSDK

class FlutterGromoreInterstitialCache: NSObject {
    private static var ads: [String: ABUInterstitialProAd] = [:]
    
    static func addAd(key: String, ad: ABUInterstitialProAd) {
        ads[key] = ad
    }
    
    static func removeAd(key: String) {
        ads.removeValue(forKey: key)
    }
    
    static func getAd(key: String) -> ABUInterstitialProAd? {
        return ads[key]
    }
}
