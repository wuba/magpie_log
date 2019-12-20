// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceData _$DeviceDataFromJson(Map<String, String> json) {
  return DeviceData(
    json['clientId'],
    json['platform'],
    json['brand'],
    json['deviceId'],
    json['deviceVersion'],
    json['model'],
  );
}

Map<String, String> _$DeviceDataToJson(DeviceData instance) => <String, String>{
      'platform': instance.platform,
      'clientId': instance.clientId,
      'deviceVersion': instance.deviceVersion,
      'brand': instance.brand,
      'deviceId': instance.deviceId,
      'model': instance.model,
    };
