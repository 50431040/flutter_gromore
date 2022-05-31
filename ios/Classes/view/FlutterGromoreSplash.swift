//
//  FlutterGromoreSplash.swift
//  flutter_gromore
//
//  Created by Anand on 2022/5/31.
//

import ABUAdSDK

class FlutterGromoreSplash: NSObject, ABUSplashAdDelegate {
    var splashAd: ABUSplashAd?
    
    public func initAd(args: Dictionary<String, Any>) {
        let logo: String = args["logo"] as! String
//        let isFullAd: Bool = logo.isEmpty
        self.splashAd = ABUSplashAd(adUnitID: args["adUnitId"] as! String)
        self.splashAd?.delegate = self
//        self.splashAd?.tolerateTimeout = args["timeout"] as! TimeInterval
//        self.splashAd?.splashButtonType
        self.splashAd?.rootViewController = UIApplication.shared.keyWindow?.rootViewController
        self.splashAd?.loadData()
    }
}
