import 'package:flutter/material.dart';

///设置全局常量

@immutable
class Constants {
  static final bool isDebug = true;
  //static final bool isDebug = const bool.fromEnvironment("dart.vm.product");
  static final String clientId = "com.magpie.flutter";
}
