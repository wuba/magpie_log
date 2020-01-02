import 'package:flutter/material.dart';
import 'package:magpie_log/handler/statistics_handler.dart';
import 'package:magpie_log/model/analysis_model.dart';

///选择数据上报方式

class MagpieSelectReport extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SelectReport();
  }
}

class _SelectReport extends State<MagpieSelectReport> {
  // int _totalNum, _minNum, _secsNum;

  TextEditingController _totalCon = TextEditingController(),
      _minCon = TextEditingController(),
      _secsCon = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _totalCon.addListener(() {
    //   int value = int.parse(_totalCon.text);
    //   if (value <= 0) {
    //     Fluttertoast.showToast(msg: '参数必须设置大于0');
    //     _totalCon.clear();
    //     return;
    //   }
    //   _totalNum = value;
    // });

    // _minCon.addListener(() {
    //   int value = int.parse(_minCon.text);
    //   if (value <= 0) {
    //     Fluttertoast.showToast(msg: '参数必须设置大于0');
    //     _minCon.clear();
    //     return;
    //   }
    //   if (value < 60) {
    //     Fluttertoast.showToast(msg: 'secs必须设置为60');
    //     _minCon.clear();
    //   } else {
    //     _minNum = value;
    //   }
    // });

    // _secsCon.addListener(() {
    //   int value = int.parse(_secsCon.text);
    //   if (value <= 0) {
    //     Fluttertoast.showToast(msg: '参数必须设置大于0');
    //     _secsCon.clear();
    //     return;
    //   }
    //   _secsNum = value;
    // });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text('修改数据上报方式'),
        ),
        body: SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      '选择数据上报通道：',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(5, 5, 5, 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          RadioListTile(
                            value: 0,
                            groupValue: _channelType,
                            activeColor: Colors.orangeAccent,
                            title: Text(
                              'Flutter channel',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '通过Flutter端上报圈选统计数据',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 12),
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            selected: _channelType == 0,
                            onChanged: (value) {
                              _changeChannel(value);
                            },
                          ),
                          RadioListTile(
                            value: 1,
                            groupValue: _channelType,
                            activeColor: Colors.orangeAccent,
                            title: Text(
                              'Native channel',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '通过Native message Channel上报圈选统计数据',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 12),
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            selected: _channelType == 1,
                            onChanged: (value) {
                              _changeChannel(value);
                            },
                          ),
                        ],
                      )),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      '选择数据上报方式：',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        RadioListTile(
                          value: 0,
                          groupValue: _methodType,
                          activeColor: Colors.orangeAccent,
                          title: Text(
                            '每条上报',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '每次圈选数据触发后立刻上报',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 12),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          selected: _methodType == 0,
                          onChanged: (value) {
                            _changeMethod(value);
                          },
                        ),
                        RadioListTile(
                          value: 1,
                          groupValue: _methodType,
                          activeColor: Colors.orangeAccent,
                          title: Text(
                            '定时上报',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                              '设置定时周期，定时上报周期内统计的圈选数据。默认定时周期：2 * 60 * 1000ms',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 12)),
                          controlAffinity: ListTileControlAffinity.leading,
                          selected: _methodType == 1,
                          onChanged: (value) {
                            _changeMethod(value);
                          },
                        ),
                        // _buildTimeWidget(),
                        RadioListTile(
                          value: 2,
                          groupValue: _methodType,
                          activeColor: Colors.orangeAccent,
                          title: Text(
                            '计数上报',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('设置统计数量阈值，达到阈值后自动上报圈选数据',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 12)),
                          controlAffinity: ListTileControlAffinity.leading,
                          selected: _methodType == 2,
                          onChanged: (value) {
                            _changeMethod(value);
                          },
                        ),
                        // _buildTotalWidget(),
                      ],
                    ),
                  )
                ],
              )),
        ));
  }

  Widget _buildTimeWidget() {
    if (_methodType == 1) {
      return Container(
        margin: EdgeInsets.fromLTRB(30, 5, 20, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '设置间隔时间：',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
            Container(
              width: 40,
              child: TextField(
                maxLines: 1,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(helperText: 'min'),
                controller: _minCon,
                style: TextStyle(fontSize: 12, color: Colors.black, height: 1),
              ),
            ),
            Text(
              '  *  ',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
            Container(
              width: 40,
              child: TextField(
                maxLines: 1,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 12, color: Colors.black, height: 1),
                decoration:
                    InputDecoration(labelText: '1 - 60', helperText: 'secs'),
                controller: _secsCon,
              ),
            ),
            Text(
              '  *  1000ms',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildTotalWidget() {
    if (_methodType == 2) {
      return Container(
        margin: EdgeInsets.fromLTRB(30, 5, 20, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '设置数据达到：',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
            Container(
              width: 40,
              child: TextField(
                maxLines: 1,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 12, color: Colors.black, height: 1),
                controller: _totalCon,
              ),
            ),
            Text(
              '  条时上报',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.black),
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  int _channelType =
      MagpieStatisticsHandler.instance.reportChannel == ReportChannel.natives
          ? 1
          : 0;
  int _methodType = _getReportMethod();

  void _changeChannel(int value) {
    setState(() {
      _channelType = value;
    });

    if (value == 1) {
      MagpieStatisticsHandler.instance.setReportChannel(ReportChannel.natives);
    } else {
      MagpieStatisticsHandler.instance.setReportChannel(ReportChannel.flutter);
    }
  }

  void _changeMethod(int value) {
    setState(() {
      _methodType = value;
    });

    if (value == 1) {
      MagpieStatisticsHandler.instance.setReportMethod(ReportMethod.timing);
    } else if (value == 2) {
      MagpieStatisticsHandler.instance.setReportMethod(ReportMethod.total);
    } else {
      MagpieStatisticsHandler.instance.setReportMethod(ReportMethod.each);
    }
  }

  static int _getReportMethod() {
    if (MagpieStatisticsHandler.instance.reportMethod == ReportMethod.timing) {
      return 1;
    } else if (MagpieStatisticsHandler.instance.reportMethod ==
        ReportMethod.total) {
      return 2;
    } else {
      return 0;
    }
  }
}
