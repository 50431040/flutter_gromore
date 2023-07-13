import 'package:flutter_gromore/config/gromore_base_config.dart';

/// 开屏广告配置
class GromoreSplashConfig extends GromoreBaseAdConfig {
  /// 广告id
  final String adUnitId;

  /// 广告宽度（自定义渲染可用）
  /// 将不再维护
  final double? width;

  /// 广告高度（自定义渲染可用）
  /// 将不再维护
  final double? height;

  /// 如果传入了logo则会在底部显示logo，logo放在android/app/src/main/res/mipmap下，值不需要文件后缀（非自定义渲染可用）
  final String? logo;

  /// 静音，默认为true
  final bool? muted;

  /// 预加载，默认为true
  final bool? preload;

  /// 声音配置，与muted配合使用
  final double? volume;

  /// 开屏摇一摇开关，默认为true
  final bool? isSplashShakeButton;

  /// bidding类型广告，竞价成功或者失败后是否通知对应的adn，默认为false
  final bool? isBidNotify;

  GromoreSplashConfig({
    required this.adUnitId,
    this.width,
    this.height,
    this.logo,
    this.muted,
    this.preload,
    this.volume,
    this.isSplashShakeButton,
    this.isBidNotify,
  });

  @override
  Map toJson() {
    Map result = {
      "id": id,
      "width": width,
      "height": height,
      "adUnitId": adUnitId,
      "logo": logo,
      "muted": muted,
      "preload": preload,
      "volume": volume,
      "isSplashShakeButton": isSplashShakeButton,
      "isBidNotify": isBidNotify
    };
    result.removeWhere((key, value) => value == null);
    return result;
  }
}
