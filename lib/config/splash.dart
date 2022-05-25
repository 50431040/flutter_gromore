import 'package:flutter/material.dart';

class GromoreSplashConfig {
  /// 唯一标识，创建时自动生成
  String id;

  final String adUnitId;

  /// 如果传入了logo则会在底部显示logo，logo放在android/app/src/main/res/mipmap下，值不需要文件后缀
  final String? logo;

  /// 静音
  final bool? muted;

  /// 预加载
  final bool? preload;

  /// 声音配置，与muted配合使用
  final double? volume;

  /// 超时时间，默认3000ms
  final int? timeout;

  /// 按钮样式（1：全屏可点击，2：仅按钮可点击，默认为1）
  final int? buttonType;

  /// 点击下载样式（0或者1，默认为1）
  final int? downloadType;

  GromoreSplashConfig({
    required this.adUnitId,
    this.logo,
    this.muted,
    this.preload,
    this.volume,
    this.timeout,
    this.buttonType,
    this.downloadType,
  }) : id = UniqueKey().toString();

  Map toJson() {
    return {
      "id": id,
      "adUnitId": adUnitId,
      "logo": logo,
      "muted": muted,
      "preload": preload,
      "volume": volume,
      "timeout": timeout,
      "buttonType": buttonType,
      "downloadType": downloadType
    };
  }
}
