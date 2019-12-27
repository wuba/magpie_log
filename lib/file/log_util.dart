import 'package:flutter/material.dart';
import 'package:magpie_log/handler/analysis_handler.dart';
import 'data_analysis.dart';

class MagpieLogUtil {
  static void runTimeLog(String actionName, String pagePath, Map json) {
    MagpieDataAnalysis()
        .readActionData(actionName: actionName, pagePath: pagePath)
        .then((data) {
      if (data == null) return;

      Map<String, dynamic> dataMap = data.toJson();
      trueData(json, dataMap);
      MagpieSendData.sendData(dataMap);
      debugPrint("runtime log:" + dataMap.toString());
    });
  }

  static void trueData(Map dataMap, Map logMap) {
    logMap.forEach((k, v) {
      if (v is Map) {
        trueData(dataMap[k], v);
      } else {
        logMap[k] = dataMap[k];
      }
    });
  }
}
