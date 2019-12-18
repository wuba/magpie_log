import 'package:flutter/material.dart';
import 'package:magpie_log/file/data_analysis.dart';
import 'package:magpie_log/interceptor/interceptor_circle_log.dart';
import 'package:magpie_log/interceptor/interceptor_state_log.dart';

import 'package:redux/redux.dart';

class LogScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  final Store<LogState> store;
  final dynamic action;
  final NextDispatcher next;

  final String actionName;
  final Function func;
  final WidgetLogState state;

  const LogScreen(
      {Key key,
      this.data,
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
  String log = "";

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
          new Text(
            "Pramas to choose:",
            style: TextStyle(
                fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
          ),
//          new Text(
//            widget.data.toString(),
//          ),
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
          new Text(
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
                  widget.next != null
                      ? widget.next(widget.action)
                      : widget.state.setRealState(widget.func);
                  Navigator.pop(context);
                },
              ),
              MaterialButton(
                color: Colors.white,
                child: Text("log",
                    style: TextStyle(fontSize: 18, color: Colors.deepOrange)),
                onPressed: () {
                  if (widget.next == null) {
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

                    log = widget.action != null
                        ? widget.action.toString() + ":$log"
                        : widget.actionName + ":$log";

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
          new Text(
            "Config for log:",
            style: TextStyle(
                fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Text(log)
        ],
      ),
    );
  }

  Function _redLog() {}
}
