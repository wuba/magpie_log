//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"

#if __has_include(<device_info/FLTDeviceInfoPlugin.h>)
#import <device_info/FLTDeviceInfoPlugin.h>
#else
@import device_info;
#endif

#if __has_include(<flutter_boost/FlutterBoostPlugin.h>)
#import <flutter_boost/FlutterBoostPlugin.h>
#else
@import flutter_boost;
#endif

#if __has_include(<fluttertoast/FluttertoastPlugin.h>)
#import <fluttertoast/FluttertoastPlugin.h>
#else
@import fluttertoast;
#endif

#if __has_include(<magpie_log/MagpieLogPlugin.h>)
#import <magpie_log/MagpieLogPlugin.h>
#else
@import magpie_log;
#endif

#if __has_include(<path_provider/PathProviderPlugin.h>)
#import <path_provider/PathProviderPlugin.h>
#else
@import path_provider;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [FLTDeviceInfoPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTDeviceInfoPlugin"]];
  [FlutterBoostPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterBoostPlugin"]];
  [FluttertoastPlugin registerWithRegistrar:[registry registrarForPlugin:@"FluttertoastPlugin"]];
  [MagpieLogPlugin registerWithRegistrar:[registry registrarForPlugin:@"MagpieLogPlugin"]];
  [FLTPathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTPathProviderPlugin"]];
}

@end
