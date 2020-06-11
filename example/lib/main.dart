import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:magpie_log/interceptor/intercepter_screen_log.dart';
import 'package:magpie_log/interceptor/interceptor_circle_log.dart';
import 'package:magpie_log/magpie_log.dart';
import 'package:magpie_log/model/analysis_model.dart';
import 'package:redux/redux.dart';

import 'states/app_state.dart';
import 'top_screen.dart';
import 'under_screen.dart';

void main() {
  //1.在main函数初始化store中加入CircleMiddleWare中间件拦截action实践，用于圈选拦截
  final store = Store<AppState>(reducer,
      middleware: [CircleMiddleWare()], initialState: AppState.initState());
  runApp(MyApp(store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  MyApp(this.store);

  @override
  Widget build(BuildContext context) {
    //2.MagpieLog初始化
    MagpieLog.instance.init(context, ReportMethod.timing, ReportChannel.natives,
        time: 1 * 60 * 1000, count: 3);

    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        routes: {
          '/': (BuildContext context) => TopScreen(),
          '/UnderScreen': (BuildContext context) => UnderScreen(),
        },
        //3.添加路由跳转监听，用于页面曝光拦截，以及路由堆栈建立，获取当前action唯一标识
        navigatorObservers: [
          LogObserver<AppState>(),
        ],
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.deepOrange),
      ),
    );
  }
}
