import 'package:flutter/material.dart';
import 'package:magpie_log/interceptor/interceptor_circle_log.dart';
import 'package:redux/redux.dart';

class LogScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final Store<LogState> store;
  final dynamic action;
  final NextDispatcher next;

  const LogScreen({Key key, this.data, this.store, this.action, this.next})
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
  String log;

  @override
  void initState() {
    widget.data.forEach((k, v) {
      paramList.add(ParamItem(k, v.toString()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('圈选页面'),
      ),
      body: Column(
        children: <Widget>[
          new Text(
            widget.data.toString(),
          ),
          Row(
            children: <Widget>[
              MaterialButton(
                child: Text("Pass",
                    style: TextStyle(fontSize: 18, color: Colors.lightGreen)),
                onPressed: () {
                  widget.next(widget.action);
                  Navigator.pop(context);
                },
              ),
              MaterialButton(
                child: Text("log",
                    style: TextStyle(fontSize: 18, color: Colors.deepOrange)),
                onPressed: () {
                  setState(() {
                    StringBuffer logs = StringBuffer();
                    paramList.forEach((param) {
                      if (param.isChecked) {
                        logs.write(param.key + ",");
                      }
                    });
                    log = "[" + logs.toString() + "]";
                  });
                },
              )
            ],
          ),
          SizedBox(
              height: 400,
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
          Text(widget.action.toString() + ":$log")
        ],
      ),
    );
  }
}
