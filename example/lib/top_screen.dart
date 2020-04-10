import 'package:example/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:magpie_log/handler/statistics_handler.dart';
import 'package:magpie_log/interceptor/interceptor_state_log.dart';
import 'package:magpie_log/magpie_log.dart';
import 'package:redux/redux.dart';

import 'states/app_state.dart';

class TopScreen extends StatefulWidget {
  @override
  _TopScreenState createState() => _TopScreenState();
}

class _TopScreenState extends State<TopScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    MagpieExampleUtils().init(context);
    return DefaultTabController(
      length: choices.length,
      child: Scaffold(
          appBar: AppBar(
              title: Text("Magpie-Log"),
              centerTitle: true,
              bottom: TabBar(
                isScrollable: false,
                tabs: choices.map((Choice choice) {
                  return Tab(
                    child: Text(
                      '${choice.title}',
                      style: TextStyle(fontSize: 10),
                    ),
                    icon: Image.asset(choice.icon, height: 30, width: 30),
                  );
                }).toList(),
              )),
          body: TabBarView(children: <Widget>[
            reduxDemo(context),
            listDemo(context),
            stateDemo(context),
            manuallyDemo(context),
            pageDemo(context),
          ])),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final String icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Redux', icon: "images/redux.png"),
  const Choice(title: 'List', icon: "images/list.png"),
  const Choice(title: 'State', icon: "images/state.png"),
  const Choice(title: 'Verbose', icon: "images/verbose.png"),
  const Choice(title: 'Page', icon: "images/page.png"),
];

Widget demo(context, title, demoView, {description}) {
  return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
    Padding(
        padding: EdgeInsets.fromLTRB(15, 25, 15, 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text(
            "\n" + title,
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          Text(
            description != null ? "\n" + description : "",
            style: TextStyle(fontSize: 14, color: Colors.black54),
          )
        ])),
    Container(
      color: Color(0xFFf6f7fb),
      width: MediaQuery.of(context).size.width,
      child: Padding(
          padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
          child: Text(
            "示例:",
            style: TextStyle(fontSize: 14, color: Colors.black54),
          )),
    ),
    demoView,
  ]);
}

Widget reduxDemo(context) {
  return demo(
      context,
      "基于Redux的普通圈选展示",
      Padding(
          padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            StoreConnector<AppState, int>(
              converter: (store) => store.state.countState.count,
              builder: (context, count) {
                return Text(
                  count.toString(),
                  style: TextStyle(fontSize: 30, color: Colors.red),
                );
              },
            ),
            Container(
              margin: EdgeInsets.all(15),
              child: StoreConnector<AppState, VoidCallback>(
                converter: (store) {
                  return () => store.dispatch(LogAction(actionAddCount));
                },
                builder: (context, callback) {
                  return MaterialButton(
                    child: Text("数字+1",
                        style:
                            TextStyle(fontSize: 15, color: Colors.deepOrange)),
                    onPressed: callback,
                    color: Colors.white,
                    shape: Border.all(
                        color: Colors.deepOrange,
                        width: 2,
                        style: BorderStyle.solid),
                  );
                },
              ),
            ),
          ])),
      description: "原理：拦截redux分发action事件,插入中间件，进行统一埋点");
}

Widget listDemo(context) {
  return demo(
    context,
    "基于Redux的List圈选展示",
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
            })),
    description: "原理：redux圈选一样，说明一下处理list的圈选数据取的item里面bean值",
  );
}

Widget stateDemo(context) {
  return demo(
    context,
    "局部setState()操作圈选",
    Container(padding: EdgeInsets.all(15), child: AddTextWidget()),
    description: "原理：通过使用LogState，拦截setState事件进行统一埋点",
  );
}

Widget manuallyDemo(context) {
  return demo(
      context,
      "手动埋点展示",
      Container(
        margin: EdgeInsets.all(15),
        child: MaterialButton(
          color: Colors.white,
          shape: Border.all(
              color: Colors.deepOrange, width: 2, style: BorderStyle.solid),
          child: Text('手动埋点',
              style: TextStyle(fontSize: 15, color: Colors.deepOrange)),
          onPressed: () {
            // 手动埋点数据示例
            MagpieStatisticsHandler.instance.writeData({'data': '手动埋点数据示例'});
          },
        ),
      ));
}

Widget pageDemo(BuildContext context) {
  return demo(
      context,
      "页面级曝光统计",
      Container(
          margin: EdgeInsets.all(15),
          child: MaterialButton(
            color: Colors.white,
            shape: Border.all(
                color: Colors.deepOrange, width: 2, style: BorderStyle.solid),
            child: Text("跳转",
                style: TextStyle(fontSize: 15, color: Colors.deepOrange)),
            onPressed: () {
              Navigator.pushNamed(context, '/UnderScreen');
            },
          )),
      description: "原理：通过过NavigatorObserver监听页面push事件，现push页面后 默认0.5秒跳转圈选部分");
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
        Container(
          margin: EdgeInsets.all(15),
          child: MaterialButton(
            color: Colors.white,
            shape: Border.all(
              color: Colors.deepOrange,
              width: 2,
              style: BorderStyle.solid,
            ),
            child: Text("数字+1",
                style: TextStyle(fontSize: 15, color: Colors.deepOrange)),
            onPressed: () {
              setState(() {
                count++;
              });
            },
          ),
        ),
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

  @override
  int getIndex() {
    return 0;
  }
}
