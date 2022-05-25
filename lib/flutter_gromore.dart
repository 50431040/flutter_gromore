
import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gromore/callback/gromore_ad_callback.dart';
import 'package:flutter_gromore/config/splash.dart';
import 'package:flutter_gromore/callback/gromore_splash_callback.dart';
import 'package:flutter_gromore/constants/channel.dart';

class FlutterGromore {
  static const MethodChannel _methodChannel = MethodChannel(methodChannelName);
  static const EventChannel _eventChannel = EventChannel(eventChannelName);

  // 事件中心，存储事件
  static Map<String, GromoreAdCallback> eventCenter = {};

  /// 权限申请
  /// 同时请求：READ_PHONE_STATE, COARSE_LOCATION, FINE_LOCATION, WRITE_EXTERNAL_STORAGE权限
  static Future<void> requestPermissionIfNecessary() async {

    if (Platform.isIOS) {
      return;
    }
    await _methodChannel.invokeMethod("requestPermissionIfNecessary");

  }

  static void _handleEventListenter() {
    _eventChannel.receiveBroadcastStream().listen((event) {
      debugPrint(event.toString());
      String? id = event["id"] as String?;
      if (id != null && id.isNotEmpty && eventCenter[id] != null) {

        /// 开屏广告事件
        if (eventCenter[id] is GromoreSplashCallback) {
          GromoreSplashCallback callback = (eventCenter[id] as GromoreSplashCallback);
          callback.exec(event["name"]);
        }
      }
    });
  }

  /// 初始化SDK
  static Future<void> initSDK({ required String appId, required String appName, required bool debug }) async {
    await _methodChannel.invokeMethod("initSDK", {
      "appId": appId,
      "appName": appName,
      "debug": debug
    });

    _handleEventListenter();
  }

  /// 展示开屏广告
  static Future<void> showSplash({ required GromoreSplashConfig config, required GromoreAdCallback callback }) async {
    Map params = config.toJson();
    params.removeWhere((key, value) => value == null);
    debugPrint("showSplash ${config.id}");

    eventCenter[config.id] = callback;

    await _methodChannel.invokeMethod("showSplash", params);
  }
}
