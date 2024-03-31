//
//  FlutterGromoreReward.swift
//  flutter_gromore
//
//  Created by Stahsf on 2023/6/13.
//

import Foundation
import BUAdSDK

class FlutterGromoreReward: NSObject, FlutterGromoreBase, BUMNativeExpressRewardedVideoAdDelegate {
    var methodChannel: FlutterMethodChannel?
    private var args: [String: Any]
    private var rewardAd: BUNativeExpressRewardedVideoAd?
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
    
    func nativeExpressRewardedVideoAdDidVisible(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd) {
        postMessage("onAdShow")
    }
    
    func nativeExpressRewardedVideoAdDidClick(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd) {
        postMessage("onAdVideoBarClick")
    }
    
    func nativeExpressRewardedVideoAdDidClose(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd) {
        postMessage("onAdClose")
        result(true)
        destroyAd()
    }
    
    func nativeExpressRewardedVideoAdDidPlayFinish(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd, didFailWithError error: Error?) {
        postMessage("onVideoComplete")
    }
    
    func nativeExpressRewardedVideoAdServerRewardDidFail(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd, error: Error?) {
        postMessage("onVideoError")
        result(false)
        destroyAd()
    }
    
    func nativeExpressRewardedVideoAdServerRewardDidSucceed(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd, verify: Bool) {
        postMessage("onRewardVerify", arguments: ["verify": verify])
    }
    
    func nativeExpressRewardedVideoAdDidClickSkip(_ rewardedVideoAd: BUNativeExpressRewardedVideoAd) {
        postMessage("onSkippedVideo")
    }
}
