// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analysis_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnalysisModel _$AnalysisModelFromJson(Map<String, dynamic> json) {
  return AnalysisModel(
    json['actionName'] as String,
    json['analysisData'] as String,
  );
}

Map<String, dynamic> _$AnalysisModelToJson(AnalysisModel instance) =>
    <String, dynamic>{
      'actionName': instance.actionName,
      'analysisData': instance.analysisData,
    };

AnalysisData _$AnalysisDataFromJson(Map<String, dynamic> json) {
  return AnalysisData(
    json['platform'] as String,
    json['deviceInfo'],
    json['clientId'] as String,
    (json['data'] as List)
        ?.map((e) => e == null
            ? null
            : AnalysisModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$AnalysisDataToJson(AnalysisData instance) =>
    <String, dynamic>{
      'data': instance.data,
      'platform': instance.platform,
      'deviceInfo': instance.deviceInfo,
      'clientId': instance.clientId,
    };
