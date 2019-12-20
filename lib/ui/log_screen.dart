import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magpie_log/file/data_analysis.dart';
import 'package:magpie_log/interceptor/interceptor_circle_log.dart';
import 'package:magpie_log/interceptor/interceptor_state_log.dart';

import 'package:redux/redux.dart';
import 'dart:convert' as convert;
const int screenLogType = 1; //埋点类型：页面
const int circleLogType = 2; //埋点类型：redux全局数据埋点
const int stateLogType = 3; //埋点类型：state局部数据埋点

class LogScreen extends StatefulWidget {
  //通用参数
  final int logType; //埋点类型
  final Map<String, dynamic> data;
  final String actionName;

  //circleLogType参数
  final dynamic action; //没有actionName用action替代
  final Store<LogState> store;
  final NextDispatcher next;

  //stateLogType参数
  final Function func;
  final WidgetLogState state;

  const LogScreen(
      {Key key,
      @required this.data,
      @required this.logType,
      this.store,
      this.action,
      this.next,
      @required this.actionName,
      this.func,
      this.state})
      : super(key: key);

  @override
  _LogScreenState createState() => _LogScreenState();
}

class ParamItem {
  String key;
  String value;
  bool isChecked = false;
  bool isPaneled = false;
  List<ParamItem> paramItems;

  ParamItem(this.key, this.value, {this.paramItems});
}

class _LogScreenState extends State<LogScreen> {
  List<ParamItem> paramList = [];
  String log = "", readAllLog, readActionLog;

  ///递归参数数据初始化
  void initParam(Map map, List<ParamItem> paramList) {
    if (map == null) return;
    map.forEach((k, v) {
      List<ParamItem> paramList2 = [];
      if (v is! String && v is! int && v is! double && v is! bool) {
        initParam(v, paramList2);
      }

      paramList.add(ParamItem(k, v.toString(), paramItems: paramList2));
    });
  }

  @override
  void initState() {
    initParam(widget.data, paramList);
    //TODO:已经配置过得直接展示
    super.initState();
  }

  Widget getPaneledItem(bool isPaneled, ParamItem paramItem) {
    if (isPaneled) {
      return Padding(
          padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
          child: Column(children: intChildList(paramItem.paramItems)));
    } else {
      return Container(height: 0, width: 0);
    }
  }

  List<Widget> intChildList(List<ParamItem> paramList) {
    List<Widget> widgetList = [];

    for (int index = 0; index < paramList.length; index++) {
      if (paramList[index].paramItems.length == 0) {
        widgetList.add(CheckboxListTile(
            value: paramList[index].isChecked,
            title: Text(paramList[index].key),
            subtitle: Text(paramList[index].value),
            onChanged: (bool) {
              setState(() {
                paramList[index].isChecked = bool;
              });
            }));
      } else {
        widgetList.add(Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                  onTap: () {
                    setState(() {
                      paramList[index].isPaneled = !paramList[index].isPaneled;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 10, 0, 0),
                    child: Text(paramList[index].key,
                        style: TextStyle(fontSize: 15)),
                  )),
              getPaneledItem(paramList[index].isPaneled, paramList[index])
            ]));
      }
    }

    return widgetList;
  }

  ///递归参数圈选列表
  Widget initPanelList(List<ParamItem> paramList) {
    return Expanded(child: ListView(children: intChildList(paramList)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('圈选页面'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            "Add log or pass?",
            style: TextStyle(
                fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Row(
            children: <Widget>[
              MaterialButton(
                color: Colors.white,
                child: Text("Pass",
                    style: TextStyle(fontSize: 18, color: Colors.lightGreen)),
                onPressed: () {
                  switch (widget.logType) {
                    case screenLogType:
                      break;
                    case stateLogType:
                      widget.state.setRealState(widget.func);
                      break;
                    case circleLogType:
                      widget.next(widget.action);
                      break;
                  }
                  Navigator.pop(context);
                },
              ),
              MaterialButton(
                color: Colors.white,
                child: Text("log",
                    style: TextStyle(fontSize: 18, color: Colors.deepOrange)),
                onPressed: () {
                  if (widget.logType == stateLogType) {
                    widget.state.logStatus = 1;
                    widget.state.setRealState(() {});
                  }

                  setState(() {
                    StringBuffer logs = StringBuffer();
                    paramList.forEach((param) {
                      if (param.isChecked) {
                        logs.write(param.key + ",");
                      }
                    });
                    log = "[" + logs.toString() + "]";

                    Map map = Map();
                    getLog(map, paramList);
                    log = convert.jsonEncode(map);
//                    if (widget.actionName != null) {
//                      log = widget.actionName + ":$log";
//                    } else if (widget.action != null) {
//                      log = widget.action.toString() + ":$log";
//                    } else {
//                      debugPrint("error:no action key found!");
//                    }
                  });

                  MagpieDataAnalysis()
                      .writeData(context, widget.actionName, log);
                },
              ),
              IconButton(
                icon: Icon(Icons.accessible_forward),
                onPressed: () {
                  MagpieDataAnalysis().readFileData(context).then((allLog) {
                    setState(() {
                      readAllLog = allLog;
                    });
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.add_shopping_cart),
                onPressed: () {
                  MagpieDataAnalysis()
                      .readActionData(context, widget.actionName)
                      .then((actionLog) {
                    setState(() {
                      readActionLog = actionLog;
                    });
                  });
                },
              ),
              MaterialButton(
                child: Text('save',
                    style: TextStyle(color: Colors.blueAccent, fontSize: 20)),
                onPressed: () async {
                  await MagpieDataAnalysis().saveData();
                },
              )
            ],
          ),
          Text(
            "Config for log:",
            style: TextStyle(
                fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Column(
            children: <Widget>[
              Container(
                child: Text(
                  "${widget.actionName} :$log",
                  textAlign: TextAlign.center,
                ),
                margin: const EdgeInsets.all(10),
              ),
              Container(
                child: Text(
                  "${widget.actionName} readActionLog = $readActionLog",
                  textAlign: TextAlign.center,
                ),
                margin: const EdgeInsets.all(10),
              ),
              Container(
                child: Text(
                  "readAllLog = $readAllLog",
                  textAlign: TextAlign.center,
                ),
                margin: const EdgeInsets.all(10),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          Text(
            "Pramas to choose:",
            style: TextStyle(
                fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          initPanelList(paramList),
        ],
      ),
    );
  }

  ///生成日志递归
  bool getLog(Map map, List<ParamItem> paramList) {
    bool isChecked = false;
    paramList.forEach((param) {
      if (param.paramItems.length == 0 && param.isChecked == true) {
        map[param.key] = 1;
        isChecked = true;
      } else {
        Map childMap = Map();
        if (getLog(childMap, param.paramItems)) {
          map[param.key] = childMap;
          isChecked = true;
        }
      }
    });
    return isChecked;
  }
}
