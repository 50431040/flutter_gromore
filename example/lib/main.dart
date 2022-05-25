import 'package:flutter/material.dart';
import 'package:flutter_gromore/callback/gromore_splash_callback.dart';
import 'package:flutter_gromore/config/splash.dart';
import 'package:flutter_gromore/flutter_gromore.dart';
import 'package:flutter_gromore_example/config/config.dart';
import 'package:flutter_gromore_example/pages/feed_demo.dart';

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
  /// 请求权限（安卓端）
  void handleRequestPermission() {
    FlutterGromore.requestPermissionIfNecessary();
  }

  /// 初始化SDK
  void initSDK() {
    FlutterGromore.initSDK(
        appId: GROMORE_ANDROID_APP_ID,
        appName: APP_NAME,
        debug: !IS_PRODUCTION);
  }

  /// 展示开屏广告
  void showSplashAd() {
    // SPLASH_ANDROID_ID
    FlutterGromore.showSplash(
        config: GromoreSplashConfig(
            adUnitId: SPLASH_ANDROID_ID, logo: "launch_image"),
        callback: GromoreSplashCallback(onAdShow: () {
          print("callback --- onAdShow");
        }));
  }

  /// 展示信息流广告
  void showFeedAd() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const FeedDemo()));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
            child: const Text("请求非必要权限"),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: showSplashAd,
            child: const Text("开屏广告"),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: showFeedAd,
            child: const Text("信息流广告"),
          ),
        ],
      ),
    );
  }
}
