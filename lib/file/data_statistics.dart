import 'dart:convert';

import 'file_utils.dart';

class MagpieDataStatistics {
  static final String _tag = 'Magpie Data Statistics';

  static final String _dirName = 'data_analysis';

  ///数据分析配置参数统一写到统一文件中，所以在此直接定义好文件名称
  static final String _fileName = 'statistics.json';

  static Future<Null> writeStatisticsData(Map<String, dynamic> data) async {
    if (data != null && data.isNotEmpty) {
      String json = jsonEncode(data);
      if (await isExistsStatistics()) {
        String fileData = await readStatisticsData();
        clearStatisticsData();
        if (fileData.endsWith(']}')) {
          String jsonData =
              fileData.substring(0, fileData.length - 2) + ',' + json + ']}';
          await MagpieFileUtils.writeFile(
              fileName: _fileName, contents: jsonData, dirName: _dirName);
          print('$_tag writeStatisticsData data = $jsonData');
        } else {
          await MagpieFileUtils.writeFile(
              fileName: _fileName, contents: json, dirName: _dirName);
        }
      } else {
        await MagpieFileUtils.writeFile(
            fileName: _fileName, contents: json, dirName: _dirName);
        print('$_tag writeStatisticsData data = $json');
      }
    }
  }

  static Future<String> readStatisticsData() async {
    return await MagpieFileUtils.readFile(
        fileName: _fileName, dirName: _dirName);
  }

  static Future<bool> isExistsStatistics() async {
    return await MagpieFileUtils.isExistsFile(
        fileName: _fileName, dirName: _dirName);
  }

  static Future<Null> clearStatisticsData() async {
    await MagpieFileUtils.rmFile(fileName: _fileName, dirName: _dirName);
  }
}
