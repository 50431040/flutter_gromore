import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gromore/constants/config.dart';

class FlutterGromoreFeedView extends StatefulWidget {
  const FlutterGromoreFeedView({Key? key}) : super(key: key);

  @override
  State<FlutterGromoreFeedView> createState() => _FlutterGromoreFeedViewState();
}

class _FlutterGromoreFeedViewState extends State<FlutterGromoreFeedView> {
  @override
  Widget build(BuildContext context) {
    const Map<String, dynamic> creationParams = <String, dynamic>{};

    return Platform.isAndroid
        ? PlatformViewLink(
            viewType: flutterGromoreFeedViewTypeId,
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
                viewType: flutterGromoreFeedViewTypeId,
                layoutDirection: TextDirection.ltr,
                creationParams: creationParams,
                creationParamsCodec: const StandardMessageCodec(),
                onFocus: () {
                  params.onFocusChanged(true);
                },
              )
                ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
                ..create();
            },
          )
        : Container();
  }
}
