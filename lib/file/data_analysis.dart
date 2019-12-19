import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:magpie_log/constants.dart';
import 'package:magpie_log/file/file_utils.dart';
import 'package:magpie_log/model/analysis_model.dart';

///数据分析配置文件操作
class MagpieDataAnalysis {
  final String tag = 'Magpie Data Analysis';

  final String dirName = 'data_analysis';

  ///数据分析配置参数统一写到统一文件中，所以在此直接定义好文件名称
  final String fileName = 'analysis.json';

  static final List<AnalysisModel> _listData = List();

  Future<Null> saveData() async {
    if (_listData.isEmpty) {
      print('$tag saveData error!!! _listData is empty...');
      return;
    }
    //判断是否有之前写入的文件,有则删除
    await MagpieFileUtils().rmFile(dirName: dirName, fileName: fileName);
    AnalysisData analysisData = await _createCommonParams(_listData);

    await MagpieFileUtils().writeFile(
        dirName: dirName,
        fileName: fileName,
        contents: jsonEncode(analysisData.toJson()));
  }

  Future<Null> writeData(String action, String data) async {
    if (action.isEmpty || data.isEmpty) {
      print('$tag writeData error!!! action or content is empty...');
      return;
    }

    if (_listData.isEmpty) {
      //首次添加先获取全量数据
      String analysisData = await readFileData();
      if (analysisData.isNotEmpty) {
        Map<String, dynamic> analysis = jsonDecode(analysisData);
        AnalysisData data = AnalysisData.fromJson(analysis);
        _listData.addAll(data.data);
        print('$tag writeData addAll list length = ${_listData.length}');
      }
    }
    //数据去重
    if (_listData.any((item) => item.actionName == action)) {
      print('$tag writeData list replace data');
      _listData.forEach((item) => {
            if (item.actionName == action) {item.analysisData = data}
          });
    } else {
      print('$tag writeData list add data');
      _listData.add(AnalysisModel(action, data));
    }

    print('$tag writeData add list length = ${_listData.length}');
  }

  ///完整的圈选数据读取
  Future<String> readFileData() async {
    try {
      String all = await MagpieFileUtils()
          .readFile(dirName: dirName, fileName: fileName);
      return all;
    } catch (e) {
      print('$tag : readFile error = $e');
    }

    return '';
  }

  ///根据圈选埋点的action，读取指定数据。[action] 圈选埋点的key。
  Future<String> readActionData(String action) async {
    if (_listData.isEmpty) {
      String analysisData = await readFileData();
      if (analysisData.isNotEmpty) {
        Map<String, dynamic> analysis = jsonDecode(analysisData);
        AnalysisData data = AnalysisData.fromJson(analysis);
        _listData.addAll(data.data);
      }
    }

    if (_listData.isEmpty) {
      print('$tag readActionData isEmpty!!! 数据空空如也(o^^o)');
      return '';
    } else {
      if (_listData.any((item) => item.actionName == action)) {
        for (var item in _listData) {
          if (item.actionName == action) {
            return item.analysisData;
          }
        }
      } else {
        print('$tag readActionData listData 不包含此数据鸭(o^^o)');
        return '';
      }
    }
  }

  ///构造公共参数
  Future<AnalysisData> _createCommonParams(List<AnalysisModel> list) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    var platform, device, clientId;
    if (Platform.isAndroid) {
      platform = 'Android';
      device = jsonEncode(_getAndroidDeviceInfo(await deviceInfo.androidInfo));
      print(
          '$tag createCommonParams Android device Info =  ${_getAndroidDeviceInfo(await deviceInfo.androidInfo).toString()}');
    } else if (Platform.isIOS) {
      platform = "iOS";
      device = jsonEncode(_getIosDeviceInfo(await deviceInfo.iosInfo));
    }
    clientId = Constants.clientId;

    return AnalysisData(platform, device, clientId, list);
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
