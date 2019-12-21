import 'package:json_annotation/json_annotation.dart';
part 'device_data.g.dart';

///采集设备信息和安装包信息
@JsonSerializable()
class DeviceData {
  final String platform;

  final String clientId;

  final String deviceVersion;

  final String brand;

  final String deviceId;

  final String model;

  DeviceData(this.clientId, this.platform, this.brand, this.deviceId,
      this.deviceVersion, this.model);

  factory DeviceData.fromJson(Map<String, String> params) =>
      _$DeviceDataFromJson(params);

  Map<String, String> toJson() => _$DeviceDataToJson(this);
}
