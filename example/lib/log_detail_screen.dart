import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magpie_log/file/data_analysis.dart';

/// 参数配置详情

class LogDetailScreen extends StatefulWidget {
  @override
  _LogDetailState createState() => _LogDetailState();
}

class _LogDetailState extends State<LogDetailScreen> {
  String checkLog, delLog, savePath;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      checkLog = 'is empty';
      savePath = 'is empty';
      delLog = 'is empty';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(title: Text('埋点数据详情')),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded(
                        child: checkWidget(),
                      ),
                      Expanded(child: saveWidget()),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.all(20),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: delActionLog(),
                      ),
                      Expanded(
                        child: clearData(),
                      )
                    ],
                  ))
            ],
          ),
        ));
  }

  Widget saveWidget() => SizedBox(
        height: 260,
        child: Column(
          children: <Widget>[
            MaterialButton(
              child: Text('保存圈选数据'),
              textColor: Colors.black54,
              color: Colors.blue[400],
              onPressed: () {
                MagpieDataAnalysis().saveData().then((data) async {
                  MagpieDataAnalysis().getSavePath().then((path) {
                    setState(() {
                      savePath = path;
                    });
                  });
                });
              },
            ),
            Container(
              child: Text(
                '圈选数据存放路径：$savePath',
                textAlign: TextAlign.left,
                softWrap: true,
                style: TextStyle(color: Colors.black87),
              ),
              margin: EdgeInsets.all(10),
            )
          ],
        ),
      );

  Widget checkWidget() => SizedBox(
        height: 260,
        child: Column(
          children: <Widget>[
            MaterialButton(
              child: Text(
                '查看圈选数据',
              ),
              textColor: Colors.black54,
              color: Colors.green[400],
              onPressed: () {
                MagpieDataAnalysis().readFileData().then((data) {
                  setState(() {
                    checkLog = data;
                  });
                });
              },
            ),
            Container(
              child: Text(
                '已圈选数据：$checkLog',
                textAlign: TextAlign.left,
                softWrap: true,
                style: TextStyle(color: Colors.black87),
              ),
              margin: EdgeInsets.all(10),
            )
          ],
        ),
      );

  TextEditingController actionController = TextEditingController();
  Widget delActionLog() => SizedBox(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '删除指定的圈选数据:',
              style: TextStyle(
                  color: Colors.orange,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            TextField(
              decoration: InputDecoration(
                  labelText: '请输入actionName', helperText: '删除须谨慎'),
              controller: actionController,
            ),
            MaterialButton(
              child: Text('删除'),
              textColor: Colors.white,
              color: Colors.red[700],
              onPressed: () {
                MagpieDataAnalysis()
                    .deleteActionData(actionName: actionController.text)
                    .then((code) {
                  if (code == 0) {
                    MagpieDataAnalysis().readFileData().then((data) {
                      setState(() {
                        checkLog = data;
                      });
                    });

                    Fluttertoast.showToast(
                        msg: '${actionController.text}删除成功',
                        toastLength: Toast.LENGTH_SHORT);
                  } else if (code == -1) {
                    Fluttertoast.showToast(
                        msg: 'ActionName不能为空', toastLength: Toast.LENGTH_SHORT);
                  } else if (code == -2) {
                    Fluttertoast.showToast(
                        msg: '${actionController.text}不存在',
                        toastLength: Toast.LENGTH_SHORT);
                  } else if (code == -3) {
                    Fluttertoast.showToast(
                        msg: '当前还暂未写入数据', toastLength: Toast.LENGTH_SHORT);
                  } else {
                    Fluttertoast.showToast(
                        msg: '${actionController.text}操作失败',
                        toastLength: Toast.LENGTH_SHORT);
                  }
                });
              },
            )
          ],
        ),
      );

  Widget clearData() => SizedBox(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '清除全部数据:',
              style: TextStyle(
                  color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Container(
              child: MaterialButton(
                child: Text('清除'),
                textColor: Colors.white,
                color: Colors.lightBlue,
                onPressed: () {
                  MagpieDataAnalysis().clearAnalysisData().then((value) {
                    MagpieDataAnalysis().readFileData().then((data) {
                      setState(() {
                        checkLog = data;
                      });
                    });
                  });
                },
              ),
              margin: EdgeInsets.all(25),
            )
          ],
        ),
      );
}
