import 'package:flutter_gromore/config/gromore_banner_config.dart';
import 'package:flutter_gromore/config/gromore_feed_config.dart';
import 'package:flutter_gromore/flutter_gromore.dart';
import 'package:flutter_gromore_example/config/config.dart';

/// 广告工具类
class AdUtils {
  static List<String> feedAdIdList = [];
  static List<String> bannerAdIdList = [];

  /// 获取信息流广告id
  static Future<String?> getFeedAdId() async {
    if (feedAdIdList.isNotEmpty) {
      return feedAdIdList.removeLast();
    }

    // 加载信息流广告
    List<String> idList = await FlutterGromore.loadFeedAd(
        GromoreFeedConfig(adUnitId: GroMoreAdConfig.feedId));

    if (idList.isNotEmpty) {
      String id = idList.removeLast();
      feedAdIdList.addAll(idList);
      return id;
    }

    return null;
  }
}
