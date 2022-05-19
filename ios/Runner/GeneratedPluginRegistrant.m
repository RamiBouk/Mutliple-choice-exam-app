//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<flutter_ip/FlutterIpPlugin.h>)
#import <flutter_ip/FlutterIpPlugin.h>
#else
@import flutter_ip;
#endif

#if __has_include(<sqflite/SqflitePlugin.h>)
#import <sqflite/SqflitePlugin.h>
#else
@import sqflite;
#endif

#if __has_include(<wifi/WifiPlugin.h>)
#import <wifi/WifiPlugin.h>
#else
@import wifi;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [FlutterIpPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterIpPlugin"]];
  [SqflitePlugin registerWithRegistrar:[registry registrarForPlugin:@"SqflitePlugin"]];
  [WifiPlugin registerWithRegistrar:[registry registrarForPlugin:@"WifiPlugin"]];
}

@end
