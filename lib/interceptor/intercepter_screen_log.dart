import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:magpie_log/file/log_util.dart';
import 'package:magpie_log/magpie_constants.dart';
import 'package:magpie_log/magpie_log.dart';
import 'package:magpie_log/ui/log_float_view.dart';
import 'package:magpie_log/ui/log_screen.dart';

/// 1.LogObserver是页面跳转监听，拦截页面入栈用于统计页面曝光
///
/// 2.MagpieLog.instance.routeStack路由栈的维护，用于获取页面的唯一标识
/// 和action拦截的页面弹出，action拦截需要route用于弹层
///
class LogObserver<S> extends NavigatorObserver {
  @override
  void didPush(Route route, Route previousRoute) async {
    //当前route添加到路由堆栈
    MagpieLog.instance.routeStack.add(route);

    //排除
    if (route.settings.name.startsWith(MagpieConstants.magpieDomain)) {
      return;
    }
    await Future.delayed(Duration(milliseconds: 500)); //可以去掉
    try {
      LogState logState =
          StoreProvider.of<S>(route.navigator.context).state as LogState;
      var json = logState.toJson();

      String actionName =
          MagpieLog.instance.getCurrentPath(); //TODO：考虑actionName可以自定义
      String pagePath = MagpieLog.instance.getCurrentPath();

      if (MagpieLog.instance.isDebug && MagpieLog.instance.isPageLogOn) {
        FloatEntry.singleton.showOverlayEntry();
        Future.delayed(Duration.zero, () {
          try {
            MagpieLog.instance.addToActionList(
                actionName,
                PageRouteBuilder(
                    opaque: false,
                    settings: RouteSettings(name: MagpieConstants.logScreen),
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        LogScreen(
                            pagePath: pagePath,
                            actionName: actionName,
                            data: logState.toJson(),
                            logType: pageType)));
          } catch (e) {
            print(e.toString());
          }
        });
      } else {
        MagpieLogUtil.runTimeLog(actionName, pagePath, json, type: pageType);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    MagpieLog.instance.routeStack.removeLast();
  }

  @override
  void didRemove(Route route, Route previousRoute) {
    MagpieLog.instance.routeStack.removeLast();
  }

  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    MagpieLog.instance.routeStack.removeLast();
    MagpieLog.instance.routeStack.add(newRoute);
  }
}
