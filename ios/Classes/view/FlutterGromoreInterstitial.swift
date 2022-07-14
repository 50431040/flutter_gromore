//
//  FlutterGromoreInterstitial.swift
//  flutter_gromore
//
//  Created by jlq on 2022/6/1.
//

import ABUAdSDK

class FlutterGromoreInterstitial: NSObject, FlutterGromoreBase, ABUInterstitialProAdDelegate {
    var methodChannel: FlutterMethodChannel?
    private var args: [String: Any]
    private var interstitialAd: ABUInterstitialProAd?
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
        if let ad = interstitialAd, ad.isReady {
            ad.delegate = self
            ad.show(fromRootViewController: Utils.getVC(), extroInfos: nil)
        }
        
    }
    
    /// 展示插全屏广告
    func interstitialProAdDidVisible(_ interstitialProAd: ABUInterstitialProAd) {
        postMessage("onInterstitialShow")
    }
    
    func interstitialProAdDidShowFailed(_ interstitialProAd: ABUInterstitialProAd, error: Error) {
        postMessage("onInterstitialShowFail")
        result(false)
    }
    
    /// 点击插全屏广告
    func interstitialProAdDidClick(_ interstitialProAd: ABUInterstitialProAd) {
        postMessage("onInterstitialAdClick")
    }
    
    /// 插全屏广告关闭
    func interstitialProAdDidClose(_ interstitialProAd: ABUInterstitialProAd) {
        postMessage("onInterstitialClosed")
        result(true)
    }
    
    /// 即将弹出广告详情页
    func interstitialProAdWillPresentFullScreenModal(_ interstitialProAd: ABUInterstitialProAd) {
        postMessage("onAdOpened")
    }
}
