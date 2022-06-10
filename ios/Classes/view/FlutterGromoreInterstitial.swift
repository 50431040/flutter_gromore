//
//  FlutterGromoreInterstitial.swift
//  flutter_gromore
//
//  Created by jlq on 2022/6/1.
//

import Foundation
import ABUAdSDK

class FlutterGromoreInterstitial: UIViewController, FlutterGromoreBase, ABUInterstitialProAdDelegate {
    
    var methodChannel: FlutterMethodChannel? = nil
    var createParams: Dictionary<String, Any> = [:]
    
    init(messenger: FlutterBinaryMessenger, arguments: Dictionary<String, Any>) {
        
        super.init(nibName: nil, bundle: nil)
        
        methodChannel = initMethodChannel(channelName: "\(FlutterGromoreContants.interstitialTypeId)/\(arguments["id"] ?? "")", messenger: messenger)
        createParams = arguments
        
        initAd()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    func initAd() {
        
        let adUnitId = createParams["adUnitId"] as! String
        let width = createParams["width"] as! Double
        let height = createParams["height"] as! Double
        
        let size = CGSize.init(width: width, height: height)
        
        let interstitialAd = ABUInterstitialProAd.init(adUnitID: adUnitId, sizeForInterstitial: size)
        interstitialAd.delegate = self
        // 静音
        interstitialAd.mutedIfCan = true
        
        if (ABUAdSDKManager.configDidLoad()) {
            interstitialAd.loadData()
        } else {
            ABUAdSDKManager.addConfigLoadSuccessObserver(self, withAction: { id in
                interstitialAd.loadData()
            })
        }
        
    }
    
    /// 广告加载成功
    func interstitialProAdDidLoad(_ interstitialProAd: ABUInterstitialProAd) {
        postMessage("onInterstitialLoad")
        if (interstitialProAd.isReady) {
            interstitialProAd.show(fromRootViewController: Utils.getVC(), extroInfos: nil)
        }
    }
    
    /// 广告加载失败
    func interstitialProAd(_ interstitialProAd: ABUInterstitialProAd, didFailWithError error: Error?) {
        postMessage("onInterstitialLoadFail")
    }
    
    /// 广告渲染失败
    func interstitialProAdViewRenderFail(_ interstitialProAd: ABUInterstitialProAd, error: Error?) {
        postMessage("onInterstitialShowFail")
    }
    
    /// 广告展示
    func interstitialProAdDidVisible(_ interstitialProAd: ABUInterstitialProAd) {
        postMessage("onInterstitialShow")
    }
    
    /// 广告展示失败
    func interstitialProAdDidShowFailed(_ interstitialProAd: ABUInterstitialProAd, error: Error) {
        postMessage("onInterstitialShowFail")
    }
    
    /// 广告点击
    func interstitialProAdDidClick(_ interstitialProAd: ABUInterstitialProAd) {
        postMessage("onInterstitialAdClick")
    }
    
    /// 广告关闭
    func interstitialProAdDidClose(_ interstitialProAd: ABUInterstitialProAd) {
        postMessage("onInterstitialClosed")
    }
    
    /// 详情页或appstore打开
    func interstitialProAdWillPresentFullScreenModal(_ interstitialProAd: ABUInterstitialProAd) {
        postMessage("onAdOpened")
    }
}
