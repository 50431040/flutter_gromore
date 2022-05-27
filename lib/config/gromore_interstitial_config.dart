import 'package:flutter_gromore/config/gromore_base_config.dart';
import 'package:flutter_gromore/utils/gromore_ad_size.dart';

/// 插屏广告配置
class GromoreInterstitialConfig extends GromoreBaseAdConfig {

  /// 广告id
  final String adUnitId;

  /// 广告尺寸
  final GromoreAdSize size;

  GromoreInterstitialConfig({required this.adUnitId, required this.size});

  @override
  Map toJson() {
    return {
      "id": id,
      "adUnitId": adUnitId,
      "width": size.width,
      "height": size.height
    };
  }
}
