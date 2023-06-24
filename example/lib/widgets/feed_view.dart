import 'package:flutter/material.dart';
import 'package:flutter_gromore/callback/gromore_feed_callback.dart';
import 'package:flutter_gromore/flutter_gromore.dart';
import 'package:flutter_gromore/view/gromore_feed_view.dart';
import 'package:flutter_gromore_example/utils/ad_utils.dart';

class FeedView extends StatefulWidget {
  const FeedView({Key? key}) : super(key: key);

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView>
    with AutomaticKeepAliveClientMixin {
  double _height = 0.1;
  bool _show = false;
  String? _feedAdId;

  @override
  void initState() {
    loadFeedAd();
    super.initState();
  }

  @override
  void dispose() {
    // 不需要手动移除，销毁时插件内部会处理
    // if (_feedAdId != null) {
    //   FlutterGromore.removeFeedAd(_feedAdId!);
    // }
    super.dispose();
  }

  loadFeedAd() async {
    String? feedAdId = await AdUtils.getFeedAdId();
    print("loadFeedAd $feedAdId");
    if (feedAdId != null && feedAdId.isNotEmpty) {
      setState(() {
        _feedAdId = feedAdId;
        _show = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _show
        ? SizedBox(
            height: _height,
            child: GromoreFeedView(
                creationParams: {"feedId": _feedAdId!},
                callback: GromoreFeedCallback(onRenderSuccess: (double height) {
                  print("GromoreFeedView | onRenderSuccess | $height");
                  setState(() {
                    _height = height;
                  });
                }, onSelected: () {
                  setState(() {
                    _show = false;
                  });
                }, onAdTerminate: () {
                  setState(() {
                    _show = false;
                  });
                })),
          )
        : const SizedBox();
  }

  @override
  bool get wantKeepAlive => true;
}
