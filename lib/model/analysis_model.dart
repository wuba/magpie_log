import 'package:json_annotation/json_annotation.dart';
part 'analysis_model.g.dart';

@JsonSerializable()
class AnalysisModel {
  final String actionName;

  String analysisData;

  AnalysisModel(this.actionName, this.analysisData);

  factory AnalysisModel.fromJson(Map<String, dynamic> json) =>
      _$AnalysisModelFromJson(json);

  Map<String, dynamic> toJson() => _$AnalysisModelToJson(this);

  set updateAnalysis(String data) {
    this.analysisData = data;
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
