import 'package:flutter/material.dart';
import 'package:magpie_log/file/data_analysis.dart';

///查看已圈选数据列表
class MagpieActionList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ActionListState();
}

class _ActionListState extends State<MagpieActionList> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text('已圈选数据列表'),
        ),
        body: Container(
          child: _getListView(),
        ));
  }

  ListView _getListView() => ListView.builder(
        itemCount: MagpieDataAnalysis().getListData().length,
        itemBuilder: (BuildContext context, int position) {
          return _getItem(position);
        },
      );

  Container _getItem(int position) => Container(
          child: Dismissible(
        onDismissed: (_) {
          MagpieDataAnalysis().getListData().removeAt(position);
        },
        direction: DismissDirection.endToStart,
        background: Container(
            color: Colors.red,
            child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  child: Text(
                    '删除',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        backgroundColor: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  margin: EdgeInsets.fromLTRB(0, 0, 50, 0),
                ))),
        key: Key(MagpieDataAnalysis().getListData()[position].actionName),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'ActionName: ${MagpieDataAnalysis().getListData()[position].actionName}',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Text(
                  'AnalysisData: ${MagpieDataAnalysis().getListData()[position].analysisData}',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ),
              Text(
                'Description: ${MagpieDataAnalysis().getListData()[position].description}',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Divider(
                  height: 1,
                  color: Colors.black54,
                ),
              )
            ],
          ),
        ),
      ));
}
