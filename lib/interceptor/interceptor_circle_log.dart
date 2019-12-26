import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:magpie_log/file/log_util.dart';
import 'package:magpie_log/magpie_constants.dart';
import 'package:magpie_log/magpie_log.dart';
import 'package:magpie_log/ui/log_screen.dart';
import 'package:redux/redux.dart';

///step:1 intercept to add circle log

class CircleMiddleWare extends MiddlewareClass<LogState> {
  @override
  void call(Store<LogState> store, action, NextDispatcher next) {
    LogState logState = store.state;
    Map<String, dynamic> json = logState.toJson();
    print("MyMiddleWare call:${json.toString()}");
    String actionName =
        action is LogAction ? action.actionName : action.toString();
    if (MagpieLog.instance.isDebug) {
      Navigator.of(MagpieLog.instance.logContext).push(MaterialPageRoute(
          settings: RouteSettings(name: MagpieConstants.logScreen),
          builder: (BuildContext context) {
            return LogScreen(
                data: json,
                logType: circleLogType,
                store: store,
                action: action,
                actionName: actionName,
                next: next);
          }));
    } else {
      MagpieLogUtil.runTimeLog(actionName, 'pagePath', json);
      next(action);
    }
  }
}

class LogStoreConnector<S, ViewModel> extends StoreConnector<S, ViewModel> {
  final ViewModelBuilder<ViewModel> builder;
  final StoreConverter<S, ViewModel> converter;
  final bool distinct;
  final OnInitCallback<S> onInit;
  final OnDisposeCallback<S> onDispose;
  final bool rebuildOnChange;
  final IgnoreChangeTest<S> ignoreChange;
  final OnWillChangeCallback<ViewModel> onWillChange;
  final OnDidChangeCallback<ViewModel> onDidChange;
  final OnInitialBuildCallback<ViewModel> onInitialBuild;

  const LogStoreConnector({
    Key key,
    @required this.builder,
    @required this.converter,
    this.distinct = false,
    this.onInit,
    this.onDispose,
    this.rebuildOnChange = true,
    this.ignoreChange,
    this.onWillChange,
    this.onDidChange,
    this.onInitialBuild,
  }) : super(key: key, builder: builder, converter: converter);

  @override
  Widget build(BuildContext context) {
    LogState logState = StoreProvider.of<S>(context).state as LogState;
    var width = 0.0;
    if (logState.logStatus == 1) {
      width = 2.0;
    }
    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red, width: width),
        ),
        child: super.build(context));
  }
}
