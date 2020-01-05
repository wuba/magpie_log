import 'dart:convert' as convert;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magpie_log/file/data_analysis.dart';
import 'package:magpie_log/interceptor/interceptor_state_log.dart';
import 'package:magpie_log/magpie_constants.dart';
import 'package:magpie_log/magpie_log.dart';
import 'package:magpie_log/model/analysis_model.dart';
import 'package:redux/redux.dart';
import 'package:rubber/rubber.dart';

import 'log_operation_screen.dart';

class LogScreen extends StatefulWidget {
  //通用参数
  final String logType; //埋点类型
  final Map<String, dynamic> data;
  final String actionName;
  final String pagePath;

  //circleLogType参数
  final dynamic action; //没有actionName用action替代
  final Store<LogState> store;
  final NextDispatcher next;

  //stateLogType参数
  final Function func;
  final WidgetLogState state;

  const LogScreen(
      {Key key,
      @required this.data,
      @required this.logType,
      @required this.actionName,
      this.store,
      this.pagePath,
      this.action,
      this.next,
      this.func,
      this.state})
      : super(key: key);

  @override
  _LogScreenState createState() => _LogScreenState();
}

class ParamItem {
  String key;
  String value;
  bool isChecked; //是否选中
  bool isPaneled; //是否展开
  List<ParamItem> paramItems; //子参数item

  ParamItem(this.key, this.value,
      {this.paramItems, this.isPaneled = false, this.isChecked = false});
}

