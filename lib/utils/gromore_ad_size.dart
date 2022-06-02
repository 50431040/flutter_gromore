/// 广告尺寸
class GromoreAdSize {
  /// 宽
  final double? width;

  /// 高
  final double? height;

  GromoreAdSize({this.width, this.height});

  /// adWidth：广告宽度
  /// 宽高比
  GromoreAdSize.withPercent(double adWidth, double ratio)
      : width = adWidth,
        height = adWidth / ratio;
}
