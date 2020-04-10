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
    return Scaffold(
        appBar: AppBar(
          title: Text('圈选配置列表（侧滑删除）'),
          centerTitle: true,
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                });
          }),
        ),
        body: Container(
          color: Color(0xFFf6f7fb),
          child: _getListView(),
        ));
  }

  ListView _getListView() => ListView.separated(
        itemCount: MagpieDataAnalysis.getListData().length,
        separatorBuilder: (context, index) {
          return Divider(
            height: 0,
          );
        },
        itemBuilder: (BuildContext context, int position) {
          return _getItem(position);
        },
      );

  Container _getItem(int position) => Container(
      color: Colors.white,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Dismissible(
        onDismissed: (_) {
          MagpieDataAnalysis.getListData().removeAt(position);
        },
        direction: DismissDirection.endToStart,
        background: Container(
            color: Colors.deepOrange,
            child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  child: Text(
                    '删除',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  margin: EdgeInsets.fromLTRB(0, 0, 50, 0),
                ))),
        key: Key(MagpieDataAnalysis.getListData()[position].actionName),
        child: Padding(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '标识: ${MagpieDataAnalysis.getListData()[position].actionName}',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                Text(
                  '路由: ${MagpieDataAnalysis.getListData()[position].pagePath}',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                ),
                Text(
                  '描述: ${MagpieDataAnalysis.getListData()[position].description}',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Text(
                    '参数: ${MagpieDataAnalysis.getListData()[position].analysisData}',
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                ),
              ],
            )),
      ));
}
