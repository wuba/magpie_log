// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'count_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountState _$CountStateFromJson(Map<String, dynamic> json) {
  return CountState(
    json['count'] as int,
    param1: json['param1'] as int,
    param2: json['param2'] as int,
  );
}

Map<String, dynamic> _$CountStateToJson(CountState instance) =>
    <String, dynamic>{
      'count': instance.count,
      'param1': instance.param1,
      'param2': instance.param2,
    };
