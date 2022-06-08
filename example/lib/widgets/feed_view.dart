import 'package:flutter/material.dart';
import 'package:flutter_gromore/callback/gromore_feed_callback.dart';
import 'package:flutter_gromore/config/gromore_feed_config.dart';
import 'package:flutter_gromore/view/gromore_feed_view.dart';
import 'package:flutter_gromore_example/config/config.dart';

class FeedView extends StatefulWidget {
  final String viewId;

  const FeedView({Key? key, required this.viewId}) : super(key: key);

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView>
    with AutomaticKeepAliveClientMixin {
  double _height = 0.1;
  bool _show = true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _show ? SizedBox(
      height: _height,
      child: GromoreFeedView(
          creationParams:
              GromoreFeedConfig(adUnitId: GoMoreAdConfig.feedId, viewId: widget.viewId),
          callback: GromoreFeedCallback(
            onRenderSuccess: (double height) {
              print("GromoreFeedView | onRenderSuccess | $height");
              setState(() {
                _height = height;
              });
            },
            onSelected: () {
              setState(() {
                _show = false;
              });
            }
          )),
    ) : const SizedBox();
  }

  @override
  bool get wantKeepAlive => true;
}
