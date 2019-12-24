import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magpie_log/interceptor/interceptor_state_log.dart';
import 'package:magpie_log/magpie_log.dart';

import 'states/app_state.dart';

class TopScreen extends StatefulWidget {
  @override
  _TopScreenState createState() => _TopScreenState();
}

void log(actionName, content) {
  print("MagpieLog=>$actionName:$content");
  Fluttertoast.showToast(
      msg: "MagpieLog==>\n$actionName:\n$content",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: Colors.deepOrange,
      textColor: Colors.white,
      fontSize: 16.0);
}

class _TopScreenState extends State<TopScreen> {
  @override
  Widget build(BuildContext context) {
    MagpieLog.instance.init(context, log);
    return Scaffold(
      appBar: AppBar(
        title: Text('Magpie Log'),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        reduxDemo(),
        stateDemo(),
        pageDemo(context),
        logDetail(context)
      ]),
    );
  }
}

Widget reduxDemo() {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(
      "Redux Action",
      style: TextStyle(
          fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
    ),
    Text(
      "Redux类型埋点：拦截action事件进行统一埋点\n下面以系统count+1为例：",
      style: TextStyle(fontSize: 14, color: Colors.black),
    ),
    StoreConnector<AppState, int>(
      converter: (store) => store.state.countState.count,
      builder: (context, count) {
        return Text(
          count.toString(),
          style: Theme.of(context).textTheme.display1,
        );
      },
    ),
    StoreConnector<AppState, VoidCallback>(
      converter: (store) {
        return () => store.dispatch(LogAction.increment);
      },
      builder: (context, callback) {
        return MaterialButton(
          color: Colors.white,
          child: Text("Log"),
          onPressed: callback,
        );
      },
    ),
  ]);
}

Widget logDetail(BuildContext context) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(
      "Log detail",
      style: TextStyle(
          fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
    ),
    Text(
      "已圈选的数据详情页",
      style: TextStyle(fontSize: 14, color: Colors.black),
    ),
    MaterialButton(
      color: Colors.white,
      child: Text('数据操作',
          style: TextStyle(color: Colors.blueAccent, fontSize: 15)),
      onPressed: () {
        // MagpieDataAnalysis().readFileData().then((allLog) {
        //   setState(() {
        //     readAllLog = allLog;
        //   });
        // });

        Navigator.pushNamed(context, '/UnStart/log_detail');
      },
    ),
  ]);
}

Widget stateDemo() {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(
      "\nWidget SetState:",
      style: TextStyle(
          fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
    ),
    Text(
      "state类型埋点：拦截setState事件进行统一埋点\n下面以系统count+1为例：",
      style: TextStyle(fontSize: 14, color: Colors.black),
    ),
    AddTextWidget()
  ]);
}

Widget pageDemo(BuildContext context) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(
      "\nPage push pop:",
      style: TextStyle(
          fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
    ),
    Text(
      "Page类型埋点：监听页面push事件，现push页面后 默认3秒跳转圈选部分",
      style: TextStyle(fontSize: 14, color: Colors.black),
    ),
    MaterialButton(
      color: Colors.white,
      child: Text("页面跳转"),
      onPressed: () {
        Navigator.pushNamed(context, '/UnderScreen');
      },
    )
  ]);
}

class AddTextWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddTextState();
  }
}

class AddTextState extends WidgetLogState<AddTextWidget> {
  int count;

  @override
  void initState() {
    count = 0;
    super.initState();
  }

  @override
  Widget onBuild(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          count.toString(),
          style: Theme.of(context).textTheme.display1,
        ),
        MaterialButton(
          color: Colors.white,
          child: Text("Log"),
          onPressed: () {
            setState(() {
              count++;
            });
          },
        )
      ],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    Map map = Map<String, dynamic>();
    map["count"] = count.toString();
    return map;
  }

  @override
  String getActionName() {
    return "AddText";
  }
}
