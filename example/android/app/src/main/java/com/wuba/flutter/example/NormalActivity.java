package com.wuba.flutter.example;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.util.Log;
import android.widget.Toast;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugins.wuba.magpielog.MagpieLogListener;
import io.flutter.plugins.wuba.magpielog.MagpieLogPlugin;

public class NormalActivity extends FlutterActivity implements MagpieLogListener {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        MagpieLogPlugin.getInstance().registerLogListener(this::magpieDataListener);
    }

    /**
     * 接收Flutter端圈选上报数据
     */
    @Override
    public void magpieDataListener(String jsonData) {
        Toast.makeText(getApplicationContext(), "Native端收到了上报数据：" + jsonData, Toast.LENGTH_LONG).show();
        Log.d("basicMessageChannel", "Native端收到了上报数据：" + jsonData);
    }
}
