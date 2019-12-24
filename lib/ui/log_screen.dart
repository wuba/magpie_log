import 'dart:convert' as convert;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magpie_log/file/data_analysis.dart';
import 'package:magpie_log/interceptor/interceptor_state_log.dart';
import 'package:magpie_log/magpie_log.dart';
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
  bool isChecked; //是否选中
  bool isPaneled; //是否展开
  List<ParamItem> paramItems;

  ParamItem(this.key, this.value,
      {this.paramItems, this.isPaneled = false, this.isChecked = false});
}

class _LogScreenState extends State<LogScreen> {
  List<ParamItem> paramList = [];
  String log = "", readAllLog, readActionLog;
  String title = "";

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

    switch (widget.logType) {
      case screenLogType:
        title = "页面圈选";
        break;
      case circleLogType:
        title = "Redux圈选";
        break;
      case stateLogType:
        title = "State圈选";
        break;
    }

    super.initState();
  }

  ///递归参数数据初始化
  bool initParam(Map data, Map logConfig, List<ParamItem> paramList) {
    if (data == null) return false;

    bool isPaneled = false; //是不是展开
    bool isParentPaneled = false; //父View是不是展开
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
    //自己施展开的或者父View是展开的都要返回true
    return isPaneled || isParentPaneled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: <Widget>[
            Center(
                child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/log_detail');
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                      child: Text('圈选配置',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                    )))
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                child: Row(
                  children: <Widget>[
                    Text(
                      "埋点Id:  ",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.actionName,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
            Divider(height: 1.0, color: Colors.black26),
            switches(),
            Divider(height: 1.0, color: Colors.black26),
            Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 10, 10),
                child: Text(
                  "选取参数:",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold),
                )),
            initPanelList(paramList),
            buttons(),
          ],
        ));
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

  Widget switches() {
    return Column(
      children: <Widget>[
        Row(children: <Widget>[
          Switch(
            value: MagpieLog.instance.isDebug,
            onChanged: (value) {
              setState(() {
                MagpieLog.instance.isDebug = !MagpieLog.instance.isDebug;
              });
            },
            activeTrackColor: Colors.orange,
            activeColor: Colors.deepOrange,
          ),
          Text(
            "isDebug:是否打开圈选 关闭上传埋点 \n需重启才能开启",
            style: TextStyle(fontSize: 12, color: Colors.black54),
          )
        ]),
        Row(children: <Widget>[
          Switch(
            value: MagpieLog.instance.isPageLogOn,
            onChanged: (value) {
              setState(() {
                MagpieLog.instance.isPageLogOn =
                    !MagpieLog.instance.isPageLogOn;
              });
            },
            activeTrackColor: Colors.orange,
            activeColor: Colors.deepOrange,
          ),
          Text(
            "isPageLogOn:是否打开页面展示圈选 \n开启跳转3秒后打开圈选页面",
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ])
      ],
    );
  }

  Widget buttons() {
    return Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
            height: 50,
            width: MediaQuery.of(context).size.width / 3,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  side: BorderSide.none, borderRadius: BorderRadius.zero),
              color: Colors.lightGreen,
              child: Text("跳过",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
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
            )),
        Container(
            height: 50,
            width: MediaQuery.of(context).size.width / 1.5 - 1,
            child: FlatButton(
              //minWidth: MediaQuery.of(context).size.width/3,
              shape: RoundedRectangleBorder(
                  side: BorderSide.none, borderRadius: BorderRadius.zero),
              color: Colors.deepOrange,
              child: Text("埋点",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
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
            )),
      ],
    ));
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
            secondary: Icon(Icons.remove),
            value: paramList[index].isChecked,
            title: Text(paramList[index].key,
                style: TextStyle(color: Colors.black54, fontSize: 13)),
            subtitle: Text(paramList[index].value,
                style: TextStyle(color: Colors.black54, fontSize: 11)),
            onChanged: (bool) {
              setState(() {
                paramList[index].isChecked = bool;
              });
            }));
      } else {
        widgetList.add(Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              GestureDetector(
                  onTap: () {
                    setState(() {
                      paramList[index].isPaneled = !paramList[index].isPaneled;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 10, 0, 0),
                    child: Row(children: <Widget>[
                      !paramList[index].isPaneled
                          ? Icon(Icons.add_circle_outline,
                              color: Colors.black54)
                          : Icon(Icons.remove_circle_outline,
                              color: Colors.black54),
                      Padding(
                          padding: EdgeInsets.fromLTRB(31, 0, 0, 0),
                          child: Text(paramList[index].key,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold)))

//                      !paramList[index].isPaneled
//                          ? Icon(Icons.keyboard_arrow_down)
//                          : Icon(Icons.keyboard_arrow_up),
                    ]),
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
