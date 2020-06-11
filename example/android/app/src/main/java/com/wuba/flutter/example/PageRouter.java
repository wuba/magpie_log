package com.wuba.flutter.example;


import android.app.Activity;
import android.content.Context;
import android.content.Intent;

import com.idlefish.flutterboost.containers.BoostFlutterActivity;

import java.util.HashMap;
import java.util.Map;

public class PageRouter {
    final static String FLUTTER_TOP_SCREEN = "magpieBoost://top_screen";
    final static String FLUTTER_UNDER_SCREEN = "magpieBoost://under_screen";
    public final static Map<String, String> pageName = new HashMap<String, String>() {{
        put(FLUTTER_TOP_SCREEN, "");
        put(FLUTTER_UNDER_SCREEN, "");
    }};


    public static boolean openPageByUrl(Context context, String url, Map params) {
        return openPageByUrl(context, url, params, 0);
    }

    public static boolean openPageByUrl(Context context, String url, Map params, int requestCode) {
        String path = url.split("\\?")[0];
        try {
            if (pageName.containsKey(path)) {
                Intent intent = BoostFlutterActivity.withNewEngine().url(path).params(params)
                        .backgroundMode(BoostFlutterActivity.BackgroundMode.opaque).build(context);
                if (context instanceof Activity) {
                    Activity activity = (Activity) context;
                    activity.startActivityForResult(intent, requestCode);
                } else {
                    context.startActivity(intent);
                }
                return true;
            } else if (url.startsWith("native")) {
            }

            return false;

        } catch (Throwable t) {
            return false;
        }
    }
}
