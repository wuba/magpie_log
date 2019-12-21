import 'package:flutter/material.dart';

import 'file/data_analysis.dart';

BuildContext logContext;
const bool isDebug = true;
//TODO:release modify
//const bool isDebug = const bool.fromEnvironment("dart.vm.product");
const String globalClientId = "com.wuba.flutter.magpie_log";

class MagpieLog {
  static init(BuildContext context) {
    logContext = context;
    MagpieDataAnalysis().initMagpieData(context); //初始化圈选数据
  }
}
