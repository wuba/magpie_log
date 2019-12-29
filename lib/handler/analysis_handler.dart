import 'dart:convert';
import 'package:flutter/services.dart';

typedef AnalysisCallback = Function(Map<String, dynamic> data);

class MagpieAnalysisHandler {
  static final String _tag = 'AnalysisHandler';

  static final String _channelName = 'magpie_analysis_channel';

  //上报圈选数据通道类型，0 - Flutter，1 - Native
  int _channelType = 0;

  factory MagpieAnalysisHandler() => _getInstance();

  static MagpieAnalysisHandler get instance => _getInstance();

  static MagpieAnalysisHandler _instance;

  var _msgChannel;

  AnalysisCallback _callback;

  //发送圈选数据
  void sendData(Map<String, dynamic> data) {
    if (data == null || data.isEmpty) {
      print('$_tag sendData data 不合法！！！');
      return;
    }
    if (_channelType == 0) {
      MagpieAnalysisHandler.instance._sendMsgToFlutter(data);
    } else {
      MagpieAnalysisHandler.instance._sendMsgToNative(data);
    }
  }

  //设置Flutter通信的callback。如果数据上报通过flutter实现，此方法必须实现！！！
  void initHandler(int channelType, AnalysisCallback callback) {
    this._channelType = channelType;
    if (channelType == 0) {
      this._callback = callback;
    }
  }

  MagpieAnalysisHandler._handler() {
    _msgChannel = BasicMessageChannel(_channelName, StringCodec());
  }

  static MagpieAnalysisHandler _getInstance() {
    if (_instance == null) {
      _instance = MagpieAnalysisHandler._handler();
    }
    return _instance;
  }

  Future<Null> _sendMagpieData(String data) async {
    await _msgChannel.send(data);
  }

  //通过callback发送数据给Flutter
  void _sendMsgToFlutter(Map<String, dynamic> data) {
    if (_callback == null) {
      print('$_tag callback is null');
      return;
    }
    _callback(data);
  }

  //通过BasicMessageChannel发送数据给Native
  void _sendMsgToNative(Map<String, dynamic> data) {
    _sendMagpieData(jsonEncode(data).toString());
    print('$_tag sendMsgToNative : ${jsonEncode(data).toString()}');
  }
}
