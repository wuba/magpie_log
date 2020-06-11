import 'package:example/flutterboost/page_router.dart';
import 'package:example/states/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/container/boost_page_route.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:magpie_log/interceptor/intercepter_screen_log.dart';
import 'package:magpie_log/interceptor/interceptor_circle_log.dart';
import 'package:magpie_log/magpie_log.dart';
import 'package:magpie_log/model/analysis_model.dart';
import 'package:redux/redux.dart';

void main() {
  //1.在main函数初始化store中加入CircleMiddleWare中间件拦截action实践，用于圈选拦截（和普通路由一样）
  final store = Store<AppState>(reducer,
      middleware: [CircleMiddleWare()], initialState: AppState.initState());
  runApp(MyApp(store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  MyApp(this.store);

  @override
  Widget build(BuildContext context) {
    //2.初始化MagpieLog pageNameCallback回调 flutterBoost的路由id和普通navigator跳转位置不通
    MagpieLog.instance.init(context, ReportMethod.timing, ReportChannel.natives,
        time: 1 * 60 * 1000, count: 3, pageNameCallback: (Route route) {
      if (route is BoostPageRoute) {
        return route.pageName;
      }
      return "";
    });

    //3.设置监听的方式和普通方式不同 要在addBoostNavigatorObserver设置否则监听不到flutterBoost的路由跳转
    FlutterBoost.singleton.addBoostNavigatorObserver(LogObserver<AppState>());

    PageRouter.init();
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        builder: FlutterBoost.init(),
        home: Container(),
        theme: ThemeData(primarySwatch: Colors.deepOrange),
      ),
    );
  }
}
