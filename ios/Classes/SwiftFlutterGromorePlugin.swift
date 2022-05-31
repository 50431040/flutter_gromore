import Flutter
import UIKit
import AppTrackingTransparency
import ABUAdSDK

public class SwiftFlutterGromorePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_gromore", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterGromorePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }
  
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as? Dictionary<String,Any>
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "requestIDFA":
      requestIDFA(result: result)
    case "initSDK":
      initSDK(appId: args!["appId"] as! String,result: result)
    case "showSplashAd":
      showSplashAd(config: args!["config"] as! Dictionary<String, Any>)
    case "showInterstitialAd":
      print("showInterstitialAd")
    default:
      result(FlutterMethodNotImplemented)
    }
  }
  
  // 请求广告标识符
  private func requestIDFA(result: @escaping FlutterResult){
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
  private func initSDK(appId: String, result: @escaping FlutterResult){
    ABUAdSDKManager.setupSDK(withAppId: appId) { ABUUserConfig in
      ABUUserConfig.logEnable = true
      return ABUUserConfig
    }
    result(true)
  }
  
  private func showSplashAd(config: Dictionary<String, Any>){
//    FlutterGromoreSplash().initAd(config: config)
  }
}

