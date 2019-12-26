import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magpie_log/file/data_analysis.dart';
import 'package:magpie_log/magpie_constants.dart';
import 'package:magpie_log/magpie_log.dart';

import 'log_actiion_list.dart';

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
              switches()
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
                Navigator.of(context).push(MaterialPageRoute(
                    settings: RouteSettings(name: MagpieConstants.actionScreen),
                    builder: (BuildContext context) {
                      return MagpieActionList();
                    }));
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

  Widget switches() {
    return Column(
      children: <Widget>[
        Row(children: <Widget>[
          Switch(
            value: MagpieLog.instance.isDebug,
            onChanged: (value) {
              setState(() {
                MagpieLog.instance.isDebug = !MagpieLog.instance.isDebug;
              });
            },
            activeTrackColor: Colors.orange,
            activeColor: Colors.deepOrange,
          ),
          Text(
            "isDebug:是否打开圈选 关闭上传埋点 \n需重启才能开启",
            style: TextStyle(fontSize: 12, color: Colors.black54),
          )
        ]),
        Row(children: <Widget>[
          Switch(
            value: MagpieLog.instance.isPageLogOn,
            onChanged: (value) {
              setState(() {
                MagpieLog.instance.isPageLogOn =
                !MagpieLog.instance.isPageLogOn;
              });
            },
            activeTrackColor: Colors.orange,
            activeColor: Colors.deepOrange,
          ),
          Text(
            "isPageLogOn:是否打开页面展示圈选 \n开启跳转0.5秒后打开圈选页面",
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ])
      ],
    );
  }
}
