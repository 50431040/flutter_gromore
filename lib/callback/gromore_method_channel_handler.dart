import 'package:flutter/services.dart';
import 'package:flutter_gromore/callback/gromore_base_callback.dart';

/// 处理Dart端接收到的广告事件
/// T 继承自事件回调基类
class GromoreMethodChannelHandler<T extends GromoreBaseAdCallback> {
  final MethodChannel _channel;
  final T _callback;

  GromoreMethodChannelHandler(String channelName, this._callback)
      : _channel = MethodChannel(channelName) {
    // 注册事件回调
    _channel.setMethodCallHandler(_onMethodCall);
    print("====== GromoreMethodChannelHandler register $channelName =====");
  }

  GromoreMethodChannelHandler.register(String channelName, T callback)
      : this(channelName, callback);

  Future<dynamic> _onMethodCall(MethodCall call) async {
    _callback.exec(call.method, call.arguments);
  }
}
