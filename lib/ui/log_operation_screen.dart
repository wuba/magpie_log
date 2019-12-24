import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magpie_log/file/data_analysis.dart';
import 'package:magpie_log/magpie_constants.dart';

/// 已圈选数据操作页面
class MagpieLogOperation extends StatefulWidget {
  @override
  _LogOperationState createState() => _LogOperationState();
}

class _LogOperationState extends State<MagpieLogOperation> {
  String checkLog, delLog, savePath;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(title: Text('埋点数据详情')),
        body: SingleChildScrollView(
            child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: <Widget>[
              Container(
                child: checkWidget(),
                margin: EdgeInsets.all(20),
              ),
              Container(
                child: saveWidget(),
                margin: EdgeInsets.all(20),
              ),
              Container(
                child: clearData(),
                margin: EdgeInsets.all(20),
              ),
            ],
          ),
        )));
  }

  Widget saveWidget() => SizedBox(
        child: Column(
          children: <Widget>[
            MaterialButton(
              child: Text('保存圈选数据'),
              textColor: Colors.black54,
              color: Colors.blue[400],
              onPressed: () {
                MagpieDataAnalysis().saveData().then((data) async {
                  MagpieDataAnalysis().getSavePath().then((path) {
                    Fluttertoast.showToast(
                        msg: '数据已保存至：$path', toastLength: Toast.LENGTH_SHORT);
                  });
                });
              },
            ),
          ],
        ),
      );

  Widget checkWidget() => SizedBox(
        child: Column(
          children: <Widget>[
            MaterialButton(
              child: Text(
                '查看圈选数据',
              ),
              textColor: Colors.black54,
              color: Colors.green[400],
              onPressed: () {
                Navigator.pushNamed(context, MagpieConstants.ACTION_LIST_PAGE);
              },
            ),
          ],
        ),
      );

  Widget clearData() => SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: MaterialButton(
                child: Text('清除全部圈选数据'),
                textColor: Colors.white,
                color: Colors.lightBlue,
                onPressed: () {
                  MagpieDataAnalysis().clearAnalysisData().then((value) {
                    Fluttertoast.showToast(
                        msg: '数据清除成功～', toastLength: Toast.LENGTH_SHORT);
                  });
                },
              ),
            )
          ],
        ),
      );
}
