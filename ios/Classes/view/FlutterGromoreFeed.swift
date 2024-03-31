//
//  FlutterGromoreFeed.swift
//  flutter_gromore
//
//  Created by jlq on 2022/5/31.
//

import Foundation
import BUAdSDK

class FlutterGromoreFeed: NSObject, FlutterPlatformView, BUMNativeAdDelegate {
    
    
    var methodChannel: FlutterMethodChannel
    /// 容器
    private var container: FlutterGromoreIntercptPenetrateView
    /// 传递过来的参数
    private var createParams: [String: Any]
    
    private var feedAd: BUNativeAd?
    
    init(frame: CGRect, id: Int64, params: Any?, messenger: FlutterBinaryMessenger) {
        methodChannel = FlutterMethodChannel(name: "\(FlutterGromoreContants.feedViewTypeId)/\(id)", binaryMessenger: messenger)
        container = FlutterGromoreIntercptPenetrateView(frame: frame, methodChannel: methodChannel)
        createParams = params as? [String : Any] ?? [:]
        super.init()
        initAd()
    }
    
    func initAd() {
        let adViewId: String = createParams["feedId"] as! String
        if let ad: BUNativeAd = FlutterGromoreFeedCache.getAd(key: adViewId) {
            ad.rootViewController = Utils.getVC()
            ad.delegate = self
            if ad.mediation?.isExpressAd ?? false {
                feedAd = ad
                ad.mediation?.render()
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
    
    func nativeAdWillPresentFullScreenModal(_ nativeAd: BUNativeAd) {
    }
    
    func nativeAdExpressViewRenderSuccess(_ nativeAd: BUNativeAd) {
        if let height = nativeAd.mediation?.canvasView.bounds.height {
            postMessage("onRenderSuccess", arguments: ["height": height])

            container.frame.size.height = height
            container.clipsToBounds = true

            container.addSubview(nativeAd.mediation!.canvasView)
        }
    }
    
    func nativeAdExpressViewRenderFail(_ nativeAd: BUNativeAd, error: Error?) {
        postMessage("onRenderFail")
    }
    
    func nativeAdVideo(_ nativeAd: BUNativeAd?, stateDidChanged playerState: BUPlayerPlayState) {
    }
    
    func nativeAdVideoDidClick(_ nativeAd: BUNativeAd?) {
        postMessage("onAdClick")
    }
    
    func nativeAdVideoDidPlayFinish(_ nativeAd: BUNativeAd?) {
    }
    
    func nativeAdShakeViewDidDismiss(_ nativeAd: BUNativeAd?) {
    }
    
    func nativeAdVideo(_ nativeAdView: BUNativeAd?, rewardDidCountDown countDown: Int) {
    }
    
    
    func nativeAdDidClick(_ nativeAd: BUNativeAd, with view: UIView?) {
        postMessage("onAdClick")
    }

    
    func nativeAdDidBecomeVisible(_ nativeAd: BUNativeAd) {
        postMessage("onAdShow")
        container.isPermeable = true

        // if let adnName = nativeAd.mediation?.getShowEcpmInfo()?.adnName, adnName == "pangle" {
            // 穿山甲广告存在点击穿透
            // container.isPermeable = true
            // 穿山甲广告每次滑入视图时都会调用 “用户申请展示广告”
            // Guess: BUNativeExpressAdView 大概在 viewWillAppear 调用了展示广告，打算移除这一层
            // 层级结构：ABUNativeAdView -> BUNativeExpressAdView -> BUWKWebViewClient
            //
            // if let pangleNativeAdView = nativeAdView.subviews.first,
            //    let pangleWebView = pangleNativeAdView.subviews.first {
            //     pangleNativeAdView.removeFromSuperview()
            //     nativeAdView.addSubview(pangleWebView)
            // }
        // }
    }

    func nativeAd(_ nativeAd: BUNativeAd?, dislikeWithReason filterWords: [BUDislikeWords]?) {
        postMessage("onSelected")
        nativeAd?.mediation?.canvasView.removeFromSuperview()
        removeAdView()
    }
    
    
    // 被强制关闭
    func nativeAd(_ nativeAd: BUNativeAd?, adContainerViewDidRemoved adContainerView: UIView) {
        postMessage("onAdTerminate")
        removeAdView()
    }

}
