import 'package:flutter/material.dart';
import 'package:magpie_log/handler/statistics_handler.dart';
import 'package:magpie_log/model/analysis_model.dart';
import 'data_analysis.dart';
import 'dart:convert' as convert;

class MagpieLogUtil {
  static void runTimeLogModel(AnalysisModel model) {
    runTimeLog(model.actionName, model.pagePath,
        convert.jsonDecode(model.analysisData));
  }

  static void runTimeLog(String actionName, String pagePath, Map dataMap,
      {String type, int index = 0}) {
    MagpieDataAnalysis.readActionData(
            actionName: actionName, pagePath: pagePath, type: type)
        .then((data) {
      if (data == null) return;

      Map<String, dynamic> logMap = convert.jsonDecode(data.analysisData);
      trueData(dataMap, logMap, index: index);

      AnalysisModel model = AnalysisModel(
          actionName: actionName,
          pagePath: pagePath,
          type: type,
          analysisData: convert.jsonEncode(logMap),
          description: data.description);

      MagpieStatisticsHandler.instance.writeData(model.toJson());
      debugPrint("runtime log:" + model.toJson().toString());
    });
  }

  static void trueData(Map dataMap, Map logMap, {int index = 0}) {
    logMap.forEach((k, v) {
      if (v is Map) {
        trueData(dataMap[k] is List ? dataMap[k][index] : dataMap[k], v,
            index: index);
      } else {
        logMap[k] = dataMap[k];
      }
    });
  }
}
