import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class MagpieFileUtils {
  final String tag = 'Magpie FileUtils';

  final String baeFilePath = '/magpie';

  ///根据指定文件夹名称创建文件
  ///[dirName]为空时，默认在magpie下创建文件
  Future<File> _createFile({String dirName, @required String fileName}) async {
    Directory baseDir = await getApplicationDocumentsDirectory();
    var filePath = Directory(baseDir.path);
    if (dirName.isNotEmpty) {
      filePath = Directory(baseDir.path + '/' + dirName);
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
      {String dirName,
      @required String fileName,
      @required String contents}) async {
    if (fileName.isNotEmpty && contents.isNotEmpty) {
      File file = await _createFile(dirName: dirName, fileName: fileName);
      if (!(await file.exists())) {
        file.create();
      }
      await (file).writeAsString(contents);
      print('$tag writeFile success : content = $contents');
    } else {
      print('$tag writeFile error = fileName isEmpty or contents isEmpty');
    }
  }

  Future<File> _getFile(String dirName, String fileName) async {
    if (fileName.isNotEmpty) {
      String filePath = dirName.isNotEmpty
          ? (await getApplicationDocumentsDirectory()).path + '/' + dirName
          : (await getApplicationDocumentsDirectory()).path;

      return File('$filePath/$fileName');
    } else {
      print('$tag getFile error = fileName isEmpty');
      return null;
    }
  }

  ///从文件中读书数据
  Future<String> readFile({String dirName, @required String fileName}) async {
    try {
      File file = await _getFile(dirName, fileName);
      if (await file.exists()) {
        String contents = await file.readAsString();

        return contents;
      } else {
        print('$tag readFile 确定创建了？？？ --- ${file.path}');
      }
    } catch (e) {
      print('$tag readFile error = $e');
    }

    return '';
  }

  Future<bool> isExistsFile({String dirName, @required String fileName}) async {
    File file = await _getFile(dirName, fileName);
    if (await file.exists()) {
      print(
          '$tag isExistsFile =  true, fileName = $fileName , dirName = $dirName');
      return true;
    } else {
      print(
          '$tag isExistsFile =  false, fileName = $fileName , dirName = $dirName');
      return false;
    }
  }

  Future<Null> rmFile({String dirName, @required String fileName}) async {
    if (await isExistsFile(fileName: fileName, dirName: dirName)) {
      File file = await _getFile(dirName, fileName);
      file.delete();

      print(
          '$tag rmFile rmove file, fileName = $fileName , dirName = $dirName');
    }
  }

  Future<String> getFilePath(String dirName,
      {@required String fileName}) async {
    if (await isExistsFile(fileName: fileName, dirName: dirName)) {
      File file = await _getFile(dirName, fileName);
      return file.path;
    } else {
      return '文件路径不存在';
    }
  }
}
