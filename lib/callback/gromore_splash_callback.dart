import 'package:flutter_gromore/callback/gromore_base_callback.dart';
import 'package:flutter_gromore/types.dart';

/// 开屏广告回调
class GromoreSplashCallback extends GromoreBaseAdCallback {
  /// 广告被点击
  final GromoreVoidCallback? onAdClicked;

  /// 展示成功
  final GromoreVoidCallback? onAdShow;

  /// 加载失败
  final GromoreVoidCallback? onSplashAdLoadFail;

  /// 加载成功
  final GromoreVoidCallback? onSplashAdLoadSuccess;

  /// 渲染成功
  final GromoreVoidCallback? onSplashRenderSuccess;

  /// 渲染失败
  final GromoreVoidCallback? onSplashRenderFail;

  /// 关闭
  final GromoreVoidCallback? onSplashAdClose;

  /// 开屏广告结束，这个时候会销毁广告（点击跳过、倒计时结束或渲染错误等 理应隐藏广告 的情况都会触发此回调，建议统一在此回调处理路由跳转等逻辑）
  final GromoreVoidCallback? onAdEnd;

  /// 触发开屏广告自动关闭（由于存在异常场景，导致广告无法正常展示，但无相关回调）
  final GromoreVoidCallback? onAutoClose;

  /// 触发开屏广告自动跳过（由于存在部分场景，导致广告无法跳过）
  final GromoreVoidCallback? onAutoSkip;

  GromoreSplashCallback(
      {this.onAdClicked,
      this.onAdShow,
      this.onSplashAdLoadFail,
      this.onSplashAdLoadSuccess,
      this.onSplashRenderSuccess,
      this.onSplashRenderFail,
      this.onSplashAdClose,
      this.onAdEnd,
      this.onAutoClose,
      this.onAutoSkip})
      : super();

  /// 执行回调
  @override
  void exec(String callbackName, [dynamic arguments]) {
    if (callbackName == "onAdClicked") {
      onAdClicked?.call();
    } else if (callbackName == "onAdShow") {
      onAdShow?.call();
    } else if (callbackName == "onSplashAdLoadFail") {
      onSplashAdLoadFail?.call();
    } else if (callbackName == "onSplashAdLoadSuccess") {
      onSplashAdLoadSuccess?.call();
    } else if (callbackName == "onSplashRenderSuccess") {
      onSplashAdLoadFail?.call();
    } else if (callbackName == "onSplashRenderFail") {
      onSplashAdLoadSuccess?.call();
    } else if (callbackName == "onAdEnd") {
      onAdEnd?.call();
    } else if (callbackName == "onAutoClose") {
      onAutoClose?.call();
    } else if (callbackName == "onAutoSkip") {
      onAutoSkip?.call();
    }
  }
}
