package com.wuba.flutter.example;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;

import java.util.HashMap;
import java.util.Map;

public class MainActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setDeepStatusBar(true, this);
        setContentView(R.layout.activity_main);
        Map params = new HashMap();
        params.put("test1", "v_test1");
        params.put("test2", "v_test2");

        findViewById(R.id.tv_normal).setOnClickListener(v ->
                startActivity(new Intent(MainActivity.this, NormalActivity.class)));

        findViewById(R.id.tv_flutter_boost).setOnClickListener(v ->
                PageRouter.openPageByUrl(MainActivity.this, PageRouter.FLUTTER_TOP_SCREEN, params));

        findViewById(R.id.tv_flutter_boost_2).setOnClickListener(v ->
                PageRouter.openPageByUrl(MainActivity.this, PageRouter.FLUTTER_UNDER_SCREEN, params));



    }


    public boolean setDeepStatusBar(boolean isChange, Activity mActivity) {
        if (!isChange) {
            return false;
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            // 透明状态栏
            Window window = mActivity.getWindow();
            window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS
                    | WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION);
            window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                    /*| View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION*/
                    | View.SYSTEM_UI_FLAG_LAYOUT_STABLE);
            window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
            window.setStatusBarColor(Color.TRANSPARENT);

            //设置状态栏文字颜色及图标为深色
            mActivity.getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                    | View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR);

            return true;
        } else {
            return false;
        }
    }
}