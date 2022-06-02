import 'package:flutter_gromore/callback/gromore_base_callback.dart';
import 'package:flutter_gromore/types.dart';

class GromoreInterstitialCallback extends GromoreBaseAdCallback {
  /// 广告加载失败
  final GromoreVoidCallback? onInterstitialLoadFail;

  /// 广告加载成功
  final GromoreVoidCallback? onInterstitialLoad;

  /// 广告展示
  final GromoreVoidCallback? onInterstitialShow;

  /// 如果show时发现无可用广告（比如广告过期或者isReady=false），会触发该回调。 开发者应该在该回调里进行重新请求。
  final GromoreVoidCallback? onInterstitialShowFail;

  /// 广告被点击
  final GromoreVoidCallback? onInterstitialAdClick;

  /// 广告关闭
  final GromoreVoidCallback? onInterstitialClosed;

  /// 当广告打开浮层时调用，如打开内置浏览器、内容展示浮层，一般发生在点击之后,常常在onAdLeftApplication之前调用，并非百分百回调，优量汇sdk支持，穿山甲SDK、baidu SDK、mintegral SDK、admob sdk暂时不支持
  final GromoreVoidCallback? onAdOpened;

  /// 此方法会在用户点击打开其他应用（例如 Google Play）时于 onAdOpened() 之后调用，从而在后台运行当前应用。并非百分百回调，优量汇sdk和admob sdk支持，穿山甲SDK、baidu SDK、mintegral SDK暂时不支持
  final GromoreVoidCallback? onAdLeftApplication;

  GromoreInterstitialCallback(
      {this.onInterstitialLoadFail,
      this.onInterstitialLoad,
      this.onInterstitialShow,
      this.onInterstitialShowFail,
      this.onInterstitialAdClick,
      this.onInterstitialClosed,
      this.onAdOpened,
      this.onAdLeftApplication});

  @override
  void exec(String callbackName, [arguments]) {
    if (callbackName == "onInterstitialLoadFail" &&
        onInterstitialLoadFail != null) {
      onInterstitialLoadFail!();
    } else if (callbackName == "onInterstitialLoad" &&
        onInterstitialLoad != null) {
      onInterstitialLoad!();
    } else if (callbackName == "onInterstitialShow" &&
        onInterstitialShow != null) {
      onInterstitialShow!();
    } else if (callbackName == "onInterstitialShowFail" &&
        onInterstitialShowFail != null) {
      onInterstitialShowFail!();
    } else if (callbackName == "onInterstitialAdClick" &&
        onInterstitialAdClick != null) {
      onInterstitialAdClick!();
    } else if (callbackName == "onInterstitialClosed" &&
        onInterstitialClosed != null) {
      onInterstitialClosed!();
    } else if (callbackName == "onAdOpened" && onAdOpened != null) {
      onAdOpened!();
    } else if (callbackName == "onAdLeftApplication" &&
        onAdLeftApplication != null) {
      onAdLeftApplication!();
    }
  }
}
