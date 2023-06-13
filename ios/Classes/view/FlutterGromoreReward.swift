//
//  FlutterGromoreReward.swift
//  flutter_gromore
//
//  Created by Stahsf on 2023/6/13.
//

import Foundation
import BUAdSDK

class FlutterGromoreReward: NSObject, FlutterGromoreBase, BURewardedVideoAdDelegate {
    var methodChannel: FlutterMethodChannel?
    private var args: [String: Any]
    private var rewardAd: BURewardedVideoAd?
    private var result: FlutterResult
    private var rewardId: String = ""
    
    init(messenger: FlutterBinaryMessenger, arguments: [String: Any], result: @escaping FlutterResult) {
        args = arguments
        self.result = result
        super.init()
        rewardId = arguments["rewardId"] as! String
        rewardAd = FlutterGromoreRewardCache.getAd(key: rewardId)
        methodChannel = initMethodChannel(channelName: "\(FlutterGromoreContants.rewardTypeId)/\(rewardId)", messenger: messenger)
        initAd()
    }
    
    func initAd() {
        if let ad = rewardAd, ad.mediation?.isReady ?? false {
            ad.delegate = self
            ad.show(fromRootViewController: Utils.getVC())
        }
    }
    
    func destroyAd() {
        FlutterGromoreRewardCache.removeAd(key: rewardId)
        rewardAd = nil
    }
    
    func rewardedVideoAdDidVisible(_ rewardedVideoAd: BURewardedVideoAd) {
        postMessage("onAdShow")
    }
    
    func rewardedVideoAdDidClick(_ rewardedVideoAd: BURewardedVideoAd) {
        postMessage("onAdVideoBarClick")
    }
    
    func rewardedVideoAdDidClose(_ rewardedVideoAd: BURewardedVideoAd) {
        postMessage("onAdClose")
        result(true)
        destroyAd()
    }
    
    func rewardedVideoAdDidPlayFinish(_ rewardedVideoAd: BURewardedVideoAd, didFailWithError error: Error?) {
        postMessage("onVideoComplete")
    }
    
    func rewardedVideoAdServerRewardDidFail(_ rewardedVideoAd: BURewardedVideoAd, error: Error) {
        postMessage("onVideoError")
        result(false)
        destroyAd()
    }
    
    func rewardedVideoAdServerRewardDidSucceed(_ rewardedVideoAd: BURewardedVideoAd, verify: Bool) {
        postMessage("onRewardVerify", arguments: ["verify": verify])
    }
    
    func rewardedVideoAdDidClickSkip(_ rewardedVideoAd: BURewardedVideoAd) {
        postMessage("onSkippedVideo")
    }
}
