// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analysis_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnalysisModel _$AnalysisModelFromJson(Map<String, dynamic> json) {
  return AnalysisModel(
    actionName: json['actionName'] as String,
    pagePath: json['pagePath'] as String,
    analysisData: json['analysisData'] as String,
    description: json['description'] as String,
    type: json['type'] as String,
  );
}

Map<String, dynamic> _$AnalysisModelToJson(AnalysisModel instance) =>
    <String, dynamic>{
      'actionName': instance.actionName,
      'pagePath': instance.pagePath,
      'analysisData': instance.analysisData,
      'description': instance.description,
      'type': instance.type,
    };

AnalysisData _$AnalysisDataFromJson(Map<String, dynamic> json) {
  return AnalysisData(
    (json['data'] as List)
        ?.map((e) => e == null
            ? null
            : AnalysisModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    decodeChannel(json['reportChannel']),
    decodeMethod(json['reportMethod']),
  );
}

Map<String, dynamic> _$AnalysisDataToJson(AnalysisData instance) =>
    <String, dynamic>{
      'data': instance.data,
      'reportChannel': endoceChannel(instance.reportChannel),
      'reportMethod': encodeMethod(instance.reportMethod),
    };

int encodeMethod(ReportMethod method) {
  if (method == ReportMethod.timing) {
    return 1;
  } else if (method == ReportMethod.total) {
    return 2;
  } else {
    return 0;
  }
}

ReportMethod decodeMethod(dynamic method) {
  if (method == 1) {
    return ReportMethod.timing;
  } else if (method == 2) {
    return ReportMethod.total;
  } else {
    return ReportMethod.each;
  }
}

int endoceChannel(ReportChannel channel) {
  if (channel == ReportChannel.natives) {
    return 1;
  } else {
    return 0;
  }
}

ReportChannel decodeChannel(dynamic channel) {
  if (channel == 1) {
    return ReportChannel.natives;
  } else {
    return ReportChannel.flutter;
  }
}
