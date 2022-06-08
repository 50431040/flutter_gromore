//
//  FlutterGromoreSplash.swift
//  flutter_gromore
//
//  Created by Anand on 2022/5/31.
//

import ABUAdSDK

class FlutterGromoreSplash: UIView, ABUSplashAdDelegate {
    private var eventId: String?
    private var splashAd: ABUSplashAd?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(_ args: [String: Any]) {
        eventId = args["id"] as? String
        super.init(frame: CGRect())
        initAd(args: args)
    }
    
    /// 初始化广告
    private func initAd(args: [String: Any]) {
        // 配置开屏广告
        splashAd = ABUSplashAd(adUnitID: args["adUnitId"] as! String)
        splashAd?.delegate = self
        splashAd?.rootViewController = Utils.getVC()
        splashAd?.tolerateTimeout = TimeInterval(args["timeout"] as? Int ?? 3)
        splashAd?.splashButtonType = ABUSplashButtonType(rawValue: args["buttonType"] as? Int ?? 1)!
        // 展示 logo
        let logo: String = args["logo"] as? String ?? ""
        if !logo.isEmpty {
            splashAd?.customBottomView = generateLogoContainer(name: logo)
        }
        // 加载开屏广告
        splashAd?.loadData()
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
    
    /// 开屏广告加载完成
    func splashAdDidLoad(_ splashAd: ABUSplashAd) {
        sendEvent("onSplashAdLoadSuccess")
        splashAd.show(in: UIApplication.shared.keyWindow!)
    }
    
    /// 开屏广告加载失败
    func splashAd(_ splashAd: ABUSplashAd, didFailWithError error: Error?) {
        sendEvent("onSplashAdLoadFail")
        sendEvent("onAdEnd")
    }
    
    /// 开屏广告关闭
    func splashAdDidClose(_ splashAd: ABUSplashAd) {
        sendEvent("onAdEnd")
        splashAd.destoryAd()
    }
    
    /// 开屏广告即将展示
    func splashAdWillVisible(_ splashAd: ABUSplashAd) {
        sendEvent("onAdShow")
    }
    
    /// 开屏广告显示失败
    func splashAdDidShowFailed(_ splashAd: ABUSplashAd, error: Error) {
        sendEvent("onAdShowFail")
        sendEvent("onAdEnd")
    }
    
    ///点击了开屏广告
    func splashAdDidClick(_ splashAd: ABUSplashAd) {
        sendEvent("onAdClicked")
    }
    
    /// 开屏广告倒计时结束
    func splashAdCountdown(toZero splashAd: ABUSplashAd) {
        sendEvent("onAdDismiss")
    }
    
    // TODO: 安卓端还有 onAdLoadTimeout、onAdSkip
}
