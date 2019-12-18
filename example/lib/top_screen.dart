import 'package:example/states/count_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:magpie_log/interceptor/interceptor_circle_log.dart';
import 'package:magpie_log/interceptor/interceptor_state_log.dart';

class TopScreen extends StatefulWidget {
  @override
  _TopScreenState createState() => _TopScreenState();
}

class _TopScreenState extends State<TopScreen> {
  @override
  Widget build(BuildContext context) {
    maContext = context; //设置全局context 用于弹层
    return Scaffold(
      appBar: AppBar(
        title: Text('Magpie Log'),
      ),
      body: Column(children: [
        Text(
          "Redux Action:",
          style: TextStyle(
              fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        StoreConnector<CountState, int>(
          converter: (store) => store.state.count,
          builder: (context, count) {
            return Text(
              count.toString(),
              style: Theme.of(context).textTheme.display1,
            );
          },
        ),
        StoreConnector<CountState, VoidCallback>(
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
        Text(
          "Widget SetState:",
          style: TextStyle(
              fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        AddTextWidget()
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/UnderScreen');
        },
        child: Icon(Icons.forward),
      ),
    );
  }
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
