import 'package:example/states/count_state.dart';
import 'package:example/top_screen.dart';
import 'package:example/under_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:magpie_log/interceptor/intercepter_screen_log.dart';
import 'package:magpie_log/interceptor/interceptor_circle_log.dart';
import 'package:redux/redux.dart';

void main() {
  final store = Store<CountState>(reducer,
      middleware: [CircleMiddleWare()], initialState: CountState.initState());
  runApp(MyApp(store));
}

class MyApp extends StatelessWidget {
  final Store<CountState> store;

  MyApp(this.store);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<CountState>(
      store: store,
      child: MaterialApp(
        routes: {
          ///这两个不能同时出现，而且home不为null，不可以设置这个
          // '/': (BuildContext context) => new OnePage(),
          // Navigator.defaultRouteName:(BuildContext context) => new MyHomePage(),
          //key：value形式
          '/': (BuildContext context) => TopScreen(),
          '/UnderScreen': (BuildContext context) => UnderScreen(),
        },
        navigatorObservers: [
          LogObserver<CountState>(),
        ],
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.deepOrange),
//        home: TopScreen(),
      ),
    );
  }
}
