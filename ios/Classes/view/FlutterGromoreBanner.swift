//
//  FlutterGromoreBanner.swift
//  flutter_gromore
//
//  Created by Stahsf on 2023/6/24.
//

import Foundation
import BUAdSDK

class FlutterGromoreBanner: NSObject, FlutterPlatformView, BUNativeExpressBannerViewDelegate {
    
    
    var methodChannel: FlutterMethodChannel
    /// 容器
    private var container: FlutterGromoreIntercptPenetrateView
    /// 传递过来的参数
    private var createParams: [String: Any]
    
    private var bannerAd: BUNativeExpressBannerView?
    
    init(frame: CGRect, id: Int64, params: Any?, messenger: FlutterBinaryMessenger) {
        methodChannel = FlutterMethodChannel(name: "\(FlutterGromoreContants.bannerTypeId)/\(id)", binaryMessenger: messenger)
        container = FlutterGromoreIntercptPenetrateView(frame: frame, methodChannel: methodChannel)
        createParams = params as? [String : Any] ?? [:]
        super.init()
        initAd()
    }
    
    func initAd() {
        print("FlutterGromoreBanner initAd")
        let adUnitId: String = createParams["adUnitId"] as! String
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        if createParams["width"] != nil {
            width = CGFloat(Float(createParams["width"] as! String) ?? 0)
        } else {
            width = UIScreen.main.bounds.size.width
        }
        
        if createParams["height"] != nil {
            height = CGFloat(Float(createParams["height"] as! String) ?? 0)
        } else {
            height = 150
        }
        
        
        let adSize: CGSize = CGSize(
            width: width,
            // 高度默认为150
            height: height
        )
        let buSize = BUSize()
        buSize.width = 1080
        buSize.height = 1920
        
        let slot: BUAdSlot = BUAdSlot()
        slot.id = adUnitId
        slot.adSize = adSize
        // 静音播放
        slot.mediation.mutedIfCan = true
        
        bannerAd = BUNativeExpressBannerView.init(slot: slot, rootViewController: Utils.getVC(), adSize: adSize)
        bannerAd?.frame = CGRectMake(0, 0, adSize.width, adSize.height)
        bannerAd?.delegate = self
        bannerAd?.loadAdData()
    }
    
    private func postMessage(_ method: String, arguments: Any? = nil) {
        methodChannel.invokeMethod(method, arguments: arguments)
    }
    
    func view() -> UIView {
        container
    }
    
    deinit {
        print("FlutterGromoreBanner deinit");
        removeAdView()
    }
    
    func removeAdView() {
        for v: UIView in container.subviews {
            v.removeFromSuperview()
        }
        bannerAd?.removeFromSuperview()
        bannerAd = nil
    }
    
    // 加载成功
    func nativeExpressBannerAdViewDidLoad(_ bannerAdView: BUNativeExpressBannerView) {
        print("FlutterGromoreBanner nativeExpressBannerAdViewDidLoad")
        container.clipsToBounds = true
        container.addSubview(bannerAd!)
        postMessage("onRenderSuccess")
    }
    
    // 加载失败
    func nativeExpressBannerAdView(_ bannerAdView: BUNativeExpressBannerView, didLoadFailWithError error: Error?) {
        postMessage("onLoadError")
    }
    
    // 渲染成功
    func nativeExpressBannerAdViewRenderSuccess(_ bannerAdView: BUNativeExpressBannerView) {
    }
    
    // 被强制移除
    func nativeExpressBannerAdViewDidRemoved(_ bannerAdView: BUNativeExpressBannerView) {
        postMessage("onAdTerminate")
    }
    
    // 选择关闭原因
    func nativeExpressBannerAdView(_ bannerAdView: BUNativeExpressBannerView, dislikeWithReason filterwords: [BUDislikeWords]?) {
        removeAdView()
        postMessage("onSelected")
    }
    
    // 点击
    func nativeExpressBannerAdViewDidClick(_ bannerAdView: BUNativeExpressBannerView) {
        postMessage("onAdClick")
    }
    
    // 展示
    func nativeExpressBannerAdViewWillBecomVisible(_ bannerAdView: BUNativeExpressBannerView) {
        postMessage("onAdShow")
    }
    
    // 渲染失败
    func nativeExpressBannerAdViewRenderFail(_ bannerAdView: BUNativeExpressBannerView, error: Error?) {
        postMessage("onRenderFail")
    }
}
