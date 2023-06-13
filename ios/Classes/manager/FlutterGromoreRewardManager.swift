//
//  FlutterGromoreRewardManager.swift
//  flutter_gromore
//
//  Created by Stahsf on 2023/6/13.
//

import Foundation
import BUAdSDK

class FlutterGromoreRewardManager: NSObject, BURewardedVideoAdDelegate {
    private var args: [String: Any]
    private var result: FlutterResult
    private var rewardAd: BURewardedVideoAd?
    
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
        rewardAd = BURewardedVideoAd.init(slot: slot, rewardedVideoModel: model)
        if let ad = rewardAd {
            ad.delegate = self
            ad.loadData()
        }
    }
    
    // 加载成功
    func rewardedVideoAdDidLoad(_ rewardedVideoAd: BURewardedVideoAd) {
        let id = String(rewardedVideoAd.hashValue)
        FlutterGromoreRewardCache.addAd(key: id, ad: rewardedVideoAd)
        result(id)
    }
    
    // 加载失败
    func rewardedVideoAd(_ rewardedVideoAd: BURewardedVideoAd, didFailWithError error: Error?) {
        result(FlutterError(code: "0", message: error?.localizedDescription ?? "", details: error?.localizedDescription ?? ""))
    }
    
}
