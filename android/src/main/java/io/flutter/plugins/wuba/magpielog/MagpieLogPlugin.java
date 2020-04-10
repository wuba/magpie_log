package io.flutter.plugins.wuba.magpielog;

import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.StringCodec;

public class MagpieLogPlugin implements BasicMessageChannel.MessageHandler<String> {

    private final String MSG_CHANNEL_TAG = "magpie_analysis_channel";

    private MagpieLogListener mLogListener;

    public static void registerWith(PluginRegistry.Registrar registrar) {
        getInstance().registerMsgChannel(registrar.messenger());
    }

    public static MagpieLogPlugin getInstance(){
        return LogPluginHolder.INSTANCE;
    }

    private void registerMsgChannel(BinaryMessenger messenger){
        final BasicMessageChannel<String> msgChannel = new BasicMessageChannel<>(messenger, MSG_CHANNEL_TAG, StringCodec.INSTANCE);
        msgChannel.setMessageHandler(this::onMessage);
    }

    public void registerLogListener(MagpieLogListener logListener){
        this.mLogListener = logListener;
    }

    @Override
    public void onMessage(String jsonString, BasicMessageChannel.Reply reply) {
        if (mLogListener != null){
            mLogListener.magpieDataListener(jsonString);
        }
    }

    private static class LogPluginHolder{
        private static final MagpieLogPlugin INSTANCE = new MagpieLogPlugin();
    }
}
