#import "PhylloConnectPlugin.h"
#if __has_include(<phyllo_connect/phyllo_connect-Swift.h>)
#import <phyllo_connect/phyllo_connect-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "phyllo_connect-Swift.h"
#endif

@implementation PhylloConnectPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPhylloConnectPlugin registerWithRegistrar:registrar];
}
@end
