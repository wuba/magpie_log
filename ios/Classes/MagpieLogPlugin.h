
#import <Flutter/Flutter.h>

typedef void (^MagpieLogVoidCallBack) (NSString * log);

@interface MagpieLogPlugin : NSObject <FlutterPlugin>

+ (void)setLogHandler:(MagpieLogVoidCallBack)handler;

@end
