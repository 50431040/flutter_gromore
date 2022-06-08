import 'package:flutter_gromore/config/gromore_base_config.dart';

class GromoreFeedConfig extends GromoreBaseAdConfig {
  /// 广告id
  final String adUnitId;

  final String? viewId;

  /// 请求数量，默认为3
  final int? count;

  /// 宽度，默认宽度占满
  final int? width;

  /// 高度，默认为0，0为高度选择自适应参数
  final int? height;

  /// 1-模板信息流,2-原生信息流，默认为1
  final int? adStyleType;

  GromoreFeedConfig(
      {required this.adUnitId,
      this.viewId,
      this.count,
      this.width,
      this.height,
      this.adStyleType});

  @override
  Map toJson() {
    Map<String, dynamic> result = {
      "adUnitId": adUnitId,
      "viewId": viewId,
      "count": count,
      "width": width,
      "height": height,
      "adStyleType": adStyleType
    };

    result.removeWhere((key, value) => value == null);

    return result;
  }
}
