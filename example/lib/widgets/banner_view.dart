import 'package:flutter/material.dart';
import 'package:flutter_gromore/callback/gromore_banner_callback.dart';
import 'package:flutter_gromore/view/gromore_banner_view.dart';
import 'package:flutter_gromore_example/utils/ad_utils.dart';

class BannerView extends StatefulWidget {
  const BannerView({Key? key}) : super(key: key);

  @override
  State<BannerView> createState() => _BannerViewState();
}

class _BannerViewState extends State<BannerView>
    with AutomaticKeepAliveClientMixin {
  double _height = 0.1;
  bool _show = false;
  String? _bannerAdId;

  @override
  void initState() {
    loadBannerAd();
    super.initState();
  }

  loadBannerAd() async {
    String? bannerAdId = await AdUtils.getBannerAdId();
    print("loadBannerAd $bannerAdId");
    if (bannerAdId != null && bannerAdId.isNotEmpty) {
      setState(() {
        _bannerAdId = bannerAdId;
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
            child: GromoreBannerView(
                creationParams: {"bannerId": _bannerAdId!},
                callback: GromoreBannerCallback(onRenderSuccess: (double height) {
                  print("GromoreBannerView | onRenderSuccess | $height");
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
