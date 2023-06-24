import 'package:flutter_gromore/callback/gromore_base_callback.dart';
import 'package:flutter_gromore/types.dart';

/// banner广告回调
class GromoreBannerCallback extends GromoreBaseAdCallback {
  /// banner广告点击
  final GromoreVoidCallback? onAdClick;

  /// banner广告展示
  final GromoreVoidCallback? onAdShow;

  /// 模板渲染失败
  final GromoreVoidCallback? onRenderFail;

  /// 模板渲染成功
  final GromoreFeedRenderCallback? onRenderSuccess;

  /// 用户选择不喜欢原因
  final GromoreVoidCallback? onSelected;

  /// 取消选择
  final GromoreVoidCallback? onCancel;

  /// 拒绝弹框显示
  final GromoreVoidCallback? onShow;

  /// 进程被终止
  final GromoreVoidCallback? onAdTerminate;

  GromoreBannerCallback({
    this.onAdClick,
    this.onAdShow,
    this.onRenderFail,
    this.onRenderSuccess,
    this.onSelected,
    this.onCancel,
    this.onShow,
    this.onAdTerminate,
  });

  /// 执行回调
  @override
  void exec(String callbackName, [dynamic arguments]) {
    if (callbackName == "onAdClick") {
      onAdClick?.call();
    } else if (callbackName == "onAdShow") {
      onAdShow?.call();
    } else if (callbackName == "onRenderFail") {
      onRenderFail?.call();
    } else if (callbackName == "onRenderSuccess" && onRenderSuccess != null) {
      onRenderSuccess!(arguments["height"] as double);
    } else if (callbackName == "onSelected") {
      onSelected?.call();
    } else if (callbackName == "onCancel") {
      onCancel?.call();
    } else if (callbackName == "onShow") {
      onShow?.call();
    } else if (callbackName == "onAdTerminate") {
      onAdTerminate?.call();
    }
  }
}
