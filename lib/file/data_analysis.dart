import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:magpie_log/constants.dart';
import 'package:magpie_log/file/file_utils.dart';

///数据分析配置文件操作
class MagpieDataAnalysis {
  final String tag = 'Magpie Data Analysis';

  final String folderName = 'data_analysis';

  ///数据分析配置参数统一写到统一文件中，所以在此直接定义好文件名称
  final String fileName = 'analysis.json';

  Future<Null> writeFile(String content) async {
    //先读取文件，判断之前是否有过写入操作
    String existContent = await MagpieFileUtils()
        .readFile(folderName: folderName, fileName: fileName);
    if (existContent.isNotEmpty) {
      //非首次操作，需要解析已存在的content，做数据插入
      print('$tag writeFile 非首次操作');
      await MagpieFileUtils().writeFile(
          folderName: folderName,
          fileName: fileName,
          contents: await _parseContent(existContent, content));
    } else {
      //首次操作，可以直接写入。但是需要先构造公共参数
      print('$tag writeFile 首次操作');
      await MagpieFileUtils().writeFile(
          folderName: folderName,
          fileName: fileName,
          contents: await _createCommonParams(content));
    }
  }

  /// 数据插入
  Future<String> _parseContent(String existContent, String content) async {
    Map<String, dynamic> jsonData = jsonDecode(existContent);
    print(
        '$tag parse conetent : existContent = $existContent , content = $content , jsonData = ${jsonData.length}');
    bool containsData = jsonData.containsKey('data');
    if (containsData) {
      List list = jsonDecode(jsonData['data']);
      list.add(content);
      jsonData['data'] = jsonEncode(list);
    } else {
      List list = List();
      list.add(content);
      jsonData['data'] = jsonEncode(list);
    }

    return jsonEncode(jsonData);
  }

  ///构造公共参数
  Future<String> _createCommonParams(String content) async {
    Map params = Map<String, dynamic>();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      params['platform'] = 'Android';
      params['deviceInfo'] =
          _getAndroidDeviceInfo(await deviceInfo.androidInfo).toString();
      print(
          '$tag createCommonParams Android device Info =  ${_getAndroidDeviceInfo(await deviceInfo.androidInfo).toString()}');
    } else if (Platform.isIOS) {
      params['platform'] = "iOS";
      params['deviceInfo'] =
          _getIosDeviceInfo(await deviceInfo.iosInfo).toString();
    }
    params['clientId'] = Constants.clientId;
    List list = List();
    list.add(content);
    params['data'] = jsonEncode(list);

    return jsonEncode(params);
  }

  Future<String> readFile(String fileName) async {
    try {} catch (e) {
      print('$tag : readFile error = $e');
    }

    return '';
  }

  Map<String, dynamic> _getAndroidDeviceInfo(AndroidDeviceInfo deviceInfo) {
    return <String, dynamic>{
      'version.sdkInt': deviceInfo.version.sdkInt,
      'brand': deviceInfo.brand,
      'device': deviceInfo.device,
      'id': deviceInfo.id,
      'model': deviceInfo.model,
      'product': deviceInfo.product,
      'androidId': deviceInfo.androidId
    };
  }

  Map<String, dynamic> _getIosDeviceInfo(IosDeviceInfo deviceInfo) {
    return <String, dynamic>{
      'name': deviceInfo.name,
      'systemName': deviceInfo.systemName,
      'systemVersion': deviceInfo.systemVersion,
      'model': deviceInfo.model,
      'localizedModel': deviceInfo.localizedModel,
      'identifierForVendor': deviceInfo.identifierForVendor,
    };
  }
}

/**
 * 1、在当前工程目录的assets文件夹中创建记录圈选数据的文件
 * 2、设备端在脱离USB调试的模式下如何反向对1中的文件写数据？
 * 3、release模式下，读取assets下的数据文件。在yaml文件中配置。
 * 4、
 */

/**
 * 1、提供数据
 */
