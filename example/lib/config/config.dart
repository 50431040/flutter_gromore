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
    return '5410502';
  }

  /// 开屏广告ID
  static String get splashId {
    if (Platform.isAndroid) {
      return '102357892';
    }
    return '102392509';
  }

  /// 信息流广告ID
  static String get feedId {
    if (Platform.isAndroid) {
      return '102361544';
    }
    return '102391145';
  }

  /// 插屏广告ID
  static String get interstitialId {
    if (Platform.isAndroid) {
      return '102360214';
    }
    return '102390665';
  }

  /// 激励视频广告ID
  static String get rewardId {
    if (Platform.isAndroid) {
      return '102363841';
    }
    return '102754385';
  }

  /// banner广告ID
  static String get bannerId {
    if (Platform.isAndroid) {
      return '102754191';
    }
    return '102754949';
  }
}
