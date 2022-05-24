
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class FlutterGromore {
  static const MethodChannel _methodChannel = MethodChannel("flutter_gromore");
  static const EventChannel _eventChannel = EventChannel("flutter_gromore_event");

  /// 权限申请
  /// 同时请求：READ_PHONE_STATE, COARSE_LOCATION, FINE_LOCATION, WRITE_EXTERNAL_STORAGE权限
  static Future<void> requestPermissionIfNecessary() async {

    if (Platform.isIOS) {
      return;
    }
    await _methodChannel.invokeMethod("requestPermissionIfNecessary");

  }

  /// 初始化SDK
  static Future<void> initSDK({ required String appId, required String appName, required bool debug }) async {
    await _methodChannel.invokeMethod("initSDK", {
      "appId": appId,
      "appName": appName,
      "debug": debug
    });
  }

  /// 展示开屏广告
  /// logo：如果传入了logo则会在底部显示logo，logo放在android/app/src/main/res/mipmap下，值不需要文件后缀
  /// muted：静音
  /// preload：预加载
  /// volume：声音配置，与muted配合使用
  /// timeout：超时时间，默认3000ms
  /// buttonType：按钮样式（1：全屏可点击，2：仅按钮可点击，默认为1）
  /// downloadType：点击下载样式（0或者1，默认为1）
  static Future<void> showSplash({ required String adUnitId, String? logo, bool? muted, bool? preload, double? volume, int? timeout, int? buttonType, int? downloadType }) async {
    Map params = {
      "adUnitId": adUnitId,
      "logo": logo,
      "muted": muted,
      "preload": preload,
      "volume": volume,
      "timeout": timeout,
      "buttonType": buttonType,
      "downloadType": downloadType
    };
    params.removeWhere((key, value) => value == null);

    await _methodChannel.invokeMethod("showSplash", params);
  }
}
