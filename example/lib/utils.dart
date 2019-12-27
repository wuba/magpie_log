import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magpie_log/handler/analysis_handler.dart';
import 'package:magpie_log/magpie_log.dart';

class MagpieExampleUtils {
  final String tag = 'MagpieExampleUtils';

  final int channelType = 0;

  factory MagpieExampleUtils() => _getInstance();

  MagpieExampleUtils get instance => _getInstance();

  static MagpieExampleUtils _instance;

  MagpieExampleUtils._init();

  static MagpieExampleUtils _getInstance() {
    if (_instance == null) {
      _instance = MagpieExampleUtils._init();
    }

    return _instance;
  }

  void init(BuildContext context) {
    MagpieLog.instance.init(context);
    MagpieAnalysisHandler.instance
        .initHandler(channelType, _receiverMagpieData);
  }

  void _receiverMagpieData(Map<String, dynamic> data) {
    Fluttertoast.showToast(
        msg: "sendMsgToFlutter==>\n$data",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.deepOrange,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
