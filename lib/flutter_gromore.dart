import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gromore/callback/gromore_base_callback.dart';
import 'package:flutter_gromore/callback/gromore_interstitial_callback.dart';
import 'package:flutter_gromore/callback/gromore_method_channel_handler.dart';
import 'package:flutter_gromore/callback/gromore_splash_callback.dart';
import 'package:flutter_gromore/config/gromore_feed_config.dart';
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

  /// 申请ATT权限
  /// 以往广告归因依赖于IDFA。从iOS 14开始，只有在获得用户明确许可的前提下，应用才可以访问用户的IDFA数据并向用户投放定向广告。在应用程序调用 App Tracking Transparency 框架向最终用户提出应用程序跟踪授权请求之前，IDFA将不可用。如果某个应用未提出此请求，则读取到的IDFA将返回全为0的字符串，这个可能会导致广告收入降低。
  /// 需要在App层级的info.plist里添加ATT权限描述
  static Future<void> requestATT() async {
    if (Platform.isAndroid) {
      return;
    }
    await _methodChannel.invokeMethod("requestATT");
  }

  /// event类事件监听
  static void _handleEventListener() {
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
    _handleEventListener();
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
          "${FlutterGromoreConstants.interstitialTypeId}/${config.id}",
          callback);
    }

    await _methodChannel.invokeMethod("showInterstitialAd", config.toJson());
  }

  /// 加载信息流广告
  static Future<List<String>> loadFeedAd(GromoreFeedConfig config) async {
    assert(isInit);

    try {
      List result = await _methodChannel.invokeMethod("loadFeedAd", config.toJson());
      return List<String>.from(result);
    } catch(err) {
      return [];
    }
  }

  /// 加载信息流广告
  static Future<void> removeFeedAd(String feedId) async {
    assert(isInit);

    await _methodChannel.invokeMethod("removeFeedAd", {
      "feedId": feedId
    });
  }
}
