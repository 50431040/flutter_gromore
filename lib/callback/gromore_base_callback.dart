/// 事件回调基类
abstract class GromoreBaseAdCallback {
  /// 针对不同事件的处理
  void exec(String callbackName, [dynamic arguments]);
}