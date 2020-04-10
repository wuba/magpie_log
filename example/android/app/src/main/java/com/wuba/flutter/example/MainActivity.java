package com.wuba.flutter.example;

import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugins.wuba.magpielog.MagpieLogListener;
import io.flutter.plugins.wuba.magpielog.MagpieLogPlugin;

public class MainActivity extends FlutterActivity implements MagpieLogListener {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        MagpieLogPlugin.getInstance().registerLogListener(this::magpieDataListener);

    }

    /**
     * 接收Flutter端圈选上报数据
     */
    @Override
    public void magpieDataListener(String jsonData) {
        Toast.makeText(getApplicationContext(),"Native端收到了上报数据：" + jsonData,Toast.LENGTH_LONG).show();
        Log.d("basicMessageChannel","Native端收到了上报数据：" + jsonData);
    }
}
