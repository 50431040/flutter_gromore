import Flutter
import UIKit
import AppTrackingTransparency
import BUAdSDK

public class SwiftFlutterGromorePlugin: NSObject, FlutterPlugin {
    private static var messenger: FlutterBinaryMessenger? = nil
    private var splashAd: FlutterGromoreSplash?
    private var interstitialManager: FlutterGromoreInterstitialManager?
    private var rewardManager: FlutterGromoreRewardManager?
    private var interstitialFullAd: FlutterGromoreInterstitial?
    private var rewardAd: FlutterGromoreReward?
    private var initResuleCalled: Bool = false
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: FlutterGromoreContants.methodChannelName, binaryMessenger: registrar.messenger())
        let eventChanel = FlutterEventChannel(name: FlutterGromoreContants.eventChannelName, binaryMessenger: registrar.messenger())
        eventChanel.setStreamHandler(AdEventHandler.instance)
        let instance = SwiftFlutterGromorePlugin()
        
        messenger = registrar.messenger()
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.register(FlutterGromoreFactory(messenger: registrar.messenger()), withId: FlutterGromoreContants.feedViewTypeId)
        registrar.register(FlutterGromoreBannerFactory(messenger: registrar.messenger()), withId: FlutterGromoreContants.bannerTypeId)
        
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? Dictionary<String, Any> ?? [:]
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        case "requestATT":
            requestATT(result: result)
        case "initSDK":
            initSDK(appId: args["appId"] as! String, result: result, debug: args["debug"] as? Bool ?? true, useMediation: args["useMediation"] as? Bool ?? false)
        case "showSplashAd":
            splashAd = FlutterGromoreSplash(args: args, result: result)
        case "loadInterstitialAd":
            interstitialManager = FlutterGromoreInterstitialManager(args: args, result: result)
            interstitialManager?.loadAd()
        case "showInterstitialAd":
            interstitialFullAd = FlutterGromoreInterstitial(messenger: SwiftFlutterGromorePlugin.messenger!, arguments: args, result: result)
        case "removeInterstitialAd":
            removeInterstitialAd(args: args, result: result)
        case "loadFeedAd":
            let feedManager = FlutterGromoreFeedManager(args: args, result: result)
            feedManager.loadAd()
        case "removeFeedAd":
            removeFeedAd(args: args, result: result)
        case "loadRewardAd":
            rewardManager = FlutterGromoreRewardManager(args: args, result: result)
            rewardManager?.loadAd()
        case "showRewardAd":
            rewardAd = FlutterGromoreReward(messenger: SwiftFlutterGromorePlugin.messenger!, arguments: args, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // 请求广告标识符
    private func requestATT(result: @escaping FlutterResult){
        // iOS 14 之后需要获取 ATT 追踪权限
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                let isAuthorized: Bool = status == ATTrackingManager.AuthorizationStatus.authorized
                result(isAuthorized)
            })
        } else {
            result(true)
        }
    }
    
    // 初始化SDK
    private func initSDK(appId: String, result: @escaping FlutterResult, debug: Bool, useMediation: Bool) {
        
        // 已经初始化
        if (BUAdSDKManager.initializationState == BUAdSDKInitializationState.ready) {
            result(true)
            return
        }
        
        let config = BUAdSDKConfiguration()
        config.appID = appId
        config.debugLog = debug ? 1 : 0
        config.useMediation = useMediation
        config.territory = BUAdSDKTerritory.CN
        
        BUAdSDKManager.start(asyncCompletionHandler: {success, error in
            // 已经回调
            if (self.initResuleCalled) {
                return
            }
            if success {
                self.initResuleCalled = true
                result(true)
            } else {
                self.initResuleCalled = true
                result(FlutterError(code: "0", message: error?.localizedDescription ?? "", details: error?.localizedDescription ?? ""))
            }
        })
    }
    
    /// 移除缓存中信息流广告
    private func removeFeedAd(args: [String: Any], result: @escaping FlutterResult) {
        if let feedId = args["feedId"] as? String {
            FlutterGromoreFeedCache.removeAd(key: feedId)
        }
        result(true)
    }
    
    /// 移除缓存中插屏广告
    private func removeInterstitialAd(args: [String: Any], result: @escaping FlutterResult) {
        if let interstitialId = args["interstitialId"] as? String {
            FlutterGromoreInterstitialCache.removeAd(key: interstitialId)
        }
        result(true)
    }
}
