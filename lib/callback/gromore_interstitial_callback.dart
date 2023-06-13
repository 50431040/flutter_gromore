import 'package:flutter_gromore/callback/gromore_base_callback.dart';
import 'package:flutter_gromore/types.dart';

class GromoreInterstitialCallback extends GromoreBaseAdCallback {
  /// 广告展示
  final GromoreVoidCallback? onInterstitialShow;

  /// 展示失败
  final GromoreVoidCallback? onInterstitialShowFail;

  /// 广告被点击
  final GromoreVoidCallback? onInterstitialAdClick;

  /// 广告关闭
  final GromoreVoidCallback? onInterstitialClosed;

  GromoreInterstitialCallback({
    this.onInterstitialShow,
    this.onInterstitialShowFail,
    this.onInterstitialAdClick,
    this.onInterstitialClosed,
  });

  @override
  void exec(String callbackName, [arguments]) {
    if (callbackName == "onInterstitialShow" && onInterstitialShow != null) {
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
    }
  }
}
