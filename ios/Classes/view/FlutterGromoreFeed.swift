//
//  FlutterGromoreFeed.swift
//  flutter_gromore
//
//  Created by jlq on 2022/5/31.
//

import Foundation
import ABUAdSDK

class FlutterGromoreFeed: NSObject, FlutterPlatformView, ABUNativeAdsManagerDelegate, ABUNativeAdViewDelegate, ABUNativeAdVideoDelegate, FlutterGromoreBase {
    
    var methodChannel: FlutterMethodChannel?
    /// 容器
    private var container: UIView
    /// 传递过来的参数
    private var createParams: Any?
    
    init(frame: CGRect, id: Int64, params: Any?, messenger: FlutterBinaryMessenger) {
        container = UIView(frame: frame)
        createParams = params
        super.init()
        
        methodChannel = initMethodChannel(channelName: "\(FlutterGromoreContants.feedViewTypeId)/\(id)", messenger: messenger)
        initAd()
    }
    
    func initAd() {
        assert(createParams != nil)
        
        print(createParams)
        
        if let params = createParams as? Dictionary<String, Any> {
            let slot: ABUAdUnit = ABUAdUnit()
            
            slot.id = params["adUnitId"] as! String
            
            let size: ABUSize = ABUSize()
            
            // 默认宽度占满
            if let width = params["width"] as? Int {
                size.width = width
            } else {
                size.width = Utils.getScreenWidth
            }
            
            // 0为高度选择自适应参数
            if let height = params["height"] as? Int {
                size.height = height
            } else {
                size.height = 0
            }
            
            // 默认为模板信息流
            if let adStyleType = params["type"] as? Int {
                slot.getExpressAdIfCan = adStyleType == 1
            } else {
                slot.getExpressAdIfCan = true
            }
            
                        
            let adManger: ABUNativeAdsManager = ABUNativeAdsManager.init(slot: slot)
            adManger.rootViewController = Utils.getVC()
            // 静音播放视频
            adManger.startMutedIfCan = true
            adManger.delegate = self
            
            // 当前配置拉取成功，直接loadAdData
            if (ABUAdSDKManager.configDidLoad()) {
                print("configDidLoad")
                adManger.loadAdData(withCount: 3)
            } else {
                print("addConfigLoadSuccessObserver")
                ABUAdSDKManager.addConfigLoadSuccessObserver(self, withAction: { id in
                    adManger.loadAdData(withCount: 3)
                })
            }
        }
        
        
    }
    
    
    func view() -> UIView {
        container
    }
    
    deinit {
        removeAdView()
    }
    
    func removeAdView() {
        for v: UIView in container.subviews {
            v.removeFromSuperview()
        }
    }
    
    /// 广告加载成功
    func nativeAdsManagerSuccess(toLoad adsManager: ABUNativeAdsManager, nativeAds nativeAdViewArray: [ABUNativeAdView]?) {
        
        print(#function)
        postMessage("onAdLoaded")
                
        if let model = nativeAdViewArray?.randomElement() {
            model.rootViewController = Utils.getVC()
            model.delegate = self
            model.videoDelegate = self
            
            if (model.hasExpressAdGot) {
                model.render()
            }
        }
    }
    
    /// 广告加载失败
    func nativeAdsManager(_ adsManager: ABUNativeAdsManager, didFailWithError error: Error?) {
        postMessage("onAdLoadedFail")
    }
    
    /// 广告渲染成功(仅针对原生模板)
    func nativeAdExpressViewRenderSuccess(_ nativeExpressAdView: ABUNativeAdView) {
        container.addSubview(nativeExpressAdView)
        postMessage("onRenderSuccess", arguments: ["height": nativeExpressAdView.bounds.height])
        print(nativeExpressAdView.bounds.height)
    }
    
    /// 广告渲染失败(仅针对原生模板)
    func nativeAdExpressViewRenderFail(_ nativeExpressAdView: ABUNativeAdView, error: Error?) {
        postMessage("onRenderFail")
    }
    
    /// 广告展示
    func nativeAdDidBecomeVisible(_ nativeAdView: ABUNativeAdView) {
        postMessage("onAdShow")
    }
    
    /// 播放状态改变(仅三方adn支持的视频广告有)
    func nativeAdExpressView(_ nativeAdView: ABUNativeAdView, stateDidChanged playerState: ABUPlayerPlayState) {
        postMessage("nativeAdExpressViewStateChange")
    }
    
    /// 点击事件
    func nativeAdDidClick(_ nativeAdView: ABUNativeAdView, with view: UIView?) {
        postMessage("onAdClick")
    }
    
    /// 点击不喜欢关闭广告
    func nativeAdExpressViewDidClosed(_ nativeAdView: ABUNativeAdView?, closeReason filterWords: [[AnyHashable : Any]]?) {
        postMessage("onSelected")
        nativeAdView?.removeFromSuperview()
        removeAdView()
    }
    
    /// 广告即将展示全屏页面/商店时触发
    func nativeAdViewWillPresentFullScreenModal(_ nativeAdView: ABUNativeAdView) {
        postMessage("nativeAdViewWillPresentFullScreenModal")
    }
    
//    /// 视频广告点击
//    func nativeAdVideoDidClick(_ nativeAdView: ABUNativeAdView?) {
//        postMessage("nativeAdVideoDidClick")
//    }
//
//    /// 视频广告状态改变
//    func nativeAdVideo(_ nativeAdView: ABUNativeAdView?, stateDidChanged playerState: ABUPlayerPlayState) {
//        postMessage("nativeAdVideoStateChange")
//    }
//
//    /// 视频广告播放结束
//    func nativeAdVideoDidPlayFinish(_ nativeAdView: ABUNativeAdView?) {
//        postMessage("nativeAdVideoDidPlayFinish")
//    }
}
