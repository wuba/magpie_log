import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:magpie_log/file/log_util.dart';
import 'package:magpie_log/magpie_log.dart';
import 'package:magpie_log/ui/log_screen.dart';

import '../magpie_constants.dart';

abstract class WidgetLogState<T extends StatefulWidget> extends State {
  String getActionName();

  var logStatus;

  @override
  Widget build(BuildContext context) {
    if (logStatus == 1 && MagpieLog.instance.isDebug)
      return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red, width: 2.0),
          ),
          child: onBuild(context));
    else
      return onBuild(context);
  }

  Widget onBuild(BuildContext context);

  @override
  void setState(VoidCallback fn) {
    Map<String, dynamic> json = toJson();
    print("MyMiddleWare call:${json.toString()}");
    var actionName = getActionName();
    String pagePath = MagpieLog.instance.getCurrentPath();
    if (MagpieLog.instance.isDebug) {
      Navigator.of(context).push(MaterialPageRoute(
          settings: RouteSettings(name: MagpieConstants.logScreen),
          builder: (BuildContext context) {
            return LogScreen(
              data: json,
              logType: stateLogType,
              pagePath: pagePath,
              actionName: actionName,
              func: fn,
              state: this,
            );
          }));
    } else {
      MagpieLogUtil.runTimeLog(actionName, pagePath, json);
      super.setState(fn);
    }
    //super.setState(fn);
  }

  setRealState(Function func) {
    super.setState(func);
  }

  @override
  void initState() {
    super.initState();
  }

  Map<String, dynamic> toJson();
}
