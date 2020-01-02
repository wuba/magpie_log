import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magpie_log/file/data_analysis.dart';
import 'package:magpie_log/magpie_constants.dart';
import 'package:magpie_log/magpie_log.dart';
import 'package:magpie_log/ui/log_select_report.dart';

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
    return Scaffold(
      appBar: AppBar(title: Text('圈选配置')),
      body: Container(
          color: Color(0x66CCCCCC),
          child: ListView(
            children: <Widget>[
              listItem("查看圈选数据",
                  leftWidget: Icon(
                    Icons.list,
                    color: Colors.black26,
                  ), onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    settings: RouteSettings(name: MagpieConstants.actionScreen),
                    builder: (BuildContext context) {
                      return MagpieActionList();
                    }));
              }),
              listItem("保存圈选数据至文件",
                  leftWidget: Icon(
                    Icons.save_alt,
                    color: Colors.black26,
                  ), onTap: () {
                MagpieDataAnalysis().saveData().then((data) async {
                  MagpieDataAnalysis().getSavePath().then((path) {
                    Fluttertoast.showToast(
                        msg: '数据已保存至：$path', toastLength: Toast.LENGTH_SHORT);
                  });
                });
              }),
              listItem("清除全部圈选数据",
                  leftWidget: Icon(
                    Icons.delete_forever,
                    color: Colors.black26,
                  ), onTap: () {
                MagpieDataAnalysis().clearAnalysisData().then((value) {
                  Fluttertoast.showToast(
                      msg: '数据清除成功～', toastLength: Toast.LENGTH_SHORT);
                });
              }),
              listItem("选择数据上报方式",
                  leftWidget: Icon(
                    Icons.delete_forever,
                    color: Colors.black26,
                  ), onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    settings: RouteSettings(
                        name: MagpieConstants.selectChannelScreen),
                    builder: (BuildContext context) {
                      return MagpieSelectReport();
                    }));
              }),
              listItem("打开Debug模式",
                  content: "是否打开圈选 关闭上传埋点 \n需重启才能开启",
                  leftWidget: Icon(
                    Icons.adjust,
                    color: Colors.black26,
                  ),
                  rightWidget: Switch(
                    value: MagpieLog.instance.isDebug,
                    onChanged: (value) {
                      setState(() {
                        MagpieLog.instance.isDebug =
                            !MagpieLog.instance.isDebug;
                      });
                    },
                    activeTrackColor: Colors.orange,
                    activeColor: Colors.deepOrange,
                  )),
              listItem("打开页面圈选",
                  content: "是否打开页面展示圈选 \n开启跳转0.5秒后打开圈选页面",
                  leftWidget: Icon(
                    Icons.content_copy,
                    color: Colors.black26,
                  ),
                  rightWidget: Switch(
                    value: MagpieLog.instance.isPageLogOn,
                    onChanged: (value) {
                      setState(() {
                        MagpieLog.instance.isPageLogOn =
                            !MagpieLog.instance.isPageLogOn;
                      });
                    },
                    activeTrackColor: Colors.orange,
                    activeColor: Colors.deepOrange,
                  )),
            ],
          )),
    );
  }

  Widget listItem(String title,
      {Widget leftWidget,
      String content,
      Widget rightWidget,
      GestureTapCallback onTap}) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            height: 50,
            color: Colors.white,
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
            padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
            child: Row(
              children: <Widget>[
                leftWidget != null
                    ? leftWidget
                    : Icon(
                        Icons.settings,
                        color: Colors.black26,
                      ),
                Container(width: 5),
                Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                      Container(
                        child: Text(title),
                      )
                    ])),
                rightWidget != null
                    ? rightWidget
                    : Icon(
                        Icons.chevron_right,
                        color: Colors.black26,
                      ),
              ],
            )));
  }
}
