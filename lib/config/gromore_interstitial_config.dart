import 'package:flutter_gromore/config/gromore_base_config.dart';
import 'package:flutter_gromore/utils/gromore_ad_size.dart';

/// 插屏广告配置
class GromoreInterstitialConfig extends GromoreBaseAdConfig {
  /// 广告id
  final String adUnitId;

  /// 广告尺寸
  /// 配置将不会生效，已过时
  final GromoreAdSize? size;

  /// 设置横竖，仅Android可用。竖屏为1，横屏为2。默认竖屏
  final int? orientation;

  /// 是否静音，默认为true
  final bool? muted;

  GromoreInterstitialConfig({required this.adUnitId, this.size, this.orientation, this.muted});

  @override
  Map toJson() {
    return {
      "id": id,
      "adUnitId": adUnitId,
      "muted": muted
    };
  }
}
