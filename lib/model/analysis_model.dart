import 'package:json_annotation/json_annotation.dart';
part 'analysis_model.g.dart';

@JsonSerializable()
class AnalysisModel {
  final String actionName;

  String analysisData;

  String description;

  String type;

  AnalysisModel(
      this.actionName, this.analysisData, this.description, this.type);

  factory AnalysisModel.fromJson(Map<String, dynamic> json) =>
      _$AnalysisModelFromJson(json);

  Map<String, dynamic> toJson() => _$AnalysisModelToJson(this);

  set updateAnalysis(String data) {
    this.analysisData = data;
  }

  @override
  String toString() {
    return 'actionName : $actionName , analysisData : $analysisData , description : $description , type : $type';
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
