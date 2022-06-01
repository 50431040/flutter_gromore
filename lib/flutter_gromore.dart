import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gromore/callback/gromore_base_callback.dart';
import 'package:flutter_gromore/callback/gromore_interstitial_callback.dart';
import 'package:flutter_gromore/callback/gromore_method_channel_handler.dart';
import 'package:flutter_gromore/callback/gromore_splash_callback.dart';
import 'package:flutter_gromore/config/gromore_interstitial_config.dart';
import 'package:flutter_gromore/config/gromore_splash_config.dart';
import 'package:flutter_gromore/constants/gromore_constans.dart';

class FlutterGromore {
  /// channel
  static const MethodChannel _methodChannel =
      MethodChannel(FlutterGromoreConstants.methodChannelName);
  static const EventChannel _eventChannel =
      EventChannel(FlutterGromoreConstants.eventChannelName);

  /// 事件中心，存储事件
  static final Map<String, GromoreBaseAdCallback> _eventCenter = {};

  /// SDK是否初始化
  static bool isInit = false;

  /// 权限申请
  /// 同时请求：READ_PHONE_STATE, COARSE_LOCATION, FINE_LOCATION, WRITE_EXTERNAL_STORAGE权限
  static Future<void> requestPermissionIfNecessary() async {
    if (Platform.isIOS) {
      return;
    }
    await _methodChannel.invokeMethod("requestPermissionIfNecessary");
  }

  /// event类事件监听
  static void _handleEventListenter() {
    _eventChannel.receiveBroadcastStream().listen((event) {
      debugPrint(event.toString());
      String? id = event["id"] as String?;
      if (id != null && id.isNotEmpty && _eventCenter[id] != null) {
        /// 开屏广告事件
        if (_eventCenter[id] is GromoreSplashCallback) {
          GromoreSplashCallback callback =
              (_eventCenter[id] as GromoreSplashCallback);
          callback.exec(event["name"]);
        }
      }
    });
  }

  /// 初始化SDK
  static Future<void> initSDK(
      {required String appId,
      required String appName,
      required bool debug}) async {
    if (isInit) {
      return;
    }

    await _methodChannel.invokeMethod(
        "initSDK", {"appId": appId, "appName": appName, "debug": debug});

    isInit = true;
    print("========== initSDK =========");
    // _handleEventListenter();
  }

  /// 展示开屏广告
  static Future<void> showSplashAd(
      {required GromoreSplashConfig config,
      required GromoreBaseAdCallback callback}) async {
    assert(isInit);

    config.generateId();
    debugPrint("showSplash ${config.id}");
    _eventCenter[config.id!] = callback;

    await _methodChannel.invokeMethod("showSplashAd", config.toJson());
  }

  /// 展示插屏广告
  static Future<void> showInterstitialAd(
      {required GromoreInterstitialConfig config,
      GromoreInterstitialCallback? callback}) async {
    assert(isInit);

    config.generateId();

    if (callback != null) {
      GromoreMethodChannelHandler<GromoreInterstitialCallback>.register(
          "${FlutterGromoreConstants.interstitialTypeId}/${config.id}", callback);
    }

    await _methodChannel.invokeMethod("showInterstitialAd", config.toJson());
  }
}
