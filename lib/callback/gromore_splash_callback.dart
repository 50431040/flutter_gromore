import 'package:flutter_gromore/callback/gromore_ad_callback.dart';
import 'package:flutter_gromore/types.dart';

class GromoreSplashCallback extends GromoreAdCallback {
  /// 广告被点击，肯定有回调
  final GromoreVoidCallback? onAdClicked;

  /// Splash广告的展示回调,如果是优量汇（GDT）的广告 ,对应的是优量汇的onADExposure（）回调
  final GromoreVoidCallback? onAdShow;

  /// show失败回调。如果show时发现无可用广告（比如广告过期），会触发该回调。开发者应该在该回调里进行重新请求。
  final GromoreVoidCallback? onAdShowFail;

  /// 点击跳过时回调
  final GromoreVoidCallback? onAdSkip;

  /// 广告播放时间结束时调用。 此时一般需要跳过开屏的 Activity，进入应用内容页面
  final GromoreVoidCallback? onAdDismiss;

  /// 开屏广告加载失败
  final GromoreVoidCallback? onSplashAdLoadFail;

  /// 开屏广告加载成功，此时会展示广告
  final GromoreVoidCallback? onSplashAdLoadSuccess;

  /// 开屏广告加载超时
  final GromoreVoidCallback? onAdLoadTimeout;

  /// 开屏广告结束，这个时候会销毁广告
  final GromoreVoidCallback? onAdEnd;

  GromoreSplashCallback({this.onAdClicked,
    this.onAdShowFail,
    this.onAdSkip,
    this.onAdDismiss,
    this.onSplashAdLoadFail,
    this.onSplashAdLoadSuccess,
    this.onAdLoadTimeout,
    this.onAdEnd,
    this.onAdShow}) : super();
  
  void exec(String callbackName) {
    if (callbackName == "onAdClicked" && onAdClicked != null) {
      onAdClicked!();
    } else if (callbackName == "onAdShow" && onAdShow != null) {
      onAdShow!();
    } else if (callbackName == "onAdShowFail" && onAdShowFail != null) {
      onAdShowFail!();
    } else if (callbackName == "onAdSkip" && onAdSkip != null) {
      onAdSkip!();
    } else if (callbackName == "onAdDismiss" && onAdDismiss != null) {
      onAdDismiss!();
    } else if (callbackName == "onSplashAdLoadFail" && onSplashAdLoadFail != null) {
      onSplashAdLoadFail!();
    } else if (callbackName == "onSplashAdLoadSuccess" && onSplashAdLoadSuccess != null) {
      onSplashAdLoadSuccess!();
    } else if (callbackName == "onAdLoadTimeout" && onAdLoadTimeout != null) {
      onAdLoadTimeout!();
    } else if (callbackName == "onAdEnd" && onAdEnd != null) {
      onAdEnd!();
    }
  }
}
