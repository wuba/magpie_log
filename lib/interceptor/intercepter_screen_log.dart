//继承NavigatorObserver
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:magpie_log/ui/log_screen.dart';

import 'interceptor_circle_log.dart';

class LogObserver<S> extends NavigatorObserver {
  @override
  void didPush(Route route, Route previousRoute) async {
    // 当调用Navigator.push时回调
    super.didPush(route, previousRoute);
    if ("/LogScreen" != route.settings.name) {
      await Future.delayed(Duration(seconds: 2));
      {
        try {
          //执行build方法
          LogState logState =
              StoreProvider.of<S>(route.navigator.context).state as LogState;
          //可通过route.settings获取路由相关内容
          //route.currentResult获取返回内容
          //....等等

          String actionName = "";
//          if (route is MaterialPageRoute) {
//            MaterialPageRoute materialPageRoute = route;
//            Function a = materialPageRoute.builder;
//            Closure
//            //a.toString();
//          }

          actionName =
              route.settings.name != null ? route.settings.name : actionName;
          Navigator.of(maContext).push(MaterialPageRoute(
              settings: RouteSettings(name: "/LogScreen"),
              builder: (BuildContext context) {
                return LogScreen(
                    data: logState.toJson(), logType: screenLogType);
              }));

          //print("route" + logState.toJson().toString());
        } catch (e, stack) {
          debugPrint(e.toString());
        }
      }
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {}
}
