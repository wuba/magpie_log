import 'package:example/states/count_state.dart';
import 'package:example/under_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:magpie_log/interceptor/interceptor_circle_log.dart';


class TopScreen extends StatefulWidget {
  @override
  _TopScreenState createState() => _TopScreenState();
}

class _TopScreenState extends State<TopScreen> {
  @override
  Widget build(BuildContext context) {
    maContext = context;//设置全局context 用于弹层
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Screen'),
      ),
      body: Column(children: [
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
              child: Text("Log"),
              onPressed: callback,
            );
          },
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return UnderScreen();
          }));
        },
        child: Icon(Icons.forward),
      ),
    );
  }
}
