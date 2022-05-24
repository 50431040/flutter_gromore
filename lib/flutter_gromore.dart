
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class FlutterGromore {
  static const MethodChannel _methodChannel = MethodChannel("flutter_gromore");
  static const EventChannel _eventChannel = EventChannel("flutter_gromore_event");

  /// 同时请求：READ_PHONE_STATE, COARSE_LOCATION, FINE_LOCATION, WRITE_EXTERNAL_STORAGE权限
  static Future<void> requestPermissionIfNecessary() async {

    if (Platform.isIOS) {
      return;
    }
    await _methodChannel.invokeMethod("requestPermissionIfNecessary");

  }

  static Future<void> initSDK({ required String appId, required String appName, required bool debug }) async {
    await _methodChannel.invokeMethod("initSDK", {
      "appId": appId,
      "appName": appName,
      "debug": debug
    });
  }

  static Future<void> showSplash() async {
    await _methodChannel.invokeMethod("showSplash");
  }
}
