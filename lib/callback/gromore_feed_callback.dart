import 'package:flutter_gromore/callback/gromore_base_callback.dart';
import 'package:flutter_gromore/types.dart';

/// 信息流广告回调
class GromoreFeedCallback extends GromoreBaseAdCallback {
  /// 信息流广告点击
  final GromoreVoidCallback? onAdClick;

  /// 信息流广告展示
  final GromoreVoidCallback? onAdShow;

  /// 模板渲染失败
  final GromoreVoidCallback? onRenderFail;

  /// 模板渲染成功
  final GromoreFeedRenderCallback? onRenderSuccess;

  /// 用户选择不喜欢原因
  final GromoreVoidCallback? onSelected;

  /// 取消选择
  final GromoreVoidCallback? onCancel;

  /// 拒绝填写原因
  final GromoreVoidCallback? onRefuse;

  /// 拒绝弹框显示
  final GromoreVoidCallback? onShow;

  /// 拉取广告成功
  final GromoreVoidCallback? onAdLoaded;

  /// 拉取广告失败
  final GromoreVoidCallback? onAdLoadedFail;

  /// 配置加载成功
  final GromoreVoidCallback? configLoad;

  GromoreFeedCallback(
      {this.onAdClick,
      this.onAdShow,
      this.onRenderFail,
      this.onRenderSuccess,
      this.onSelected,
      this.onCancel,
      this.onRefuse,
      this.onShow,
      this.onAdLoaded,
      this.onAdLoadedFail,
      this.configLoad});

  /// 执行回调
  @override
  void exec(String callbackName, [dynamic arguments]) {
    if (callbackName == "onAdClick" && onAdClick != null) {
      onAdClick!();
    } else if (callbackName == "onAdShow" && onAdShow != null) {
      onAdShow!();
    } else if (callbackName == "onRenderFail" && onRenderFail != null) {
      onRenderFail!();
    } else if (callbackName == "onRenderSuccess" && onRenderSuccess != null) {
      onRenderSuccess!(arguments["height"]);
    } else if (callbackName == "onSelected" && onSelected != null) {
      onSelected!();
    } else if (callbackName == "onCancel" && onCancel != null) {
      onCancel!();
    } else if (callbackName == "onRefuse" && onRefuse != null) {
      onRefuse!();
    } else if (callbackName == "onShow" && onShow != null) {
      onShow!();
    } else if (callbackName == "onAdLoaded" && onAdLoaded != null) {
      onAdLoaded!();
    } else if (callbackName == "onAdLoadedFail" && onAdLoadedFail != null) {
      onAdLoadedFail!();
    } else if (callbackName == "configLoad" && configLoad != null) {
      configLoad!();
    }
  }
}
