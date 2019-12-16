import 'package:flutter/material.dart';
import 'package:magpie_log/ui/log_screen.dart';
import 'package:redux/redux.dart';

///step:1 intercept to add circle log

BuildContext maContext;

abstract class LogState {
  Map<String, dynamic> toJson();
}

class CircleMiddleWare extends MiddlewareClass<LogState> {
  @override
  void call(Store<LogState> store, action, NextDispatcher next) {
    LogState countState = store.state;
    Map<String, dynamic> json = countState.toJson();
    print("MyMiddleWare call:${json.toString()}");
    Navigator.of(maContext)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return LogScreen(
          data: json, store: store, action: action, next: next);
    }));
  }
}
