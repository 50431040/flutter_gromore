//
//  FlutterGromoreFeed.swift
//  flutter_gromore
//
//  Created by jlq on 2022/5/31.
//

import Foundation
import ABUAdSDK

class FlutterGromoreFeed: NSObject, FlutterPlatformView, ABUNativeAdViewDelegate, ABUNativeAdVideoDelegate {
    var methodChannel: FlutterMethodChannel
    /// 容器
    private var container: FlutterGromoreIntercptPenetrateView
    /// 传递过来的参数
    private var createParams: [String: Any]
    
    /// 广告已终止，避免多次回调
    private var isTerminate = false
    
    init(frame: CGRect, id: Int64, params: Any?, messenger: FlutterBinaryMessenger) {
        methodChannel = FlutterMethodChannel(name: "\(FlutterGromoreContants.feedViewTypeId)/\(id)", binaryMessenger: messenger)
        container = FlutterGromoreIntercptPenetrateView(frame: frame, methodChannel: methodChannel)
        createParams = params as? [String : Any] ?? [:]
        super.init()
        initAd()
    }
    
    func initAd() {
        let adViewId: String = createParams["feedId"] as! String
        if let adView: ABUNativeAdView = FlutterGromoreFeedCache.getAd(key: adViewId) {
            adView.rootViewController = Utils.getVC()
            adView.delegate = self
            adView.videoDelegate = self
            if adView.isExpressAd {
                adView.render()
            }
        }
    }
    
    private func postMessage(_ method: String, arguments: Any? = nil) {
        methodChannel.invokeMethod(method, arguments: arguments)
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
        let adId: String = createParams["feedId"] as! String
        FlutterGromoreFeedCache.removeAd(key: adId)
    }
    
    /// 检测广告是否被终止，WKWebView占用内存较大时，部分进程被终止导致白屏
    /// 根据白屏时 WKCompositingView 从 UIView 上卸载进行判断
    private func checkAdTerminate(_ views: [UIView]) -> Bool {
        for view in views {
            if !view.subviews.isEmpty {
                return checkAdTerminate(view.subviews)
            }
            return !String(describing: view).contains("WKCompositingView")
        }
        return false
    }
    
    /// 广告渲染成功(仅针对原生模板)
    func nativeAdExpressViewRenderSuccess(_ nativeExpressAdView: ABUNativeAdView) {
        postMessage("onRenderSuccess", arguments: ["height": nativeExpressAdView.bounds.height])
        
        var frame = container.frame
        frame.size.height = nativeExpressAdView.bounds.height
        container.frame = frame
        
        container.addSubview(nativeExpressAdView)
    }
    
    /// 广告渲染失败(仅针对原生模板)
    func nativeAdExpressViewRenderFail(_ nativeExpressAdView: ABUNativeAdView, error: Error?) {
        postMessage("onRenderFail")
    }
    
    /// 广告展示
    func nativeAdDidBecomeVisible(_ nativeAdView: ABUNativeAdView) {
        postMessage("onAdShow")
        
        if let adnName = nativeAdView.getShowEcpmInfo()?.adnName, adnName == "pangle" {
            // 穿山甲广告存在点击穿透
            container.isPermeable = true
            // 穿山甲广告每次滑入视图时都会调用 “用户申请展示广告”
            // Guess: BUNativeExpressAdView 大概在 viewWillAppear 调用了展示广告，打算移除这一层
            // 层级结构：ABUNativeAdView -> BUNativeExpressAdView -> BUWKWebViewClient
            //
            // if let pangleNativeAdView = nativeAdView.subviews.first,
            //    let pangleWebView = pangleNativeAdView.subviews.first {
            //     pangleNativeAdView.removeFromSuperview()
            //     nativeAdView.addSubview(pangleWebView)
            // }
            // 穿山甲信息流使用WKWebView，加载过多时之前的信息流会白屏
            if !isTerminate, checkAdTerminate(container.subviews) {
                isTerminate = true
                postMessage("onAdTerminate")
            }
        }
    }
    
    /// 播放状态改变(仅三方adn支持的视频广告有)
    func nativeAdExpressView(_ nativeAdView: ABUNativeAdView, stateDidChanged playerState: ABUPlayerPlayState) {
        //        postMessage("nativeAdExpressViewStateChange")
    }
    
    /// 点击事件
    func nativeAdDidClick(_ nativeAdView: ABUNativeAdView, with view: UIView?) {
        postMessage("onAdClick")
    }
    
    /// 点击不喜欢关闭广告
    func nativeAdExpressViewDidClosed(_ nativeAdView: ABUNativeAdView?, closeReason filterWords: [[AnyHashable : Any]]?) {
        postMessage("onSelected")
        if let adView = nativeAdView {
            adView.removeFromSuperview()
        }
        removeAdView()
    }
    
    /// 广告即将展示全屏页面/商店时触发
    func nativeAdViewWillPresentFullScreenModal(_ nativeAdView: ABUNativeAdView) {
        //        postMessage("nativeAdViewWillPresentFullScreenModal")
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
