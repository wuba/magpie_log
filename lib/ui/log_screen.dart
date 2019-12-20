import 'package:flutter/material.dart';
import 'package:magpie_log/file/data_analysis.dart';
import 'package:magpie_log/interceptor/interceptor_circle_log.dart';
import 'package:magpie_log/interceptor/interceptor_state_log.dart';

import 'package:redux/redux.dart';

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
      this.actionName,
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
  String log = "";

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

  ///递归参数圈选列表
  Widget initPanelList(List<ParamItem> paramList) {
    return Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
        child: SizedBox(
            height: 72 * paramList.length.toDouble(),
            child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  if (paramList[index].paramItems.length == 0) {
                    return CheckboxListTile(
                        value: paramList[index].isChecked,
                        title: Text(paramList[index].key),
                        subtitle: Text(paramList[index].value),
                        onChanged: (bool) {
                          setState(() {
                            paramList[index].isChecked = bool;
                          });
                        });
                  } else {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(paramList[index].key),
                          initPanelList(paramList[index].paramItems)
                        ]);
                  }
                },
                itemCount: paramList.length)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('圈选页面'),
        ),
        body: ListView(
          children: <Widget>[
            Text(
              "Pramas to choose:",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            initPanelList(paramList),
            Text(
              "Add log or pass?",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
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
                      getLog(map,paramList);
                      log  = map.toString();
                      if (widget.actionName != null) {
                        log = widget.actionName + ":$log";
                      } else if (widget.action != null) {
                        log = widget.action.toString() + ":$log";
                      } else {
                        debugPrint("error:no action key found!");
                      }
                    });

                    MagpieDataAnalysis().writeFile(log);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.accessible_forward),
                  onPressed: _redLog,
                )
              ],
            ),
            Text(
              "Config for log:",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            Text(log)
          ],
        ));
  }

  ///生成日志递归
  bool getLog(Map map, List<ParamItem> paramList) {
    bool isChecked = false;
    paramList.forEach((param) {
      if (param.paramItems.length == 0 && param.isChecked == true) {
        map[param.key] = 1;
        isChecked = true;
      }else{
        Map childMap = Map();
        if(getLog(childMap,param.paramItems)){
          map[param.key] = childMap;
          isChecked = true;
        }
      }
    });
    return isChecked;
  }

  Function _redLog() {}
}
