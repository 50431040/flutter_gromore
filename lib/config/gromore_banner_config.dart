import 'package:flutter_gromore/config/gromore_base_config.dart';

class GromoreBannerConfig extends GromoreBaseAdConfig {
  /// 广告id
  final String adUnitId;

  /// 请求数量，默认为3
  final int? count;

  /// 宽度，默认宽度占满
  final int? width;

  /// 高度，默认为0，0为高度选择自适应参数
  final int? height;

  GromoreBannerConfig(
      {required this.adUnitId,
      this.count,
      this.width,
      this.height});

  @override
  Map toJson() {
    Map<String, dynamic> result = {
      "adUnitId": adUnitId,
      "count": count,
      "width": width,
      "height": height,
    };

    result.removeWhere((key, value) => value == null);

    return result;
  }
}
