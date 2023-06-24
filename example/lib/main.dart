import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gromore/callback/gromore_interstitial_callback.dart';
import 'package:flutter_gromore/callback/gromore_reward_callback.dart';
import 'package:flutter_gromore/callback/gromore_splash_callback.dart';
import 'package:flutter_gromore/config/gromore_interstitial_config.dart';
import 'package:flutter_gromore/config/gromore_reward_config.dart';
import 'package:flutter_gromore/config/gromore_splash_config.dart';
import 'package:flutter_gromore/flutter_gromore.dart';
import 'package:flutter_gromore/utils/gromore_ad_size.dart';
import 'package:flutter_gromore_example/config/config.dart';
import 'package:flutter_gromore_example/pages/banner_demo.dart';
import 'package:flutter_gromore_example/pages/feed_demo.dart';
import 'package:flutter_gromore_example/pages/custom_splash.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Demo"),
        ),
        body: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String interstitialId = "";

  /// 请求权限（安卓端）【请自行处理权限，有可能会导致广告无法展示】
  Future<void> handleRequestAndroidPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.phone,
      Permission.locationWhenInUse,
      Permission.storage
    ].request();
    print(statuses);
  }

  void handleRequestPermission() {
    if (Platform.isIOS) {
      FlutterGromore.requestATT();
      return;
    }

    handleRequestAndroidPermission();
  }

  /// 初始化SDK
  void initSDK() async {
    bool result = await FlutterGromore.initSDK(
        appId: GroMoreAdConfig.appId,
        appName: APP_NAME,
        debug: !IS_PRODUCTION,
        useMediation: true);

    if (result) {
      // 加载插屏广告
      loadInterstitialAd();
    }
  }

  /// 展示开屏广告
  void showSplashAd() {
    FlutterGromore.showSplashAd(
        config: GromoreSplashConfig(
            adUnitId: GroMoreAdConfig.splashId, logo: "launch_image"),
        callback: GromoreSplashCallback(onAdShow: () {
          print("callback --- onAdShow");
        }));
  }

  /// 展示自定义布局开屏广告
  void showSplashAdView() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const CustomSplash()));
  }

  /// 展示信息流广告
  void showFeedAd() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const FeedDemo()));
  }

  /// 加载插屏广告
  Future<void> loadInterstitialAd() async {
    interstitialId = await FlutterGromore.loadInterstitialAd(
        GromoreInterstitialConfig(
            adUnitId: GroMoreAdConfig.interstitialId,
            size: GromoreAdSize.withPercent(
                MediaQuery.of(context).size.width * 2 / 3, 2 / 3)));

    if (interstitialId.isEmpty) {
      print("loadInterstitialAd 失败");
    }
  }

  /// 合适的时机展示插屏广告
  Future<void> showInterstitialAd() async {
    if (interstitialId.isNotEmpty) {
      await FlutterGromore.showInterstitialAd(
          interstitialId: interstitialId,
          callback: GromoreInterstitialCallback(onInterstitialShow: () {
            print("====== showInterstitialAd success ======");
          }, onInterstitialClosed: () {
            FlutterGromore.removeInterstitialAd(interstitialId);
            interstitialId = "";
            loadInterstitialAd();
          }));
    } else {
      loadInterstitialAd();
    }
  }

  /// 加载激励视频广告
  Future<void> loadRewardAd() async {
    String rewardAdId = await FlutterGromore.loadRewardAd(
        GromoreRewardConfig(adUnitId: GroMoreAdConfig.rewardId));

    if (rewardAdId.isNotEmpty) {
      showRewardAd(rewardAdId);
    }
  }

  /// 激励视频广告
  Future<void> showRewardAd(String rewardId) async {
    await FlutterGromore.showRewardAd(
        rewardId: rewardId,
        callback: GromoreRewardCallback(onRewardVerify: (bool verify) {
          if (verify) {
            // 如果需要在关闭广告后再判断，可以先把这个值用变量存储一下，在onAdClose回调中根据变量的值进行判断
            print("恭喜你，获得奖励");
          }
        }));
  }

  /// 展示banner广告
  void showBannerAd() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const BannerDemo()));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: initSDK,
              child: const Text("初始化SDK"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: handleRequestPermission,
              child: const Text("请求权限"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: showSplashAd,
              child: const Text("开屏广告"),
            ),
            const SizedBox(height: 20),
            // 不建议使用，仅安卓端可用
            // ElevatedButton(
            //   onPressed: showSplashAdView,
            //   child: const Text("开屏广告（自定义布局）"),
            // ),
            ElevatedButton(
              onPressed: showFeedAd,
              child: const Text("信息流广告"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: showInterstitialAd,
              child: const Text("插屏广告"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loadRewardAd,
              child: const Text("激励视频广告"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: showBannerAd,
              child: const Text("banner广告"),
            ),
          ],
        ),
      ),
    );
  }
}
