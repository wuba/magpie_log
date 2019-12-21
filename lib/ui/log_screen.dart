import 'dart:convert' as convert;

import 'package:flutter/cupertino.dart';
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
  bool isChecked;
  bool isPaneled;
  List<ParamItem> paramItems;

  ParamItem(this.key, this.value,
      {this.paramItems, this.isPaneled = false, this.isChecked = false});
}

class _LogScreenState extends State<LogScreen> {
  List<ParamItem> paramList = [];
  String log = "", readAllLog, readActionLog;

  @override
  void initState() {
    MagpieDataAnalysis().readActionData(widget.actionName).then((actionLog) {
      Map map;
      if (actionLog != null && actionLog != "") {
        map = convert.jsonDecode(actionLog);
      }
      initParam(widget.data, map, paramList);
      setState(() {});
    });

    super.initState();
  }

  ///递归参数数据初始化
  bool initParam(Map data, Map logConfig, List<ParamItem> paramList) {
    if (data == null) return false;

    bool isPaneled = false;
    bool isParentPaneled = false;
    data.forEach((k, v) {
      List<ParamItem> paramList2 = [];
      bool isChecked = false;
      if (v is Map) {
        isPaneled =
            initParam(v, logConfig == null ? null : logConfig[k], paramList2);
      } else {
        if (logConfig != null && logConfig[k] != null && logConfig[k] == 1) {
          isChecked = true;
          isParentPaneled = true;
        }
      }
      paramList.add(ParamItem(k, v.toString(),
          paramItems: paramList2, isChecked: isChecked, isPaneled: isPaneled));
    });

    return isPaneled||isParentPaneled;
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
          buttons(),
          Text(
            "Config for log:",
            style: TextStyle(
                fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          configData(),
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

  Widget configData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Text(
            "${widget.actionName} :$log",
          ),
          margin: const EdgeInsets.all(10),
        ),
//        Container(
//          child: Text(
//            "当前配置"+widget.action.toString() + " : $readActionLog",
//            textAlign: TextAlign.center,
//          ),
//          margin: const EdgeInsets.all(10),
//        ),
        Container(
          child: Text(
            "全配置 = $readAllLog",
          ),
          margin: const EdgeInsets.all(10),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  Widget buttons() {
    return Row(
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
            });

            MagpieDataAnalysis().writeData(widget.actionName, log);
          },
        ),
        MaterialButton(
          color: Colors.white,
          child: Text('读取配置',
              style: TextStyle(color: Colors.blueAccent, fontSize: 15)),
          onPressed: () {
            MagpieDataAnalysis().readFileData().then((allLog) {
              setState(() {
                readAllLog = allLog;
              });
            });
          },
        ),
//        MaterialButton(
//          color: Colors.white,
//          child: Text('读取当前',
//              style: TextStyle(color: Colors.blueAccent, fontSize: 15)),
//          onPressed: () {
//            MagpieDataAnalysis()
//                .readActionData(widget.actionName)
//                .then((actionLog) {
//              setState(() {
//                readActionLog = actionLog;
//              });
//            });
//          },
//        ),
        MaterialButton(
          color: Colors.white,
          child: Text('生成配置',
              style: TextStyle(color: Colors.blueAccent, fontSize: 15)),
          onPressed: () async {
            await MagpieDataAnalysis().saveData();
          },
        )
      ],
    );
  }

  ///递归参数圈选列表
  Widget initPanelList(List<ParamItem> paramList) {
    return Expanded(child: ListView(children: intChildList(paramList)));
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

  Widget getPaneledItem(bool isPaneled, ParamItem paramItem) {
    if (isPaneled) {
      return Padding(
          padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
          child: Column(children: intChildList(paramItem.paramItems)));
    } else {
      return Container(height: 0, width: 0);
    }
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
