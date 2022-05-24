import 'package:flutter/material.dart';

import 'package:flutter_gromore/flutter_gromore.dart';
import 'package:flutter_gromore_example/config/config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  void handleRequestPermission() {
    FlutterGromore.requestPermissionIfNecessary();
  }

  void initSDK() {
    FlutterGromore.initSDK(appId: GROMORE_ANDROID_APP_ID, appName: APP_NAME, debug: !IS_PRODUCTION);
  }

  void showSplashAd() {
    FlutterGromore.showSplash(adUnitId: SPLASH_ANDROID_ID);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: initSDK, child: const Text("初始化SDK"),),
              const SizedBox(
                  height: 20
              ),
              ElevatedButton(onPressed: handleRequestPermission, child: const Text("请求非必要权限"),),
              const SizedBox(
                height: 20
              ),
              ElevatedButton(onPressed: showSplashAd, child: const Text("开屏广告"),),
            ],
          ),
        ),
      ),
    );
  }
}
