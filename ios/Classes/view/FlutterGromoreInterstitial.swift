//
//  FlutterGromoreInterstitial.swift
//  flutter_gromore
//
//  Created by jlq on 2022/6/1.
//

import Foundation
import ABUAdSDK

class FlutterGromoreInterstitial: UIViewController, FlutterGromoreBase, ABUInterstitialAdDelegate {
    
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
        
        let interstitialAd = ABUInterstitialAd.init(adUnitID: adUnitId, size: size)
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
    func interstitialAdDidLoad(_ interstitialAd: ABUInterstitialAd) {
        postMessage("onInterstitialLoad")
        if (interstitialAd.isReady) {
            interstitialAd.show(fromRootViewController: Utils.getVC())
        }
    }
    
    /// 广告加载失败
    func interstitialAd(_ interstitialAd: ABUInterstitialAd, didFailWithError error: Error?) {
        postMessage("onInterstitialLoadFail")
    }
    
    /// 广告渲染失败
    func interstitialAdViewRenderFail(_ interstitialAd: ABUInterstitialAd, error: Error?) {
        postMessage("onInterstitialShowFail")
    }
    
    /// 广告展示
    func interstitialAdDidVisible(_ interstitialAd: ABUInterstitialAd) {
        postMessage("onInterstitialShow")
    }
    
    /// 广告展示失败
    func interstitialAdDidShowFailed(_ interstitialAd: ABUInterstitialAd, error: Error) {
        postMessage("onInterstitialShowFail")
    }
    
    /// 广告点击
    func interstitialAdDidClick(_ interstitialAd: ABUInterstitialAd) {
        postMessage("onInterstitialAdClick")
    }
    
    /// 广告关闭
    func interstitialAdDidClose(_ interstitialAd: ABUInterstitialAd) {
        postMessage("onInterstitialClosed")
    }
    
    /// 详情页或appstore打开
    func interstitialAdWillPresentFullScreenModal(_ interstitialAd: ABUInterstitialAd) {
        postMessage("onAdOpened")
    }
}
