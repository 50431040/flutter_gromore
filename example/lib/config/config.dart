import 'dart:io';

/// APP名称
const APP_NAME = "牛小二招聘";

/// 是否是生产环境
const IS_PRODUCTION = false;

class GroMoreAdConfig {
  /// APP-ID
  static String get appId {
    if (Platform.isAndroid) {
      return '5320035';
    }
    return '5320035';
  }

  /// 开屏广告ID
  static String get splashId {
    if (Platform.isAndroid) {
      return '102357892';
    }
    return '102357892';
  }

  /// 信息流广告ID
  static String get feedId {
    if (Platform.isAndroid) {
      return '102360311';
    }
    return '102360311';
  }

  /// 插屏广告ID
  static String get interstitialId {
    if (Platform.isAndroid) {
      return '102360214';
    }
    return '102360214';
  }

  /// 激励视频广告ID
  static String get rewardId {
    if (Platform.isAndroid) {
      return '102363841';
    }
    return '102363841';
  }

  /// 激励视频广告ID
  static String get bannerId {
    if (Platform.isAndroid) {
      return '102363749';
    }
    return '102363749';
  }
}
