//
//  FlutterGromoreFeed.swift
//  flutter_gromore
//
//  Created by jlq on 2022/5/31.
//

import Foundation
import ABUAdSDK

class FlutterGromoreFeed: NSObject, FlutterPlatformView, ABUNativeAdsManagerDelegate, ABUNativeAdViewDelegate {
    
    private var feedView: UIView
    
    init(frame: CGRect, id: Int64, params: Any?, messenger: FlutterBinaryMessenger) {
        feedView = UIView(frame: frame)
        super.init()
        initAd()
    }
    
    func initAd() {
//        ABUNativeAdsManager.init(adUnitID: "5220559", adSize: CGSize(width: 100, height: 100))
    }
    
    
    func view() -> UIView {
        feedView
    }
    
    deinit {
        
    }
    
    // 广告加载成功
    func nativeAdsManagerSuccess(toLoad adsManager: ABUNativeAdsManager, nativeAds nativeAdViewArray: [ABUNativeAdView]?) {
        
    }
    
    // 广告加载失败
    func nativeAdsManager(_ adsManager: ABUNativeAdsManager, didFailWithError error: Error?) {
        
    }
    
    // 广告渲染成功(仅针对原生模板)
    func nativeAdExpressViewRenderSuccess(_ nativeExpressAdView: ABUNativeAdView) {
        
    }
    
    // 广告渲染失败(仅针对原生模板)
    func nativeAdExpressViewRenderFail(_ nativeExpressAdView: ABUNativeAdView, error: Error?) {
        
    }
    
    // 广告展示
    func nativeAdDidBecomeVisible(_ nativeAdView: ABUNativeAdView) {
        
    }
    
    // 播放状态改变(仅三方adn支持的视频广告有)
    func nativeAdExpressView(_ nativeAdView: ABUNativeAdView, stateDidChanged playerState: ABUPlayerPlayState) {
        
    }
    
    // 点击事件
    func nativeAdDidClick(_ nativeAdView: ABUNativeAdView, with view: UIView?) {
        
    }
    
    // 关闭
    func nativeAdExpressViewDidClosed(_ nativeAdView: ABUNativeAdView?, closeReason filterWords: [[AnyHashable : Any]]?) {
        
    }
}
