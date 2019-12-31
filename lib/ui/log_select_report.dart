import 'package:flutter/material.dart';

///选择数据上报方式

class MagpieSelectReport extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SelectReport();
  }
}

class _SelectReport extends State<MagpieSelectReport> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('修改数据上报方式'),
      ),
      body: Column(
        children: <Widget>[],
      ),
    );
  }
}
