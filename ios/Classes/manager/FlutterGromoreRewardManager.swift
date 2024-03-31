//
//  FlutterGromoreRewardManager.swift
//  flutter_gromore
//
//  Created by Stahsf on 2023/6/13.
//

import Foundation
import BUAdSDK

class FlutterGromoreRewardManager: NSObject, BUNativeExpressRewardedVideoAdDelegate {
    private var args: [String: Any]
    private var result: FlutterResult
    private var rewardAd: BUNativeExpressRewardedVideoAd?
    
    init(args: [String: Any], result: @escaping FlutterResult) {
        self.args = args
        self.result = result
    }
    
    func loadAd() {
        let adUnitId: String = args["adUnitId"] as! String

        let slot = BUAdSlot()
        slot.mediation.mutedIfCan = args["muted"] as? Bool ?? true
        slot.id = adUnitId
        
        let model = BURewardedVideoModel()
        rewardAd = BUNativeExpressRewardedVideoAd.init(slot: slot, rewardedVideoModel: model)
        if let ad = rewardAd {
            ad.delegate = self
            ad.loadData()
        }
    }
    
    // 加载成功
    func nativeExpressRewardedVideoAdDidLoad(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd) {
        let id = String(rewardedVideoAd.hashValue)
        FlutterGromoreRewardCache.addAd(key: id, ad: rewardedVideoAd)
        result(id)
    }
    
    // 加载失败
    func nativeExpressRewardedVideoAd(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd, didFailWithError error: Error?) {
        result(FlutterError(code: "0", message: error?.localizedDescription ?? "", details: error?.localizedDescription ?? ""))
    }
    
    
}
