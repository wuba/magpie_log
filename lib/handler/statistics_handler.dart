import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:magpie_log/file/data_statistics.dart';
import 'package:magpie_log/model/analysis_model.dart';

///已圈选数据统计上报

class MagpieStatisticsHandler {
  final String _tag = 'MagpieStatisticsHandler';

  factory MagpieStatisticsHandler() => _getInstance();

  static MagpieStatisticsHandler get instance => _getInstance();

  static MagpieStatisticsHandler _instance;

  static MagpieStatisticsHandler _getInstance() {
    if (_instance == null) {
      _instance = MagpieStatisticsHandler._init();
    }

    return _instance;
  }

  int _time, _count;

  ReportChannel _reportChannel;

  ReportMethod _reportMethod;

  get reportChannel => _reportChannel;

  get reportMethod => _reportMethod;

  void setReportChannel(ReportChannel channelType) {
    this._reportChannel = channelType;
  }

  void setReportMethod(ReportMethod method) {
    this._reportMethod = method;
  }

  Timer _timer;

  List<Map<String, dynamic>> _dataStatistics;

  MagpieStatisticsHandler._init() {
    _dataStatistics = List();
  }

  /**
   * 初始化配置。
   *  [reportMethod]    数据上报方式，0 - 单条上报，1 - 定时上报，2 - 计数上报。默认单条上报
   *  [reportChannel]   数据上报通道，0 - Flutter，1 - Native BasicMessageChannel。默认Flutter
   *  [time]            定时上报方式需要设置的时间周期。默认为2*60*1000 mill
   *  [count]           计数上报方式需要设置的采集数量。默认为50条
   *  [callback]        设置Flutter通信的callback。如果数据上报通过flutter实现，此方法必须实现！！！
   */
  void initConfig(ReportMethod reportMethod, ReportChannel reportChannel,
      {int time: 2 * 60 * 1000,
      int count: 50,
      AnalysisCallback callback}) async {
    this._count = count;
    this._time = time;
    this._reportMethod = reportMethod;
    this._reportChannel = reportChannel;
    _MagpieAnalysisHandler.instance.initHandler(reportChannel, callback);

    ///初始化时判断是否有之前写入的未上报数据，有则上报后删除
    if (await MagpieDataStatistics.isExistsStatistics()) {
      String jsonData = await MagpieDataStatistics.readStatisticsData();
      _MagpieAnalysisHandler.instance.sendDataToJson(jsonData);
      MagpieDataStatistics.clearStatisticsData();
    }
  }

  ///写入要上报的圈选数据
  void writeData(Map<String, dynamic> data) {
    if (_reportMethod != ReportMethod.each) {
      _saveData(data);
    }
    if (_reportMethod == ReportMethod.timing) {
      if (_timer == null) {
        _reportDataToTimer();
      }
    } else if (_reportMethod == ReportMethod.total) {
      _reportDataToCount(data);
    } else {
      _MagpieAnalysisHandler.instance.sendDataToMap(data);
    }
  }

  /// app退出时调用
  void exitMagpie() {
    if (_timer.isActive) {
      _timer.cancel();
      _timer = null;
    }
  }

  void _saveData(Map<String, dynamic> data) async {
    if (data != null && data.isNotEmpty) {
      _dataStatistics.add(data);
    }
    if (await MagpieDataStatistics.isExistsStatistics()) {
      MagpieDataStatistics.writeStatisticsData(data);
    } else {
      MagpieDataStatistics.writeStatisticsData({'data': _dataStatistics});
    }
  }

  //定时上报
  void _reportDataToTimer() {
    _timer = Timer.periodic(Duration(milliseconds: _time), (Void) async {
      if (_dataStatistics.isNotEmpty ||
          await MagpieDataStatistics.isExistsStatistics()) {
        var data;
        if (_dataStatistics.isEmpty) {
          data = await MagpieDataStatistics.readStatisticsData();
        } else {
          var params = {'data': _dataStatistics};
          data = jsonEncode(params).toString();
        }
        _sendData(data);
      }
    });
  }

  //计数上报
  void _reportDataToCount(Map<String, dynamic> data) async {
    if (_dataStatistics.length >= _count) {
      var params = {'data': _dataStatistics};
      String jsonData = jsonEncode(params).toString();

      _sendData(jsonData);
    }
  }

  void _sendData(String jsonData) async {
    _MagpieAnalysisHandler.instance.sendDataToJson(jsonData);
    _dataStatistics.clear();
    await MagpieDataStatistics.clearStatisticsData();
  }
}

///非单条上报时，每次数据add到list中时，一并写入到文件中
///数据上报优先以文件数据为准
///上报后清空内存缓存和文件

typedef AnalysisCallback = Function(String jsonData);

class _MagpieAnalysisHandler {
  static final String _tag = 'AnalysisHandler';

  static final String _channelName = 'magpie_analysis_channel';

  //上报圈选数据通道类型，0 - Flutter，1 - Native
  ReportChannel _channelType;

  factory _MagpieAnalysisHandler() => _getInstance();

  static _MagpieAnalysisHandler get instance => _getInstance();

  static _MagpieAnalysisHandler _instance;

  var _msgChannel;

  AnalysisCallback _callback;

  //发送圈选数据
  void sendDataToMap(Map<String, dynamic> data) {
    if (data == null || data.isEmpty) {
      print('$_tag sendData data 不合法！！！');
      return;
    }

    sendDataToJson(jsonEncode(data).toString());
  }

  void sendDataToJson(String jsonData) {
    if (jsonData.isNotEmpty) {
      if (_channelType == ReportChannel.natives) {
        _MagpieAnalysisHandler.instance._sendMsgToNative(jsonData);
      } else {
        _MagpieAnalysisHandler.instance._sendMsgToFlutter(jsonData);
      }
      print('$_tag sendDataToJson jsonData = $jsonData');
    }
  }

  //设置Flutter通信的callback。如果数据上报通过flutter实现，此方法必须实现！！！
  void initHandler(ReportChannel channelType, AnalysisCallback callback) {
    this._channelType = channelType;
    if (channelType != ReportChannel.natives) {
      this._callback = callback;
    }
  }

  _MagpieAnalysisHandler._handler() {
    _msgChannel = BasicMessageChannel(_channelName, StringCodec());
  }

  static _MagpieAnalysisHandler _getInstance() {
    if (_instance == null) {
      _instance = _MagpieAnalysisHandler._handler();
    }
    return _instance;
  }

  Future<Null> _sendMagpieData(String data) async {
    await _msgChannel.send(data);
  }

  //通过callback发送数据给Flutter
  void _sendMsgToFlutter(String data) {
    if (_callback == null) {
      print('$_tag callback is null');
      return;
    }
    _callback(data);
  }

  //通过BasicMessageChannel发送数据给Native
  void _sendMsgToNative(String data) {
    _sendMagpieData(data);
    print('$_tag sendMsgToNative : ${jsonEncode(data).toString()}');
  }
}
