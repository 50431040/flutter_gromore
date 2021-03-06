import Flutter
import UIKit
import AppTrackingTransparency
import ABUAdSDK

public class SwiftFlutterGromorePlugin: NSObject, FlutterPlugin {
    private static var messenger: FlutterBinaryMessenger? = nil
    private var splashAd: FlutterGromoreSplash?
    private var feedManager: FlutterGromoreFeedManager?
    private var interstitialManager: FlutterGromoreInterstitialManager?
    private var interstitialFullAd: FlutterGromoreInterstitial?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: FlutterGromoreContants.methodChannelName, binaryMessenger: registrar.messenger())
        let eventChanel = FlutterEventChannel(name: FlutterGromoreContants.eventChannelName, binaryMessenger: registrar.messenger())
        eventChanel.setStreamHandler(AdEventHandler.instance)
        let instance = SwiftFlutterGromorePlugin()
        
        messenger = registrar.messenger()
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.register(FlutterGromoreFactory(messenger: registrar.messenger()), withId: FlutterGromoreContants.feedViewTypeId)
        
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? Dictionary<String, Any> ?? [:]
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        case "requestATT":
            requestATT(result: result)
        case "initSDK":
            initSDK(appId: args["appId"] as! String,result: result)
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
            feedManager = FlutterGromoreFeedManager(args: args, result: result)
            feedManager?.loadAd()
        case "removeFeedAd":
            removeFeedAd(args: args, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // ?????????????????????
    private func requestATT(result: @escaping FlutterResult){
        // iOS 14 ?????????????????? ATT ????????????
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                let isAuthorized: Bool = status == ATTrackingManager.AuthorizationStatus.authorized
                result(isAuthorized)
            })
        } else {
            result(true)
        }
    }
    
    // ?????????SDK
    private func initSDK(appId: String, result: @escaping FlutterResult) {
        ABUAdSDKManager.setupSDK(withAppId: appId) { ABUUserConfig in
            ABUUserConfig.logEnable = true
            return ABUUserConfig
        }
        result(true)
    }
    
    /// ??????????????????????????????
    private func removeFeedAd(args: [String: Any], result: @escaping FlutterResult) {
        if let feedId = args["feedId"] as? String {
            FlutterGromoreFeedCache.removeAd(key: feedId)
        }
        result(true)
    }
    
    /// ???????????????????????????
    private func removeInterstitialAd(args: [String: Any], result: @escaping FlutterResult) {
        if let interstitialId = args["interstitialId"] as? String {
            FlutterGromoreInterstitialCache.removeAd(key: interstitialId)
        }
        result(true)
    }
}
