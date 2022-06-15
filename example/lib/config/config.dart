import 'dart:io';

/// APP名称
const APP_NAME = "牛小二招聘";

/// 是否是生产环境
const IS_PRODUCTION = false;

class GroMoreAdConfig {
  /// APP-ID
  static String get appId {
    if (Platform.isAndroid) {
      return '5220552';
    }
    return '5220559';
  }

  /// 开屏广告ID
  static String get splashId {
    if (Platform.isAndroid) {
      return '102082953';
    }
    return '102083881';
  }

  /// 信息流广告ID
  static String get feedId {
    if (Platform.isAndroid) {
      return '102083741';
    }
    return '102083975';
  }

  /// 插屏广告ID
  static String get interstitialId {
    if (Platform.isAndroid) {
      return '102073230';
    }
    return '102082993';
  }
}
