//
//  FlutterGromoreSplash.swift
//  flutter_gromore
//
//  Created by Anand on 2022/5/31.
//

import BUAdSDK

class FlutterGromoreSplash: NSObject, BUSplashAdDelegate {
    
    private var eventId: String?
    private var splashAd: BUSplashAd?
    private var result: FlutterResult

    // 自动关闭timer
    private var closeAdTimer: GCDTask?
    // 自动跳过timer
    private var skipAdTimer: GCDTask?
    
    // 结束标识，防止多次调用
    private var ended = false
    
    init(args: [String: Any], result: @escaping FlutterResult) {
        eventId = args["id"] as? String
        self.result = result
        super.init()
        initAd(args: args)
    }
    
    /// 初始化广告
    private func initAd(args: [String: Any]) {
        let slot = BUAdSlot()
        slot.id = args["adUnitId"] as! String
        slot.mediation.mutedIfCan = true
        slot.mediation.bidNotify = (args["bidNotify"] ?? false) as! Bool
        
        splashAd = BUSplashAd(slot: slot, adSize: CGSizeZero)
        splashAd?.delegate = self
        // 展示 logo
        let logo: String = args["logo"] as? String ?? ""
        if !logo.isEmpty {
            splashAd?.mediation?.customBottomView = generateLogoContainer(name: logo)
        }
        // 加载开屏广告
        splashAd?.loadData()
        
        // 6秒后广告未展示，延时自动关闭
        closeAdTimer = GCDTool.gcdDelay(6) {
            self.sendEvent("onAutoClose")
            self.splashEnd(false)
        }
    }
    
    /// 创建 logo 容器
    private func generateLogoContainer(name: String) -> UIView {
        // logo 图片
        let logoImage: UIView = UIImageView(image: UIImage(named: name))
        // 容器
        let screenSize: CGSize = UIScreen.main.bounds.size
        let logoContainerWidth: CGFloat = screenSize.width
        let logoContainerHeight: CGFloat = screenSize.height * 0.15
        let logoContainer: UIView = UIView(frame: CGRect(x: 0, y: 0, width: logoContainerWidth, height: logoContainerHeight))
        logoContainer.backgroundColor = UIColor.white
        // 居中
        logoImage.contentMode = UIView.ContentMode.center
        logoImage.center = logoContainer.center
        // 设置到开屏广告底部
        logoContainer.addSubview(logoImage)
        return logoContainer
    }
    
    private func sendEvent(_ message: String) {
        if let id = eventId {
            AdEventHandler.instance.sendEvent(AdEvent(id: id, name: message))
        }
    }
    
    // 开屏广告加载完成
    func splashAdLoadSuccess(_ splashAd: BUSplashAd) {
        sendEvent("onSplashAdLoadSuccess")
        splashAd.showSplashView(inRootViewController: UIApplication.shared.keyWindow!.rootViewController!)
    }
    
    // 开屏广告加载失败
    func splashAdLoadFail(_ splashAd: BUSplashAd, error: BUAdError?) {
        sendEvent("onSplashAdLoadFail")
        splashEnd(false)
    }
    
    
    func splashAdRenderSuccess(_ splashAd: BUSplashAd) {
        sendEvent("splashAdRenderSuccess")
    }
    
    func splashAdRenderFail(_ splashAd: BUSplashAd, error: BUAdError?) {
        sendEvent("onSplashRenderFail")
        splashEnd(false)
    }
    
    func splashAdWillShow(_ splashAd: BUSplashAd) {
        sendEvent("onAdShow")
        
        GCDTool.gcdCancel(closeAdTimer)
        // 6s后自动跳过广告
        skipAdTimer = GCDTool.gcdDelay(6) {
            self.splashEnd(true)
        }
    }
    
    func splashAdDidShow(_ splashAd: BUSplashAd) {
        // sendEvent("onAdShow")
    }
    
    func splashAdViewControllerDidClose(_ splashAd: BUSplashAd) {
    }
    
    func splashVideoAdDidPlayFinish(_ splashAd: BUSplashAd, didFailWithError error: Error?) {
        
    }
    
    func splashAdDidClick(_ splashAd: BUSplashAd) {
        sendEvent("onAdClicked")
    }
    
    func splashAdDidClose(_ splashAd: BUSplashAd, closeType: BUSplashAdCloseType) {
        sendEvent("onSplashAdClose")
        splashEnd(true)
    }
    
    func splashDidCloseOtherController(_ splashAd: BUSplashAd, interactionType: BUInteractionType) {
        
    }
    
    // 广告结束
    func splashEnd(_ res: Bool) {
        GCDTool.gcdCancel(closeAdTimer)
        GCDTool.gcdCancel(skipAdTimer)
        
        if (!ended) {
            ended = true
            sendEvent("onAdEnd")
            result(res)
            splashAd?.mediation?.destoryAd()
        }
    }

}
