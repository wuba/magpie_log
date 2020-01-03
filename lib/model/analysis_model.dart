import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:magpie_log/handler/statistics_handler.dart';
part 'analysis_model.g.dart';

@JsonSerializable()
class AnalysisModel {
  //事件名称
  final String actionName;

  //页面路径
  final String pagePath;

  //埋点数据
  String analysisData;

  //圈选数据描述
  String description;

  //圈选数据类型
  String type;

  AnalysisModel(
      {@required this.actionName,
      @required this.pagePath,
      @required this.analysisData,
      @required this.description,
      this.type});

  factory AnalysisModel.fromJson(Map<String, dynamic> json) =>
      _$AnalysisModelFromJson(json);

  Map<String, dynamic> toJson() => _$AnalysisModelToJson(this);

  set updateAnalysis(String data) {
    this.analysisData = data;
  }

  @override
  String toString() {
    return 'actionName : $actionName , pageName : $pagePath , analysisData : $analysisData , description : $description , type : $type';
  }
}

@JsonSerializable()
class AnalysisData {
  List<AnalysisModel> data;

  //数据上报通道
  ReportChannel reportChannel;

  //数据上报方式
  ReportMethod reportMethod;

  AnalysisData(this.data, this.reportChannel, this.reportMethod) {
    MagpieStatisticsHandler.instance.setReportChannel(reportChannel);
    MagpieStatisticsHandler.instance.setReportMethod(reportMethod);
  }

  factory AnalysisData.fromJson(Map<String, dynamic> json) =>
      _$AnalysisDataFromJson(json);

  Map<String, dynamic> toJson() => _$AnalysisDataToJson(this);
}

/// 数据上报方式
enum ReportMethod {
  each, //每条上报
  timing, //定时上报
  total, //计数上报
}

///数据上报通道
enum ReportChannel {
  flutter, //Flutter 通道
  natives, //Native BasicMessageChannel 通道
}

class AnalysisType {
  //页面t
  static final String pageType = 'page';
  //state统计
  static final String stateType = 'state';
  //redux统计
  static final String reduxType = 'redux';
}
