// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceData _$DeviceDataFromJson(Map<String, dynamic> json) {
  return DeviceData(
    json['clientId'] as String,
    json['platform'] as String,
    json['brand'] as String,
    json['deviceId'] as String,
    json['deviceVersion'] as String,
    json['model'] as String,
  );
}

Map<String, dynamic> _$DeviceDataToJson(DeviceData instance) =>
    <String, dynamic>{
      'platform': instance.platform,
      'clientId': instance.clientId,
      'deviceVersion': instance.deviceVersion,
      'brand': instance.brand,
      'deviceId': instance.deviceId,
      'model': instance.model,
    };
