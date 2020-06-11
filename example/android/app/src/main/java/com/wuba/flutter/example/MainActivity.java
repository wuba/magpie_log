package com.wuba.flutter.example;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

import java.util.HashMap;
import java.util.Map;

public class MainActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Map params = new HashMap();
        params.put("test1", "v_test1");
        params.put("test2", "v_test2");

        findViewById(R.id.tv_flutter_boost).setOnClickListener(v ->
                PageRouter.openPageByUrl(MainActivity.this, PageRouter.FLUTTER_TOP_SCREEN, params));

        findViewById(R.id.tv_flutter_boost_2).setOnClickListener(v ->
                PageRouter.openPageByUrl(MainActivity.this, PageRouter.FLUTTER_UNDER_SCREEN, params));

        findViewById(R.id.tv_normal).setOnClickListener(v ->
                startActivity(new Intent(MainActivity.this, NormalActivity.class)));

    }
}
