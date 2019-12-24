import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:magpie_log/interceptor/intercepter_screen_log.dart';
import 'package:magpie_log/interceptor/interceptor_circle_log.dart';
import 'package:redux/redux.dart';
import 'package:magpie_log/ui/log_operation_screen.dart';
import 'package:magpie_log/ui/log_actiion_list.dart';
import 'package:magpie_log/magpie_constants.dart';

import 'states/app_state.dart';
import 'top_screen.dart';
import 'under_screen.dart';

void main() {
  final store = Store<AppState>(reducer,
      middleware: [CircleMiddleWare()], initialState: AppState.initState());
  runApp(MyApp(store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  MyApp(this.store);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        routes: {
          '/': (BuildContext context) => TopScreen(),
          MagpieConstants.UNDER_SCREEN_PAGE: (BuildContext context) =>
              UnderScreen(),
          MagpieConstants.LOG_OPERATION_PAGE: (BuildContext context) =>
              MagpieLogOperation(),
          MagpieConstants.ACTION_LIST_PAGE: (BuildContext context) =>
              MagpieActionList(),
        },
        navigatorObservers: [
          LogObserver<AppState>(),
        ],
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.deepOrange),
      ),
    );
  }
}
