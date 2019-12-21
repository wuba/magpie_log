import 'dart:convert' as convert;

import 'package:flutter/material.dart';

import '../magpie_log.dart';
import 'data_analysis.dart';

class MagpieLogUtil {
  static void runTimeLog(String actionName, Map json) {
    MagpieDataAnalysis().readActionData(actionName).then((data) {
      Map<String, dynamic> dataMap = convert.jsonDecode(data);
      trueData(json, dataMap);
      MagpieLog.instance.logCallBack(actionName, dataMap);
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
