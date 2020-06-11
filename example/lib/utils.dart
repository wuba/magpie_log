import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magpie_log/magpie_log.dart';
import 'package:magpie_log/model/analysis_model.dart';

class MagpieExampleUtils {
  final String tag = 'MagpieExampleUtils';

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
    MagpieLog.instance.init(context, ReportMethod.timing, ReportChannel.flutter,
        callback: _receiverMagpieData, time: 1 * 60 * 1000, count: 3);
  }

  void _receiverMagpieData(String jsonData) {
    Fluttertoast.showToast(
        msg: "sendMsgToFlutter==>\n$jsonData",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.deepOrange,
        textColor: Colors.white,
        fontSize: 16.0);
    print('basicMessageChannel $jsonData');
  }
}
