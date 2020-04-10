A visualized dynamic programme for log collection based on flutter.

# Pub使用
### 1. Depend on it
Add this to your package's pubspec.yaml 
```  
dependencies:
 magpie_log: ^1.0.1
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
这里需要注意context必须是包含Navigator的context
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

# 待完善
1.服务端配合，动态化配置的上传和加载

2.级联赋值问题 导致日志参数和数据一样，可以增加用户配置

3.store 参数为空 级联圈参null不全问题

# 致谢

1.感谢PonnamKarthik的[fluttertoast](https://github.com/PonnamKarthik/FlutterToast)插件

2.感谢Rubber的[rubber](https://github.com/rubber/rubber)插件


# Mapie系列链接

Mapie包含了一系列的开源项目，访问对应仓库以便了解更多。

> Magpie Workflow

Flutter可视化工作流。 [https://github.com/wuba/magpie_workflow](https://github.com/wuba/magpie_workflow)

> Magpie Native&Dart SDK

与Workflow配套，用于接入App，Flutter的SDK。[https://github.com/wuba/magpie](https://github.com/wuba/magpie)

> Magpie Fly 

所见即所得的Flutter UI组件库。[https://github.com/wuba/magpie_fly](https://github.com/wuba/magpie_fly)

