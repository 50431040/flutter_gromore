//
//  FlutterGromoreInterstitial.swift
//  flutter_gromore
//
//  Created by jlq on 2022/6/1.
//

import BUAdSDK

class FlutterGromoreInterstitial: NSObject, FlutterGromoreBase, BUNativeExpressFullscreenVideoAdDelegate {
    var methodChannel: FlutterMethodChannel?
    private var args: [String: Any]
    private var interstitialAd: BUNativeExpressFullscreenVideoAd?
    private var result: FlutterResult
    
    init(messenger: FlutterBinaryMessenger, arguments: [String: Any], result: @escaping FlutterResult) {
        args = arguments
        self.result = result
        super.init()
        interstitialAd = FlutterGromoreInterstitialCache.getAd(key: arguments["interstitialId"] as! String)
        methodChannel = initMethodChannel(channelName: "\(FlutterGromoreContants.interstitialTypeId)/\(arguments["interstitialId"] ?? "")", messenger: messenger)
        initAd()
    }
    
    func initAd() {
        if let ad = interstitialAd, ad.mediation?.isReady ?? false {
            ad.delegate = self
            ad.show(fromRootViewController: Utils.getVC())
        }
    }
    
    // 展示插全屏广告
    func nativeExpressFullscreenVideoAdDidVisible(_ fullscreenVideoAd: BUNativeExpressFullscreenVideoAd) {
        postMessage("onInterstitialShow")
    }
    
    // 广告关闭
    func nativeExpressFullscreenVideoAdDidClose(_ fullscreenVideoAd: BUNativeExpressFullscreenVideoAd) {
        postMessage("onInterstitialClosed")
        result(true)
    }
    
    // 渲染失败
    func nativeExpressFullscreenVideoAdViewRenderFail(_ rewardedVideoAd: BUNativeExpressFullscreenVideoAd, error: Error?) {
        postMessage("onInterstitialShowFail")
        result(false)
    }
    
    // 点击
    func nativeExpressFullscreenVideoAdDidClick(_ fullscreenVideoAd: BUNativeExpressFullscreenVideoAd) {
        postMessage("onInterstitialAdClick")
    }
}
