//flutter 页面
import 'package:example/top_screen.dart';
import 'package:example/under_screen.dart';
import 'package:flutter_boost/flutter_boost.dart';

//flutter 页面
const String FLUTTER_TOP_SCREEN = "magpieBoost://top_screen";
const String FLUTTER_UNDER_SCREEN = "magpieBoost://under_screen";

//native 页面
const String NATIVE_ = "magpieBoost://";

class PageRouter {
  static init() {
    FlutterBoost.singleton.registerPageBuilders({
      FLUTTER_TOP_SCREEN: (pageName, params, _) {
        return TopScreen();
      },
      FLUTTER_UNDER_SCREEN: (pageName, params, _) {
        return UnderScreen();
      },
    });
  }
}
