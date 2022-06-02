import 'package:flutter/cupertino.dart';

abstract class GromoreBaseAdConfig {
  /// 唯一标识
  String? id;

  /// 转换为Map
  Map toJson();

  /// 生成唯一id
  generateId() {
    id = UniqueKey().hashCode.toString();
  }
}
