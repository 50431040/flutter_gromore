//
//  FlutterGromoreInterstitialManager.swift
//  flutter_gromore
//
//  Created by jlq on 2022/6/16.
//

import Foundation
import BUAdSDK

class FlutterGromoreInterstitialManager: NSObject, BUNativeExpressFullscreenVideoAdDelegate {
    private var args: [String: Any]
    private var result: FlutterResult
    private var interstitialAd: BUNativeExpressFullscreenVideoAd?
    
    init(args: [String: Any], result: @escaping FlutterResult) {
        self.args = args
        self.result = result
    }
    
    func loadAd() {
        let adUnitId: String = args["adUnitId"] as! String

        let slot = BUAdSlot()
        slot.mediation.mutedIfCan = args["muted"] as? Bool ?? true
        slot.id = adUnitId
        interstitialAd = BUNativeExpressFullscreenVideoAd(slot: slot)
        if let ad = interstitialAd {
            ad.delegate = self
            ad.loadData()
        }
    }
    
    // 加载成功
    func nativeExpressFullscreenVideoAdDidLoad(_ fullscreenVideoAd: BUNativeExpressFullscreenVideoAd) {
        let id = String(fullscreenVideoAd.hashValue)
        FlutterGromoreInterstitialCache.addAd(key: id, ad: fullscreenVideoAd)
        result(id)
    }
    
    // 加载失败
    func nativeExpressFullscreenVideoAd(_ fullscreenVideoAd: BUNativeExpressFullscreenVideoAd, didFailWithError error: Error?) {
        result(FlutterError(code: "0", message: error?.localizedDescription ?? "", details: error?.localizedDescription ?? ""))
    }
    
}
