import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gromore/callback/gromore_feed_callback.dart';
import 'package:flutter_gromore/callback/gromore_method_channel_handler.dart';
import 'package:flutter_gromore/constants/gromore_constans.dart';

import 'package:flutter_gromore/flutter_gromore.dart';

/// 信息流广告组件
class GromoreFeedView extends StatefulWidget {
  final Map<String, String> creationParams;

  /// 回调
  final GromoreFeedCallback callback;

  const GromoreFeedView(
      {Key? key, required this.creationParams, required this.callback})
      : super(key: key);

  @override
  State<GromoreFeedView> createState() => _GromoreFeedViewState();
}

class _GromoreFeedViewState extends State<GromoreFeedView> {
  @override
  Widget build(BuildContext context) {
    if (!FlutterGromore.isInit) {
      print("============== 请先初始化SDK ==============");
    }

    String viewType = FlutterGromoreConstants.feedViewTypeId;

    return Platform.isAndroid
        ? PlatformViewLink(
            viewType: viewType,
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
                viewType: viewType,
                layoutDirection: TextDirection.ltr,
                creationParams: widget.creationParams,
                creationParamsCodec: const StandardMessageCodec(),
                onFocus: () {
                  params.onFocusChanged(true);
                },
              )
                ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
                ..addOnPlatformViewCreatedListener((id) {
                  // 注册事件回调
                  GromoreMethodChannelHandler<GromoreFeedCallback>.register(
                      "$viewType/$id", widget.callback);
                })
                ..create();
            },
          )
        : UiKitView(
            viewType: viewType,
            creationParams: widget.creationParams,
            creationParamsCodec: const StandardMessageCodec(),
            onPlatformViewCreated: (id) {
              // 注册事件回调
              GromoreMethodChannelHandler<GromoreFeedCallback>.register(
                  "$viewType/$id", widget.callback);
            });
  }
}
