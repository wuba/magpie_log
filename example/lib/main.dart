import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:magpie_log/interceptor/intercepter_screen_log.dart';
import 'package:magpie_log/interceptor/interceptor_circle_log.dart';
import 'package:redux/redux.dart';

import 'log_detail_screen.dart';
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
          '/UnderScreen': (BuildContext context) => UnderScreen(),
          '/log_detail': (BuildContext context) => LogDetailScreen()
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