class _LogScreenState extends State<LogScreen>
    with SingleTickerProviderStateMixin {
  //抽屉滚动监听
  RubberAnimationController _controller;
  ScrollController _scrollController = ScrollController();

  String title = ""; //标题展示
  String description = ""; //描述展示
  String type = ""; //埋点类型展示
  bool isExpanded = false; //抽屉是否打开
  bool isModify = true; //是否是修改状态

  List<ParamItem> paramList = []; //参数列表数据

  @override
  void initState() {
    //埋点类型判断
    switch (widget.logType) {
      case pageType:
        title = "页面圈选";
        break;
      case reduxType:
        title = "点击圈选-Redux";
        break;
      case stateType:
        title = "点击圈选-State";
        break;
    }
    type = "${widget.logType}($title)";
    //初始化抽屉组件
    _controller = RubberAnimationController(
        vsync: this,
        halfBoundValue: AnimationControllerValue(percentage: 0.9),
        lowerBoundValue: AnimationControllerValue(pixel: 205),
        duration: Duration(milliseconds: 200));
    _controller.animationState.addListener(_stateListener);

    //初始化已有埋点数据
    MagpieDataAnalysis.readActionData(
            actionName: widget.actionName, pagePath: widget.pagePath)
        .then((logModel) {
      Map map;
      if (null != logModel) {
        if (logModel.analysisData != null && logModel.analysisData != "") {
          map = convert.jsonDecode(logModel.analysisData);
        }
        description = logModel.description;
        isModify = false;
      }
      initParam(widget.data, map, paramList);
      setState(() {});
    });

    super.initState();
  }

  ///递归参数数据初始化
  bool initParam(Map data, Map logConfig, List<ParamItem> paramList) {
    if (data == null) return false;

    bool isPaneled = false; //是不是展开
    bool isParentPaneled = false; //父View是不是展开
    data.forEach((k, v) {
      List<ParamItem> paramList2 = [];
      bool isChecked = false;
      if (v is Map) {
        isPaneled =
            initParam(v, logConfig == null ? null : logConfig[k], paramList2);
      } else if (v is List && v != null && v.length > 0) {
        isPaneled = initParam(
            v[0],
            logConfig == null || logConfig[k] == null ? null : logConfig[k],
            paramList2);
      } else {
        if (logConfig != null && logConfig[k] != null && logConfig[k] == 1) {
          isChecked = true;
          isParentPaneled = true;
        }
      }
      paramList.add(ParamItem(k, v.toString(),
          paramItems: paramList2, isChecked: isChecked, isPaneled: isPaneled));
    });
    //自己施展开的或者父View是展开的都要返回true
    return isPaneled || isParentPaneled;
  }

  ///抽屉状态监听 改变按钮样式和展开收起事件
  void _stateListener() {
    switch (_controller.animationState.value) {
      case AnimationState.expanded:
      case AnimationState.half_expanded:
        setState(() {
          isExpanded = true;
        });
        break;
      case AnimationState.collapsed:
        setState(() {
          isExpanded = false;
        });
        break;
      case AnimationState.animating:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0x66000000),
        body: Column(children: <Widget>[
          Expanded(
              child: RubberBottomSheet(
            header: _getHeader(),
            headerHeight: 50,
            scrollController: _scrollController,
            lowerLayer: _getLowerLayer(),
            upperLayer: _getUpperLayer(),
            animationController: _controller,
          )),
          buttons(),
        ]));
  }

  ///抽屉头部组件
  Widget _getHeader() {
    return Container(
        height: 60,
        child: Stack(children: <Widget>[
          Container(
              color: Colors.deepOrange,
              padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Row(children: <Widget>[
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.white,
                    )),
                Container(width: 5),
                Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                      Container(
                        child: Text(title,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      )
                    ])),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          settings: RouteSettings(
                              name: MagpieConstants.operationScreen),
                          builder: (BuildContext context) {
                            return MagpieLogOperation();
                          }));
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                      child: Text('圈选配置',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    )),
              ])),
          GestureDetector(
              onTap: () {
                isExpanded ? _controller.collapse() : _controller.expand();
              },
              child: Center(
                  child: Container(
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.deepOrange),
                      //color: Colors.deepOrange,
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                      child: Icon(
                        isExpanded
                            ? Icons.vertical_align_bottom
                            : Icons.vertical_align_top,
                        color: Colors.white,
                      ))))
        ]));
  }

  ///抽屉背景
  Widget _getLowerLayer() {
    return GestureDetector(
        onTap: () {
          //Navigator.pop(context);
        },
        child: Container(
          decoration: BoxDecoration(color: Colors.transparent),
        ));
  }

  ///抽屉上层组件
  Widget _getUpperLayer() {
    return Container(
        color: Colors.white,
        child: MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: ListView(
              controller: _scrollController,
              children: initPanelList(paramList),
            )));
  }

  ///底部按钮
  Widget buttons() {
    return Container(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            getButtonItem("跳过", MediaQuery.of(context).size.width / 4 - 1,
                Colors.lightGreen, () {
              switch (widget.logType) {
                case pageType:
                  break;
                case stateType:
                  widget.state.setRealState(widget.func);
                  break;
                case reduxType:
                  widget.next(widget.action);
                  break;
              }
              Navigator.pop(context);
            }),
            getButtonItem(
                "保存", MediaQuery.of(context).size.width / 4 - 1, Colors.orange,
                () {
              MagpieDataAnalysis.saveData().then((data) async {
                MagpieDataAnalysis.getSavePath().then((path) {
                  Fluttertoast.showToast(
                      msg: '数据已保存至：$path', toastLength: Toast.LENGTH_SHORT);
                });
              });
            }),
            getButtonItem(
                isModify ? "埋点" : "修改",
                MediaQuery.of(context).size.width / 2,
                isModify ? Colors.deepOrange : Colors.redAccent, () {
              if (isModify) {
                if (widget.logType == stateType) {
                  widget.state.logStatus = 1;
                  widget.state.setRealState(() {});
                }

                Map map = Map();
                getLog(map, paramList);
                String log = convert.jsonEncode(map);

                String type = widget.logType;

                MagpieDataAnalysis
                    .writeData(AnalysisModel(
                        actionName: widget.actionName,
                        pagePath: widget.pagePath,
                        analysisData: log,
                        description: description,
                        type: type))
                    .then((value) {
                  Fluttertoast.showToast(msg: "埋点添加成功\n请及时保存！");

                  setState(() {
                    isModify = !isModify;
                  });
                });
              } else {
                setState(() {
                  isModify = !isModify;
                });
              }
            }),
          ],
        ));
  }

  ///底部按钮Button封装
  Widget getButtonItem(text, width, color, onPressed) {
    return Container(
        height: 45,
        width: width,
        child: FlatButton(
          shape: RoundedRectangleBorder(
              side: BorderSide.none, borderRadius: BorderRadius.zero),
          color: color,
          child: Text(text,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          onPressed: onPressed,
        ));
  }

  ///主体列表全组件
  List<Widget> initPanelList(List<ParamItem> paramList) {
    List<Widget> list = [];
    list.add(getBasicTitle("基础配置"));
    list.add(getBasicItem("事件标识: ", widget.actionName));
    list.add(getBasicItem("页面路径: ", widget.pagePath));
    list.add(getBasicItem("埋点类型: ", type));
    //描述信息TextField
    list.add(
      Padding(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
          child: Row(
            children: <Widget>[
              Text(
                "描述信息: ",
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.black26,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                  width: 200,
                  child: TextField(
                    enabled: isModify,
                    controller: TextEditingController(text: description),
                    onChanged: (text) {
                      description = text;
                    },
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                        hintStyle:
                            TextStyle(fontSize: 13, color: Colors.black26),
                        hintText: '如：列表页点击'),
                  )),
            ],
          )),
    );
    list.add(getBasicTitle("参数配置"));
    //添加所有参数view
    list.addAll(intChildList(paramList));
    return list;
  }

  Widget getBasicTitle(title) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 5, 5, 5),
      width: MediaQuery.of(context).size.width,
      color: Color(0x66CCCCCC),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 14, color: Colors.black54, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget getBasicItem(key, value) {
    return Padding(
        padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: Row(
          children: <Widget>[
            Text(
              key,
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.black26,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              value,
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }

  ///递归参数圈选列表
  List<Widget> intChildList(List<ParamItem> paramList) {
    List<Widget> widgetList = [];

    for (int index = 0; index < paramList.length; index++) {
      if (paramList[index].paramItems.length == 0) {
        widgetList.add(getFinalItem(paramList[index]));
      } else {
        widgetList.add(Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              GestureDetector(
                  onTap: () {
                    setState(() {
                      paramList[index].isPaneled = !paramList[index].isPaneled;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
                    child: Row(children: <Widget>[
                      !paramList[index].isPaneled
                          ? Icon(Icons.add_circle_outline,
                              size: 15, color: Colors.black54)
                          : Icon(Icons.remove_circle_outline,
                              size: 15, color: Colors.black54),
                      Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Text(paramList[index].key,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold)))
                    ]),
                  )),
              getPaneledItem(paramList[index].isPaneled, paramList[index])
            ]));
      }
    }

    return widgetList;
  }

  Widget getPaneledItem(bool isPaneled, ParamItem paramItem) {
    if (isPaneled) {
      return Padding(
          padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: intChildList(paramItem.paramItems)));
    } else {
      return Container();
    }
  }

  Widget getFinalItem(ParamItem paramItem) {
    if (!isModify) {
      if (paramItem.isChecked) {
        return Container(height: 40, child: getCheckBoxTile(paramItem));
      } else {
        return Container();
      }
    } else {
      return Container(height: 40, child: getCheckBoxTile(paramItem));
    }
  }

  Widget getCheckBoxTile(ParamItem paramItem) {
    return Row(children: <Widget>[
      Padding(
          padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
          child: Icon(
            Icons.remove,
            size: 15,
            color: isModify ? Colors.black54 : Colors.orange,
          )),
      Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Text(paramItem.key,
              style: TextStyle(
                  color: isModify ? Colors.black54 : Colors.orange,
                  fontSize: 13))),
      Expanded(
        child: Text(": " + paramItem.value,
            style: TextStyle(color: Colors.black26, fontSize: 13)),
      ),
      getCheckBox(paramItem)
    ]);
  }

  Widget getCheckBox(ParamItem paramItem) {
    return isModify
        ? Checkbox(
            value: paramItem.isChecked,
            onChanged: (bool) {
              setState(() {
                paramItem.isChecked = bool;
              });
            },
          )
        : Container();
  }

  ///生成日志递归
  bool getLog(Map map, List<ParamItem> paramList) {
    bool isChecked = false;
    paramList.forEach((param) {
      if (param.paramItems.length == 0 && param.isChecked == true) {
        map[param.key] = 1;
        isChecked = true;
      } else {
        Map childMap = Map();
        if (getLog(childMap, param.paramItems)) {
          map[param.key] = childMap;
          isChecked = true;
        }
      }
    });
    return isChecked;
  }
}
