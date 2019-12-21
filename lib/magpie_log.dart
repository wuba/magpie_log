import 'package:flutter/material.dart';

import 'file/data_analysis.dart';

BuildContext logContext;
const bool isDebug = false;
const String globalClientId = "com.wuba.flutter.magpie_log";

class MagpieLog {
  static init(BuildContext context) {
    logContext = context;
    MagpieDataAnalysis().initMagpieData(context); //初始化圈选数据
  }
}
