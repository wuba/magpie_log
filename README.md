# Pub使用
### 1. Depend on it
Add this to your package's pubspec.yaml 
```  
dependencies:
 magpie_log: ^1.0.0
```

### 2. Install it
You can install packages from the command line:

```
$ flutter pub get
```

Alternatively, your editor might support flutter pub get. Check the docs for your editor to learn more.

### 3. Import it
Now in your Dart code, you can use:

```
import 'package:magpie_log/magpie_log.dart';
```
# Dart使用方式
在自己工程首页调用`MagpieLog.instance.init`初始化方法
```
Widget build(BuildContext context) {
    MagpieLog.instance.init(context, 
        ReportMethod.timing, 
        ReportChannel.natives,
        callback: _receiverMagpieData, 
        time: 1 * 60 * 1000,     
        count: 3);
    return Container();
}
```
### redux圈选使用方式
redux圈选 你的工程需要使用flutter-redux做状态管理
需要注入一个中间件`CircleMiddleWare`
```
final store = Store<AppState>(reducer,
      middleware: [CircleMiddleWare()], initialState: AppState.initState());
```


其中的AppState也就是store存储的数据集必须继承`LogState`
因为我们需要toJson方法才能更好的获取参数
```
class AppState extends LogState {
  Map<String, dynamic> toJson() => _$AppStateToJson(this);
}
```
随后就可以使用我们的redux圈选
### 页面圈选使用
需要注册navigator监听`LogObserver`，当然我们需要你显示的设置页面settings这样我们才能获取页面的唯一标识
```
MaterialApp(
    routes: {
      '/': (BuildContext context) => TopScreen(),
      '/UnderScreen': (BuildContext context) => UnderScreen(),
    },
    navigatorObservers: [
      LogObserver<AppState>(),
    ],
    title: 'Flutter Demo',
    theme: ThemeData(primarySwatch: Colors.deepOrange),
  ),
```
### setState()圈选使用

继承`WidgetLogState`即可实现对应方法
```
class AddTextState extends WidgetLogState<AddTextWidget> {
  @override
  Map<String, dynamic> toJson() {
    Map map = Map<String, dynamic>();
    map["count"] = count.toString();
    return map;
  }

  @override
  String getActionName() {
    return "AddText";
  }

  @override
  int getIndex() {
    return 0;
  }
}
```
# 详细文档参见
[magpie圈选埋点实现](http://ishare.58corp.com/#/articleDetail?id=6879)
