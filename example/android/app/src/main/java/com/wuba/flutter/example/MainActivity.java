package com.wuba.flutter.example;

import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.StringCodec;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    private static final String MSG_CHANNEL_TAG = "magpie_analysis_channel";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        registerMsgChannel();

    }

    /**
     * 接收Flutter端圈选上报数据
     */
    private void registerMsgChannel() {
        BasicMessageChannel<String> messageChannel = new BasicMessageChannel<>(getFlutterView(),MSG_CHANNEL_TAG, StringCodec.INSTANCE);
        messageChannel.setMessageHandler((s, reply) -> {
            Toast.makeText(getApplicationContext(),"Native端收到了数据：" + s,Toast.LENGTH_LONG).show();
            Log.d("basicMessageChannel","Native端收到了数据：" + s);
        });
    }
}
