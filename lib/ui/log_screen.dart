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

  ParamItem(this.key, this.value);
}

class _LogScreenState extends State<LogScreen> {
  List<ParamItem> paramList = [];
  String log = "", readAllLog, readActionLog;

  @override
  void initState() {
    widget.data.forEach((k, v) {
      paramList.add(ParamItem(k, v.toString()));
    });

    //TODO:已经配置过得直接展示
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('圈选页面'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Pramas to choose:",
            style: TextStyle(
                fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          SizedBox(
              height: 250,
              child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return CheckboxListTile(
                        value: paramList[index].isChecked,
                        title: Text(paramList[index].key),
                        subtitle: Text(paramList[index].value),
                        onChanged: (bool) {
                          setState(() {
                            paramList[index].isChecked = bool;
                          });
                        });
                  },
                  itemCount: paramList.length)),
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

                    if (widget.actionName != null) {
                      log = widget.actionName + ":$log";
                    } else if (widget.action != null) {
                      log = widget.action.toString() + ":$log";
                    } else {
                      debugPrint("error:no action key found!");
                    }
                  });

                  MagpieDataAnalysis().writeData('testAction', log);
                },
              ),
              IconButton(
                icon: Icon(Icons.accessible_forward),
                onPressed: () {
                  MagpieDataAnalysis().readFileData().then((allLog) {
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
                      .readActionData('testAction')
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
                  widget.action.toString() + ":$log",
                  textAlign: TextAlign.center,
                ),
                margin: const EdgeInsets.all(10),
              ),
              Container(
                child: Text(
                  widget.action.toString() + " readActionLog = $readActionLog",
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
        ],
      ),
    );
  }
}
