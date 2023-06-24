import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gromore/callback/gromore_base_callback.dart';
import 'package:flutter_gromore/callback/gromore_interstitial_callback.dart';
import 'package:flutter_gromore/callback/gromore_method_channel_handler.dart';
import 'package:flutter_gromore/callback/gromore_reward_callback.dart';
import 'package:flutter_gromore/callback/gromore_splash_callback.dart';
import 'package:flutter_gromore/config/gromore_banner_config.dart';
import 'package:flutter_gromore/config/gromore_feed_config.dart';
import 'package:flutter_gromore/config/gromore_interstitial_config.dart';
import 'package:flutter_gromore/config/gromore_reward_config.dart';
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
  @Deprecated("在2.0版本已废弃")
  static Future<void> requestPermissionIfNecessary() async {}

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
  static Future<bool> initSDK(
      {required String appId,
      required String appName,
      required bool debug,
      bool? useMediation}) async {

    try {
      await _methodChannel.invokeMethod("initSDK", {
        "appId": appId,
        "appName": appName,
        "debug": debug,
        "useMediation": useMediation ?? false
      });
      isInit = true;
      _handleEventListener();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// 展示开屏广告
  static Future<void> showSplashAd(
      {required GromoreSplashConfig config,
      required GromoreBaseAdCallback callback}) async {
    assert(isInit);

    config.generateId();
    _eventCenter[config.id!] = callback;

    await _methodChannel.invokeMethod("showSplashAd", config.toJson());
  }

  /// 加载插屏广告
  static Future<String> loadInterstitialAd(
      GromoreInterstitialConfig config) async {
    assert(isInit);

    try {
      String result = await _methodChannel.invokeMethod(
          "loadInterstitialAd", config.toJson());
      return result;
    } catch (err) {
      return "";
    }
  }

  /// 展示插屏广告
  static Future<void> showInterstitialAd(
      {required String interstitialId,
      GromoreInterstitialCallback? callback}) async {
    assert(isInit);

    if (callback != null) {
      GromoreMethodChannelHandler<GromoreInterstitialCallback>.register(
          "${FlutterGromoreConstants.interstitialTypeId}/$interstitialId",
          callback);
    }

    await _methodChannel
        .invokeMethod("showInterstitialAd", {"interstitialId": interstitialId});
  }

  /// 移除信息流广告
  static Future<void> removeInterstitialAd(String interstitialId) async {
    assert(isInit);

    await _methodChannel.invokeMethod(
        "removeInterstitialAd", {"interstitialId": interstitialId});
  }

  /// 加载信息流广告
  static Future<List<String>> loadFeedAd(GromoreFeedConfig config) async {
    assert(isInit);

    try {
      List result =
          await _methodChannel.invokeMethod("loadFeedAd", config.toJson());
      return List<String>.from(result);
    } catch (err) {
      debugPrint(err.toString());
      return [];
    }
  }

  /// 移除信息流广告
  static Future<void> removeFeedAd(String feedId) async {
    assert(isInit);

    await _methodChannel.invokeMethod("removeFeedAd", {"feedId": feedId});
  }

  /// 加载激励广告
  /// 加载失败会返回空字符串
  static Future<String> loadRewardAd(GromoreRewardConfig config) async {
    assert(isInit);

    try {
      String result =
          await _methodChannel.invokeMethod("loadRewardAd", config.toJson());
      return result;
    } catch (err) {
      return "";
    }
  }

  /// 展示激励广告
  /// 返回值表示是否展示成功
  /// 若需验证是否有效发放奖励，请在GromoreRewardCallback中传入onRewardVerify回调
  static Future<bool> showRewardAd(
      {required String rewardId, GromoreRewardCallback? callback}) async {
    assert(isInit);

    assert(rewardId.isNotEmpty);

    try {
      if (callback != null) {
        GromoreMethodChannelHandler<GromoreRewardCallback>.register(
            "${FlutterGromoreConstants.rewardTypeId}/$rewardId", callback);
      }

      return await _methodChannel
          .invokeMethod("showRewardAd", {"rewardId": rewardId});
    } catch (_) {
      return false;
    }
  }
}
