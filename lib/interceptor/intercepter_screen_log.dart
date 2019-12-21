//继承NavigatorObserver
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:magpie_log/ui/log_screen.dart';

import '../magpie_log.dart';
import 'interceptor_circle_log.dart';

class LogObserver<S> extends NavigatorObserver {
  @override
  void didPush(Route route, Route previousRoute) async {
    // 当调用Navigator.push时回调
    super.didPush(route, previousRoute);
    if ("/LogScreen" != route.settings.name) {
      await Future.delayed(Duration(seconds: 3));
      {
        try {
          LogState logState =
              StoreProvider.of<S>(route.navigator.context).state as LogState;
          String actionName =
              route.settings.name != null ? route.settings.name : "";
          Navigator.of(MagpieLog.instance.logContext).push(MaterialPageRoute(
              settings: RouteSettings(name: "/LogScreen"),
              builder: (BuildContext context) {
                return LogScreen(
                    actionName: actionName,
                    data: logState.toJson(),
                    logType: screenLogType);
              }));

          //print("route" + logState.toJson().toString());
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {}
}
