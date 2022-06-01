import 'dart:io';

/// APP名称
const APP_NAME = "牛小二招聘";

/// 是否是生产环境
const IS_PRODUCTION = false;

class GoMoreAdConfig {
  /// APP-ID
  static String get appId {
    if (Platform.isAndroid) {
      return '5220552';
    }
    return '5220559';
  }

  /// 开屏广告ID
  static String get splashId{
    if(Platform.isAndroid){
      return '887609336';
    }
    return '887615532';
  }

  /// 信息流广告ID
  static String get feedId{
    if(Platform.isAndroid){
      return '946996514';
    }
    return '947047858';
  }

  /// 插屏广告ID
  static String get interstitialId {
    if(Platform.isAndroid){
      return '946996513';
    }
    return '947047859';
  }
}
