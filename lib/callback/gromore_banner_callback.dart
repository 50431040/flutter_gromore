import 'package:flutter_gromore/callback/gromore_base_callback.dart';
import 'package:flutter_gromore/types.dart';

/// banner广告回调
class GromoreBannerCallback extends GromoreBaseAdCallback {
  /// banner广告点击
  final GromoreVoidCallback? onAdClick;

  /// banner广告展示，仅Android可用
  final GromoreVoidCallback? onAdShow;

  /// 模板渲染失败
  final GromoreVoidCallback? onRenderFail;

  /// 模板渲染成功
  final GromoreVoidCallback? onRenderSuccess;

  /// 用户选择不喜欢原因
  final GromoreVoidCallback? onSelected;

  /// 进程被终止，仅iOS可用
  final GromoreVoidCallback? onAdTerminate;

  /// 加载失败
  final GromoreVoidCallback? onLoadError;

  GromoreBannerCallback({
    this.onAdClick,
    this.onAdShow,
    this.onRenderFail,
    this.onRenderSuccess,
    this.onSelected,
    this.onAdTerminate,
    this.onLoadError,
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
    } else if (callbackName == "onRenderSuccess") {
      onRenderSuccess?.call();
    } else if (callbackName == "onSelected") {
      onSelected?.call();
    } else if (callbackName == "onAdTerminate") {
      onAdTerminate?.call();
    } else if (callbackName == "onLoadError") {
      onLoadError?.call();
    }
  }
}
