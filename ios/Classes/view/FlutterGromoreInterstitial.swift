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
    
    init(messenger: FlutterBinaryMessenger, arguments: [String: Any]) {
        args = arguments
        super.init()
        methodChannel = initMethodChannel(channelName: "\(FlutterGromoreContants.interstitialTypeId)/\(arguments["id"] ?? "")", messenger: messenger)
        initAd()
    }
    
    func initAd() {
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
        postMessage("onInterstitialLoad")
        if let ad = interstitialAd, ad.isReady {
            ad.show(fromRootViewController: Utils.getVC(), extroInfos: nil)
        }
    }
    
    /// 插全屏广告加载失败
    func interstitialProAd(_ interstitialProAd: ABUInterstitialProAd, didFailWithError error: Error?) {
        postMessage("onInterstitialLoadFail")
    }
    
    /// 展示插全屏广告
    func interstitialProAdDidVisible(_ interstitialProAd: ABUInterstitialProAd) {
        postMessage("onInterstitialShow")
    }
    
    func interstitialProAdDidShowFailed(_ interstitialProAd: ABUInterstitialProAd, error: Error) {
        postMessage("onInterstitialShowFail")
    }
    
    /// 点击插全屏广告
    func interstitialProAdDidClick(_ interstitialProAd: ABUInterstitialProAd) {
        postMessage("onInterstitialAdClick")
    }
    
    /// 插全屏广告关闭
    func interstitialProAdDidClose(_ interstitialProAd: ABUInterstitialProAd) {
        postMessage("onInterstitialClosed")
    }
    
    /// 即将弹出广告详情页
    func interstitialProAdWillPresentFullScreenModal(_ interstitialProAd: ABUInterstitialProAd) {
        postMessage("onAdOpened")
    }
}
