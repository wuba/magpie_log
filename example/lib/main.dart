import 'package:example/states/count_state.dart';
import 'package:example/top_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:magpie_log/interceptor/interceptor_circle_log.dart';
import 'package:redux/redux.dart';

void main() {
  final store = Store<CountState>(reducer,
      middleware: [CircleMiddleWare()], initialState: CountState.initState());
  runApp(new MyApp(store));
}

class MyApp extends StatelessWidget {
  final Store<CountState> store;
  MyApp(this.store);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<CountState>(
      store: store,
      child: new MaterialApp(
        title: 'Flutter Demo',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: TopScreen(),
      ),
    );
  }
}
