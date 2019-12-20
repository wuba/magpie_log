// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountState _$CountStateFromJson(Map<String, dynamic> json) {
  return CountState(
    json['count'] as int,
    param1: json['param1'] as String,
    param2: json['param2'] as int,
  );
}

Map<String, dynamic> _$CountStateToJson(CountState instance) =>
    <String, dynamic>{
      'count': instance.count,
      'param1': instance.param1,
      'param2': instance.param2,
    };

AppState _$AppStateFromJson(Map<String, dynamic> json) {
  return AppState(
    countState: json['countState'] == null
        ? null
        : CountState.fromJson(json['countState'] as Map<String, dynamic>),
    otherState: json['otherState'] == null
        ? null
        : OtherState.fromJson(json['otherState'] as Map<String, dynamic>),
    param1: json['param1'] as String,
    param2: json['param2'] as int,
  );
}

Map<String, dynamic> _$AppStateToJson(AppState instance) => <String, dynamic>{
      'countState': instance.countState!=null?instance.countState.toJson():instance.countState,
      'otherState': instance.otherState!=null?instance.otherState.toJson():instance.otherState,
      'param1': instance.param1,
      'param2': instance.param2,
    };

OtherState _$OtherStateFromJson(Map<String, dynamic> json) {
  return OtherState(
    json['param1'] as String,
    json['param2'] as int,
  );
}

Map<String, dynamic> _$OtherStateToJson(OtherState instance) =>
    <String, dynamic>{
      'param1': instance.param1,
      'param2': instance.param2,
    };
