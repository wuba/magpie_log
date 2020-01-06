// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "MagpieLogPlugin.h"

@interface MagpieLogPlugin ()

@property (nonatomic, copy) MagpieLogVoidCallBack callback;

@end

@implementation MagpieLogPlugin

+ (instancetype)sharedInstance{
    static MagpieLogPlugin * magpie_log;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        magpie_log = [[MagpieLogPlugin alloc] init];
    });
    return magpie_log;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterBasicMessageChannel* msgChannel = [FlutterBasicMessageChannel messageChannelWithName:@"magpie_analysis_channel" binaryMessenger:[registrar messenger] codec:[FlutterStringCodec new]];
    [msgChannel setMessageHandler:^(id  _Nullable message, FlutterReply  _Nonnull callback){
        if (MagpieLogPlugin.sharedInstance.callback) {
            MagpieLogPlugin.sharedInstance.callback(message);
        }
    }];
}


+ (void)setLogHandler:(MagpieLogVoidCallBack)handler{
    if (handler) {
        MagpieLogPlugin.sharedInstance.callback = handler;
    }else{
        MagpieLogPlugin.sharedInstance.callback = nil;
    }
}

@end
