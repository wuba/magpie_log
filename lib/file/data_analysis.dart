import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:magpie_log/file/file_utils.dart';
import 'package:magpie_log/model/analysis_model.dart';
import 'package:magpie_log/model/device_data.dart';

import '../magpie_log.dart';

///数据分析配置文件操作
class MagpieDataAnalysis {
  final String _tag = 'Magpie Data Analysis';

  final String _dirName = 'data_analysis';

  ///数据分析配置参数统一写到统一文件中，所以在此直接定义好文件名称
  final String _fileName = 'analysis.json';

  static final List<AnalysisModel> _listData = List();

  /// 初始化接口
  Future<String> initMagpieData(BuildContext context) async {
    var data;
    //圈选数据以文件中的为准，只有首次的时候从assets下读取并copy到内存中
    //动态下发的埋点数据需要全部写入到文件中
    if (await MagpieFileUtils().isExistsFile(_fileName, dirName: _dirName)) {
      data = await MagpieFileUtils().readFile(_fileName, dirName: _dirName);
    } else {
      //原则上assets目录中的配置文件只会读取一次
      data = await DefaultAssetBundle.of(context)
          .loadString('assets/analysis.json');
    }

    if (_listData.isEmpty) {
      if (data.isNotEmpty) {
        Map<String, dynamic> analysis = jsonDecode(data);
        AnalysisData analysisData = AnalysisData.fromJson(analysis);
        _listData.addAll(analysisData.data);
      }
    }

    //返回公共参数。原则上初始化的时候需要上报一次，但是不强制
    return (await _createCommonParams()).toJson().toString();
  }

  Future<Null> saveData() async {
    if (_listData.isEmpty) {
      print('$_tag saveData error!!! _listData is empty...');
      return;
    }
    //判断是否有之前写入的文件,有则删除
    await MagpieFileUtils().rmFile(_fileName, dirName: _dirName);

    await MagpieFileUtils().writeFile(
        _fileName, jsonEncode(AnalysisData(_listData).toJson()),
        dirName: _dirName);
  }

  Future<Null> writeData(AnalysisModel analysisModel) async {
    if (analysisModel == null ||
        analysisModel.actionName.isEmpty ||
        analysisModel.pagePath.isEmpty ||
        analysisModel.analysisData.isEmpty) {
      print('$_tag writeData error!!! 请再次检查AnalysisModel！！！ ');
      return;
    }

    if (_listData.isEmpty) {
      //首次添加先获取全量数据
      String analysisData = await readFileData();
      if (analysisData.isNotEmpty) {
        Map<String, dynamic> analysis = jsonDecode(analysisData);
        AnalysisData data = AnalysisData.fromJson(analysis);
        _listData.addAll(data.data);
        print('$_tag writeData addAll list length = ${_listData.length}');
      }
    }
    //数据去重
    if (_listData.any((item) => item.actionName == analysisModel.actionName)) {
      print(
          '$_tag writeData list replace data, action = ${analysisModel.toString()} ');
      _listData.forEach((item) => {
            if (item.actionName == analysisModel.actionName)
              {
                item = analysisModel,
                print(
                    '$_tag writeData list replace data, action = ${analysisModel.actionName}} : actionName = ${item.actionName}')
              }
          });
    } else {
      print('$_tag writeData list add data');
      _listData.add(analysisModel);
    }

    print('$_tag writeData add list length = ${_listData.length}');
  }

  ///完整的圈选数据读取
  Future<String> readFileData() async {
    try {
      return jsonEncode(AnalysisData(_listData));
    } catch (e) {
      print('$_tag : readFile error = $e');
    }
    return '';
  }

  ///获取已选择的圈选数据集合
  List<AnalysisModel> getListData() => _listData;

  ///根据圈选埋点的action，读取指定数据。[action] 圈选埋点的key。
  Future<String> readActionData(String action) async {
    if (_listData.isEmpty) {
      print('$_tag readActionData isEmpty!!! 数据空空如也(o^^o)');
      return '';
    } else {
      if (_listData.any((item) => item.actionName == action)) {
        for (var item in _listData) {
          if (item.actionName == action) {
            print(
                '$_tag readActionData actionName = ${item.actionName} , data = ${item.analysisData}');
            return item.analysisData;
          }
        }
      }
      print('$_tag readActionData listData 不包含此数据鸭(o^^o)');
      return '';
    }
  }

  ///获取文件路径
  Future<String> getSavePath() async {
    return await MagpieFileUtils().getFilePath(_fileName, dirName: _dirName);
  }

  ///清除全部数据。直接删除文件就完了呀呀呀呀呀
  Future<Null> clearAnalysisData() async {
    _listData.clear();
    MagpieFileUtils().clearFileData(_fileName, dirName: _dirName);
    print('$_tag clearAnalysisData _listData.length = ${_listData.length}');
  }

  Future<int> deleteActionData({@required String actionName}) async {
    if (actionName.isEmpty) {
      print('$_tag deleteActionData actionName isEmpty');
      return -1;
    }

    if (_listData.isEmpty) {
      print('$_tag deleteActionData listData isEmpty');
      return -3;
    }
    if (_listData.any((item) => item.actionName == actionName)) {
      for (var item in _listData) {
        if (item.actionName == actionName) {
          _listData.remove(item);

          print(
              '$_tag deleteActionData remove actionName = ${item.actionName}');
          return 0;
        }
      }
    }

    return -2;
  }

  ///构造公共参数
  Future<DeviceData> _createCommonParams() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    var platform, deviceVersion, clientId, deviceName, deviceId, product, model;
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      platform = 'Android';
      deviceVersion = androidInfo.version.release;
      deviceName = androidInfo.brand;
      model = androidInfo.model;
      deviceId = androidInfo.androidId;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      platform = "iOS";
      deviceVersion = iosInfo.systemVersion;
      deviceName = iosInfo.name;
      model = iosInfo.model;
      deviceId = iosInfo.identifierForVendor;
    }
    clientId = globalClientId;

    DeviceData info = DeviceData(
        platform, clientId, deviceName, deviceId, deviceVersion, model);

    print('$_tag createCommonParams Android device Info =  ${info.toJson()}');

    return info;
  }
}
