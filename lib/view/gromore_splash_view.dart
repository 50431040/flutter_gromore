import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gromore/callback/gromore_method_channel_handler.dart';
import 'package:flutter_gromore/callback/gromore_splash_callback.dart';
import 'package:flutter_gromore/config/gromore_splash_config.dart';
import 'package:flutter_gromore/constants/gromore_constans.dart';
import 'package:flutter_gromore/flutter_gromore.dart';

/// 开屏广告组件（自定义布局渲染）
class GromoreSplashView extends StatefulWidget {
  /// PlatformView参数
  final GromoreSplashConfig creationParams;

  /// 回调
  final GromoreSplashCallback? callback;

  const GromoreSplashView(
      {Key? key, required this.creationParams, this.callback})
      : super(key: key);

  @override
  State<GromoreSplashView> createState() => _GromoreSplashViewState();
}

class _GromoreSplashViewState extends State<GromoreSplashView> {
  @override
  Widget build(BuildContext context) {
    if (!FlutterGromore.isInit) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text("请先初始化SDK"),
        ),
      );
    }

    return Platform.isAndroid
        ? PlatformViewLink(
            viewType: FlutterGromoreConstants.splashTypeId,
            surfaceFactory:
                (BuildContext context, PlatformViewController controller) {
              return AndroidViewSurface(
                controller: controller as AndroidViewController,
                gestureRecognizers: const <
                    Factory<OneSequenceGestureRecognizer>>{},
                hitTestBehavior: PlatformViewHitTestBehavior.opaque,
              );
            },
            onCreatePlatformView: (PlatformViewCreationParams params) {
              return PlatformViewsService.initSurfaceAndroidView(
                id: params.id,
                viewType: FlutterGromoreConstants.splashTypeId,
                layoutDirection: TextDirection.ltr,
                creationParams: widget.creationParams.toJson(),
                creationParamsCodec: const StandardMessageCodec(),
                onFocus: () {
                  params.onFocusChanged(true);
                },
              )
                ..addOnPlatformViewCreatedListener((id) {
                  if (!mounted) {
                    return;
                  }
                  params.onPlatformViewCreated(id);

                  // 注册事件回调
                  if (widget.callback != null) {
                    GromoreMethodChannelHandler<GromoreSplashCallback>.register(
                        "${FlutterGromoreConstants.splashTypeId}/$id",
                        widget.callback!);
                  }
                })
                ..create();
            },
          )
        : Container();
  }
}
