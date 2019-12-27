import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

typedef AnalysisCallback = Function(String actionName, String actionData);

class MagpieSendData {
  static final int _channelType = 0;

  static void sendData(Map<String, dynamic> data) {
    if (_channelType == 0) {
      _AnalysisHandler.instance.sendMsgToFlutter(data);
    } else {
      _AnalysisHandler.instance.sendMsgToNative(data);
    }
  }
}

class _AnalysisHandler implements _MessageHandler {
  static final String tag = 'AnalysisHandler';

  static final String channelName = 'magpie_analysis_channel';

  factory _AnalysisHandler() => _getInstance();

  static _AnalysisHandler get instance => _getInstance();

  static _AnalysisHandler _instance;

  var msgChannel;

  _AnalysisHandler._handler() {
    msgChannel = BasicMessageChannel(channelName, StringCodec());
  }

  static _AnalysisHandler _getInstance() {
    if (_instance == null) {
      _instance = _AnalysisHandler._handler();
    }
    return _instance;
  }

  Future<Null> _sendMagpieData(String data) async {
    await msgChannel.send(data);
  }

  @override
  void sendMsgToFlutter(Map<String, dynamic> data) {
    Fluttertoast.showToast(
        msg: "sendMsgToFlutter==>\n$data",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.deepOrange,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  void sendMsgToNative(Map<String, dynamic> data) {
    _sendMagpieData(jsonEncode(data).toString());
    print('$tag sendMsgToNative : ${jsonEncode(data).toString()}');
  }
}

class _MessageHandler {
  //圈选数据上报到flutter
  void sendMsgToFlutter(Map<String, dynamic> data) {}

  //圈选数据上报到native
  void sendMsgToNative(Map<String, dynamic> data) {}
}
