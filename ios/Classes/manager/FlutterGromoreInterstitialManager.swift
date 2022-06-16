//
//  FlutterGromoreInterstitialManager.swift
//  flutter_gromore
//
//  Created by jlq on 2022/6/16.
//

import Foundation
import ABUAdSDK

class FlutterGromoreInterstitialManager: NSObject, ABUInterstitialProAdDelegate {
    private var args: [String: Any]
    private var result: FlutterResult
    private var interstitialAd: ABUInterstitialProAd?
    
    init(args: [String: Any], result: @escaping FlutterResult) {
        self.args = args
        self.result = result
    }
    
    func loadAd() {
        let adUnitId: String = args["adUnitId"] as! String
        let size: CGSize = CGSize(
            width: args["width"] as? Double ?? 0,
            height: args["height"] as? Double ?? 0
        )
        interstitialAd = ABUInterstitialProAd(adUnitID: adUnitId, sizeForInterstitial: size)
        if let ad = interstitialAd {
            ad.delegate = self
            ad.mutedIfCan = true
            ad.loadData()
        }
    }
    
    /// 插全屏广告加载成功
    func interstitialProAdDidLoad(_ interstitialProAd: ABUInterstitialProAd) {
        let id = String(interstitialAd.hashValue)
        FlutterGromoreInterstitialCache.addAd(key: id, ad: interstitialAd!)
        result(id)
    }
    
    /// 插全屏广告加载失败
    func interstitialProAd(_ interstitialProAd: ABUInterstitialProAd, didFailWithError error: Error?) {
        result(FlutterError(code: "0", message: error?.localizedDescription ?? "", details: error?.localizedDescription ?? ""))
    }
}
