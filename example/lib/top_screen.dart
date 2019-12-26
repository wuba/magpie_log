import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magpie_log/interceptor/interceptor_state_log.dart';
import 'package:magpie_log/magpie_log.dart';
import 'package:magpie_log/magpie_constants.dart';
import 'package:redux/redux.dart';

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
    return DefaultTabController(
      length: choices.length,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Magpie Log'),
            bottom: TabBar(
              isScrollable: false,
              tabs: choices.map((Choice choice) {
                return Tab(
                  child: Text(
                    '${choice.title}',
                    style: TextStyle(fontSize: 10),
                  ),
                  icon: Icon(
                    choice.icon,
                    size: 30,
                  ),
                );
              }).toList(),
            ),
          ),
          body: TabBarView(children: <Widget>[
            reduxDemo(),
            listDemo(),
            stateDemo(),
            manuallyDemo(),
            pageDemo(context),
          ])),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Redux', icon: Icons.group_work),
  const Choice(title: 'List', icon: Icons.list),
  const Choice(title: 'State', icon: Icons.adjust),
  const Choice(title: 'verbose', icon: Icons.colorize),
  const Choice(title: '页面', icon: Icons.content_copy),
];

Widget reduxDemo() {
  return Padding(
      padding: EdgeInsets.fromLTRB(50, 30, 50, 30),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text(
          "\n基于Redux的普通圈选展示",
          style: TextStyle(
              fontSize: 18, color: Colors.black54, fontWeight: FontWeight.bold),
        ),
        Text(
          "\n原理：拦截redux分发action事件,插入中间件，进行统一埋点\n\n示例：以系统count+1为例：\n",
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        StoreConnector<AppState, int>(
          converter: (store) => store.state.countState.count,
          builder: (context, count) {
            return Text(
              count.toString(),
              style: TextStyle(fontSize: 30, color: Colors.red),
            );
          },
        ),
        StoreConnector<AppState, VoidCallback>(
          converter: (store) {
            return () => store.dispatch(LogAction(actionAddCount));
          },
          builder: (context, callback) {
            return MaterialButton(
              color: Colors.deepOrange,
              child: Text("数字+1",
                  style: TextStyle(fontSize: 15, color: Colors.white)),
              onPressed: callback,
            );
          },
        ),
      ]));
}

Widget listDemo() {
  return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
    Padding(
        padding: EdgeInsets.fromLTRB(50, 30, 50, 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text(
            "\n基于Redux的List圈选展示",
            style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "\n原理和redux圈选一样，说明一下处理list的圈选数据取的item里面bean值\n\n示例：如下简单列表\n",
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ])),
    Expanded(
        child: StoreConnector<AppState, Store<AppState>>(
            converter: (store) => store,
            builder: (context, store) {
              return ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    return new ListTile(
                        selected: store.state.listState[index].isChecked,
                        onTap: () {
                          store.dispatch(
                              LogAction(actionListClick, index: index));
                        },
                        title: Center(
                            child: Text(store.state.listState[index].title,
                                style: store.state.listState[index].isChecked
                                    ? TextStyle(
                                        fontSize: 14, color: Colors.deepOrange)
                                    : TextStyle(
                                        fontSize: 14, color: Colors.black54))));
                  },
                  separatorBuilder: (context, index) {
                    return Padding(
                        padding: EdgeInsets.only(left: 0, right: 0),
                        child: Divider(height: 1));
                  },
                  itemCount: store.state.listState.length);
            }))
  ]);
}

Widget stateDemo() {
  return Padding(
      padding: EdgeInsets.fromLTRB(50, 30, 50, 30),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text(
          "\n局部setState()操作圈选",
          style: TextStyle(
              fontSize: 18, color: Colors.black54, fontWeight: FontWeight.bold),
        ),
        Text(
          "\n原理：通过使用LogState，拦截setState事件进行统一埋点\n\n示例：以系统count+1为例：\n",
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        AddTextWidget()
      ]));
}

Widget manuallyDemo() {
  return Padding(
    padding: EdgeInsets.fromLTRB(50, 30, 50, 30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          '手动埋点展示 \n 示例：',
          style: TextStyle(
              fontSize: 18, color: Colors.black54, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.all(30),
          child: MaterialButton(
            color: Colors.deepOrange,
            child: Text('手动埋点',
                style: TextStyle(fontSize: 15, color: Colors.white)),
            onPressed: () {
              //TODO 手动埋点数据示例
            },
          ),
        )
      ],
    ),
  );
}

Widget pageDemo(BuildContext context) {
  return Padding(
      padding: EdgeInsets.fromLTRB(50, 30, 50, 30),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text(
          "\n页面级曝光统计",
          style: TextStyle(
              fontSize: 18, color: Colors.black54, fontWeight: FontWeight.bold),
        ),
        Text(
          "\n原理：通过过NavigatorObserver监听页面push事件，现push页面后 默认0.5秒跳转圈选部分\n\n示例：点击跳转页面\n",
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        MaterialButton(
          color: Colors.deepOrange,
          child:
              Text("跳转", style: TextStyle(fontSize: 15, color: Colors.white)),
          onPressed: () {
            Navigator.pushNamed(context, '/UnderScreen');
          },
        )
      ]));
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          count.toString(),
          style: TextStyle(fontSize: 30, color: Colors.red),
        ),
        MaterialButton(
          color: Colors.deepOrange,
          child:
              Text("数字+1", style: TextStyle(fontSize: 15, color: Colors.white)),
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
