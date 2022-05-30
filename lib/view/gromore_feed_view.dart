import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gromore/callback/gromore_feed_callback.dart';
import 'package:flutter_gromore/callback/gromore_method_channel_handler.dart';
import 'package:flutter_gromore/config/gromore_feed_config.dart';
import 'package:flutter_gromore/constants/gromore_constans.dart';

import 'package:flutter_gromore/flutter_gromore.dart';

/// 信息流广告组件
class GromoreFeedView extends StatefulWidget {
  /// PlatformView参数
  final GromoreFeedConfig creationParams;

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
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text("请先初始化SDK"),
        ),
      );
    }

    return Platform.isAndroid
        ? PlatformViewLink(
            viewType: FlutterGromoreConstants.feedViewTypeId,
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
                viewType: FlutterGromoreConstants.feedViewTypeId,
                layoutDirection: TextDirection.ltr,
                creationParams: widget.creationParams.toJson(),
                creationParamsCodec: const StandardMessageCodec(),
                onFocus: () {
                  params.onFocusChanged(true);
                },
              )
                ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
                ..addOnPlatformViewCreatedListener((id) {
                  // 注册事件回调
                  GromoreMethodChannelHandler<GromoreFeedCallback>.register(
                      "${FlutterGromoreConstants.feedViewTypeId}/$id", widget.callback);
                })
                ..create();
            },
          )
        : Container();
  }
}
