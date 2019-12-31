import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class MagpieFileUtils {
  static final String tag = 'Magpie FileUtils';

  static final String baseFilePath = '/magpie';

  ///根据指定文件夹名称创建文件
  ///[dirName]为空时，默认在magpie下创建文件
  static Future<File> _createFile(
      {@required String fileName, String dirName}) async {
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
  static Future<Null> writeFile(
      {@required String fileName,
      @required String contents,
      String dirName}) async {
    if (fileName.isNotEmpty && contents.isNotEmpty) {
      File file = await _createFile(fileName: fileName, dirName: dirName);
      if (!(await file.exists())) {
        file.create();
      }
      await (file).writeAsString(contents);
      print('$tag writeFile success : content = $contents');
    } else {
      print('$tag writeFile error = fileName isEmpty or contents isEmpty');
    }
  }

  ///获取文件。[dirName] 文件夹名称，[fileName] 文件名称
  static Future<File> _getFile(
      {@required String fileName, String dirName}) async {
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
  static Future<String> readFile(
      {@required String fileName, String dirName}) async {
    try {
      File file = await _getFile(fileName: fileName, dirName: dirName);
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

  ///判断文件是否存在
  static Future<bool> isExistsFile(
      {@required String fileName, String dirName}) async {
    File file = await _getFile(fileName: fileName, dirName: dirName);
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

  ///删除文件
  static Future<Null> rmFile(
      {@required String fileName, String dirName}) async {
    if (await isExistsFile(fileName: fileName, dirName: dirName)) {
      File file = await _getFile(fileName: fileName, dirName: dirName);
      file.delete();

      print(
          '$tag rmFile rmove file, fileName = $fileName , dirName = $dirName');
    }
  }

  ///清除文件中的数据
  static Future<Null> clearFileData(
      {@required String fileName, String dirName}) async {
    //暂且就先用简单直接的方式来吧。。。
    await rmFile(fileName: fileName, dirName: dirName);
    await _createFile(fileName: fileName, dirName: dirName);
  }

  ///获取文件路径
  static Future<String> getFilePath(
      {@required String fileName, String dirName}) async {
    if (await isExistsFile(fileName: fileName, dirName: dirName)) {
      File file = await _getFile(fileName: fileName, dirName: dirName);
      return file.path;
    } else {
      return '文件路径不存在';
    }
  }
}
