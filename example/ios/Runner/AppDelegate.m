#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"

#import <magpie_log/MagpieLogPlugin.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
    [MagpieLogPlugin setLogHandler:^(NSString * log) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"DartLog" message:log preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:NO completion:nil];
        NSLog(@"native log: %@",log);
    }];
 
    
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
