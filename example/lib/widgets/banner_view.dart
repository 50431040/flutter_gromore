import 'package:flutter/material.dart';
import 'package:flutter_gromore/callback/gromore_banner_callback.dart';
import 'package:flutter_gromore/view/gromore_banner_view.dart';
import 'package:flutter_gromore_example/config/config.dart';
import 'package:flutter_gromore_example/utils/ad_utils.dart';

class BannerView extends StatefulWidget {
  const BannerView({Key? key}) : super(key: key);

  @override
  State<BannerView> createState() => _BannerViewState();
}

class _BannerViewState extends State<BannerView>
    with AutomaticKeepAliveClientMixin {
  double _height = 0.1;
  final double _bannerHeight = 150;
  bool _show = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _show
        ? SizedBox(
            height: _height,
            child: GromoreBannerView(
                creationParams: {
                  "adUnitId": GroMoreAdConfig.bannerId,
                  "height": _bannerHeight.toString()
                },
                callback: GromoreBannerCallback(onRenderSuccess: () {
                  print("GromoreBannerView | onRenderSuccess");
                  setState(() {
                    _height = _bannerHeight;
                  });
                }, onSelected: () {
                  setState(() {
                    _show = false;
                  });
                }, onLoadError: () {
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
