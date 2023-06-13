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

  /// 拒绝弹框显示
  final GromoreVoidCallback? onShow;

  /// 进程被终止
  final GromoreVoidCallback? onAdTerminate;

  GromoreFeedCallback({
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
    } else if (callbackName == "onShow" && onShow != null) {
      onShow!();
    } else if (callbackName == "onAdTerminate" && onAdTerminate != null) {
      onAdTerminate!();
    }
  }
}
