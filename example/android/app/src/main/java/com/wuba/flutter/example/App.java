package com.wuba.flutter.example;

import com.idlefish.flutterboost.FlutterBoost;
import com.idlefish.flutterboost.Platform;
import com.idlefish.flutterboost.Utils;
import com.idlefish.flutterboost.interfaces.INativeRouter;

import io.flutter.app.FlutterApplication;
import io.flutter.embedding.android.FlutterView;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class App extends FlutterApplication {

    @Override
    public void onCreate() {
        super.onCreate();

        init();

    }

    private void init() {

        INativeRouter router = (context, url, urlParams, requestCode, exts) -> {
            String assembleUrl = Utils.assembleUrl(url, urlParams);
            PageRouter.openPageByUrl(context, assembleUrl, urlParams);
        };

        FlutterBoost.BoostLifecycleListener boostLifecycleListener = new FlutterBoost.BoostLifecycleListener() {

            @Override
            public void beforeCreateEngine() {

            }

            @Override
            public void onEngineCreated() {
                //TODO:这个插件注册是干什么用的
                //ShimPluginRegistry shimPluginRegistry = new ShimPluginRegistry(FlutterBoost.instance().engineProvider());
                GeneratedPluginRegistrant.registerWith(FlutterBoost.instance().engineProvider());
//                GeneratedPluginRegistrant.registerWith(FlutterBoost.instance().engineProvider().getPlugins());
//                BinaryMessenger messenger = FlutterBoost.instance().engineProvider().getDartExecutor();
            }

            @Override
            public void onPluginsRegistered() {

            }

            @Override
            public void onEngineDestroy() {

            }

        };

        Platform platform = new FlutterBoost
                .ConfigBuilder(this, router)
                .isDebug(BuildConfig.DEBUG)
                .whenEngineStart(FlutterBoost.ConfigBuilder.ANY_ACTIVITY_CREATED)
                .renderMode(FlutterView.RenderMode.texture)
                .lifecycleListener(boostLifecycleListener)
                .build();

        FlutterBoost.instance().init(platform);
    }

}
