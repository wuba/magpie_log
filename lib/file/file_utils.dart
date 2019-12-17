import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class MagpieFileUtils {
  final String tag = 'Magpie FileUtils';

  final String baeFilePath = '/magpie';

  ///根据指定文件夹名称创建文件
  ///[folderName]为空时，默认在magpie下创建文件
  Future<File> _createFile(
      {String folderName, @required String fileName}) async {
    Directory baseDir = await getApplicationDocumentsDirectory();
    var filePath = Directory(baseDir.path);
    if (folderName.isNotEmpty) {
      filePath = Directory(baseDir.path + '/' + folderName);
    }

    try {
      bool isExsit = await filePath.exists();
      print(
          '$tag " _createFile filePath = ${filePath.path} , isExsit = $isExsit');
      if (!isExsit) {
        filePath.create();
      }
    } catch (e) {
      print('$tag : _createFile error = $e');
    }
    return File('${filePath.path}/$fileName');
  }

  ///文件中写入数据
  Future<Null> writeFile(
      {String folderName,
      @required String fileName,
      @required String contents}) async {
    if (fileName.isNotEmpty && contents.isNotEmpty) {
      File file = await _createFile(folderName: folderName, fileName: fileName);
      if (!(await file.exists())) {
        file.create();
      }
      print('$tag writeFile success : content = $contents');
      await (file).writeAsString(contents);
    } else {
      print('$tag writeFile error = fileName isEmpty or contents isEmpty');
    }
  }

  Future<File> _getFile(String folderName, String fileName) async {
    if (fileName.isNotEmpty) {
      String filePath = folderName.isNotEmpty
          ? (await getApplicationDocumentsDirectory()).path + '/' + folderName
          : (await getApplicationDocumentsDirectory()).path;

      return File('$filePath/$fileName');
    } else {
      print('$tag getFile error = fileName isEmpty');
      return null;
    }
  }

  ///从文件中读书数据
  Future<String> readFile(
      {String folderName, @required String fileName}) async {
    try {
      File file = await _getFile(folderName, fileName);
      if (await file.exists()) {
        String contents = await file.readAsString();

        return contents;
      } else {
        print('$tag readFile undefined');
      }
    } catch (e) {
      print('$tag readFile error = $e');
    }

    return '';
  }
}
