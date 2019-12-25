import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
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

  AnalysisData(this.data);

  factory AnalysisData.fromJson(Map<String, dynamic> json) =>
      _$AnalysisDataFromJson(json);

  Map<String, dynamic> toJson() => _$AnalysisDataToJson(this);

  set updateData(List<AnalysisModel> data) {
    this.data = data;
  }
}

class AnalysisType {
  //页面t
  static final String pageType = 'page';
  //state统计
  static final String stateType = 'state';
  //redux统计
  static final String reduxType = 'redux';
  //手动埋点
  static final String manuallyType = 'manually';
}
