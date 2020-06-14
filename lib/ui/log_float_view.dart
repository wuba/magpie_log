import 'package:flutter/material.dart';
import 'package:magpie_log/magpie_log.dart';

import '../magpie_constants.dart';
import 'log_operation_screen.dart';

///时间列表坦弹层页面
class FloatEntry {
  static final FloatEntry _instance = FloatEntry();

  static FloatEntry get singleton => _instance;
  OverlayEntry _entry;
  GlobalKey<_DraggableBtnState> childKey = GlobalKey();

  showOverlayEntry() {
    try {
      _entry?.remove();
    } catch (e) {
      debugPrint(e.toString());
    }
    if (_entry == null) {
      _entry = new OverlayEntry(builder: (context) {
        return DraggableBtn(
          key: childKey,
          child: getChild(),
          initOffset: Offset(MediaQuery.of(context).size.width - 200, 300),
        );
      });
    }
    MagpieLog.instance.getCurrentRoute().navigator.overlay.insert(_entry);
  }

  ///弹层的核心组件
  Widget getChild() {
    return Container(
        width: 200,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Color(0xAA9BBBBBB),
            blurRadius: 5.0,
            offset: Offset(1.0, 1.0),
          ),
        ], borderRadius: BorderRadius.circular(3), color: Color(0xAAFFFFFF)),
        alignment: Alignment.center,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _getListView()));
  }

  ///弹层的列表组件开发
  List<Widget> _getListView() {
    List<Widget> listWidget = [];
    listWidget.add(Container(
      height: 30,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
          color: Color(0x99ff552e),
          borderRadius: BorderRadius.vertical(top: Radius.circular(3))),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Text("事件列表",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    decoration: TextDecoration.none,
                  ))),
          GestureDetector(
            child: Container(
              padding: EdgeInsets.only(right: 10),
              child: Text(
                "配置",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            onTap: () {
              MagpieLog.instance.getCurrentRoute().navigator.push(
                  MaterialPageRoute(
                      settings:
                          RouteSettings(name: MagpieConstants.operationScreen),
                      builder: (BuildContext context) {
                        return MagpieLogOperation();
                      }));
            },
          ),
          GestureDetector(
            child: Icon(Icons.close, color: Colors.white),
            onTap: () {
              _entry?.remove();
            },
          )
        ],
      ),
    ));

    for (String key in MagpieLog.instance.actionListMap.keys) {
      listWidget.add(GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Container(
            width: 200,
            padding: EdgeInsets.all(10),
            child: Center(
              child: Text(
                key,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black45,
                  decoration: TextDecoration.none,
                ),
              ),
            )),
        onTap: () {
          MagpieLog.instance
              .getCurrentRoute()
              .navigator
              .push(MagpieLog.instance.actionListMap[key]);

          MagpieLog.instance.removeFromActionList(key);
          refresh();
        },
      ));
    }

    return listWidget;
  }

  void refresh() {
    // ignore: invalid_use_of_protected_member
    childKey.currentState.setState(() {
      childKey.currentState.child = getChild();
    });
  }
}

///拖拽控件
class DraggableBtn extends StatefulWidget {
  final Widget child;
  final Offset initOffset;
  final Offset fullScreenOffset;

  const DraggableBtn({
    Key key,
    @required this.child,
    this.initOffset,
    this.fullScreenOffset = Offset.zero,
  }) : super(key: key);

  @override
  _DraggableBtnState createState() => _DraggableBtnState(child);
}

class _DraggableBtnState extends State<DraggableBtn>
    with SingleTickerProviderStateMixin {
  var _animController;
  var _scaleAnim;
  var _left = 50.0;
  var _top = 50.0;
  var globalKey = GlobalKey();
  var childWidth;
  var childHeight;
  Widget child;

  _DraggableBtnState(this.child);

  @override
  void initState() {
    _left = widget.initOffset.dx;
    _top = widget.initOffset.dy;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      RenderBox renderBox = globalKey.currentContext.findRenderObject();
      childWidth = renderBox.size.width;
      childHeight = renderBox.size.height;
    });
    _animController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.0).animate(_animController);
    super.initState();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          left: _left,
          top: _top,
          child: Draggable(
            childWhenDragging: Container(),
            feedback: ScaleTransition(scale: _scaleAnim, child: child),
            child: Container(
              key: globalKey,
              child: child,
            ),
            onDragStarted: () {
              _animController.forward();
            },
            onDragCompleted: () {},
            onDraggableCanceled: (v, offset) {
              debugPrint("offset y ${offset.dy}");
              var size = MediaQuery.of(context).size;
              setState(() {
                _left = offset.dx - widget.fullScreenOffset.dx;
                _top = offset.dy - widget.fullScreenOffset.dy;
                if (_left < 0) _left = 0;
                if (_left > size.width - childWidth) {
                  _left = size.width - childWidth;
                }
                if (_top < 0) _top = 0;
                if (_top > size.height - childHeight) {
                  _top = size.height - childHeight;
                }
              });
            },
          ),
        )
      ],
    );
  }
}
