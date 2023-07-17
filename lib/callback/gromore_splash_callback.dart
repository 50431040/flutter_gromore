import 'package:flutter_gromore/callback/gromore_base_callback.dart';
import 'package:flutter_gromore/types.dart';

/// 开屏广告回调
class GromoreSplashCallback extends GromoreBaseAdCallback {
  /// 广告被点击
  final GromoreVoidCallback? onAdClicked;

  /// 展示成功
  final GromoreVoidCallback? onAdShow;

  /// 展示失败，仅Android可用
  final GromoreVoidCallback? onAdShowFail;

  /// 点击跳过，仅Android可用
  final GromoreVoidCallback? onAdSkip;

  /// 倒计时结束，仅Android可用
  final GromoreVoidCallback? onAdDismiss;

  /// 加载失败
  final GromoreVoidCallback? onSplashAdLoadFail;

  /// 加载成功，此时会展示广告
  final GromoreVoidCallback? onSplashAdLoadSuccess;

  /// 加载超时，仅Android可用
  final GromoreVoidCallback? onAdLoadTimeout;

  /// 开屏广告结束，这个时候会销毁广告（点击跳过、倒计时结束或渲染错误等 理应隐藏广告 的情况都会触发此回调，建议统一在此回调处理路由跳转等逻辑）
  final GromoreVoidCallback? onAdEnd;

  /// 触发开屏广告自动关闭（由于存在异常场景，导致广告无法正常展示，但无相关回调）
  final GromoreVoidCallback? onAutoClose;

  /// 触发开屏广告自动跳过（由于存在部分场景，导致广告无法跳过）
  final GromoreVoidCallback? onAutoSkip;

  GromoreSplashCallback(
      {this.onAdClicked,
      this.onAdShowFail,
      this.onAdSkip,
      this.onAdDismiss,
      this.onSplashAdLoadFail,
      this.onSplashAdLoadSuccess,
      this.onAdLoadTimeout,
      this.onAdEnd,
      this.onAdShow,
      this.onAutoClose,
      this.onAutoSkip})
      : super();

  /// 执行回调
  @override
  void exec(String callbackName, [dynamic arguments]) {
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
    } else if (callbackName == "onSplashAdLoadFail" &&
        onSplashAdLoadFail != null) {
      onSplashAdLoadFail!();
    } else if (callbackName == "onSplashAdLoadSuccess" &&
        onSplashAdLoadSuccess != null) {
      onSplashAdLoadSuccess!();
    } else if (callbackName == "onAdLoadTimeout" && onAdLoadTimeout != null) {
      onAdLoadTimeout!();
    } else if (callbackName == "onAdEnd" && onAdEnd != null) {
      onAdEnd!();
    } else if (callbackName == "onAutoClose" && onAutoClose != null) {
      onAutoClose!();
    } else if (callbackName == "onAutoSkip" && onAutoSkip != null) {
      onAutoSkip!();
    }
  }
}
