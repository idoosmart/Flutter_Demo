#import "ProtocolChannelPlugin.h"
#if __has_include(<protocol_channel/protocol_channel-Swift.h>)
#import <protocol_channel/protocol_channel-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "protocol_channel-Swift.h"
#endif

@implementation ProtocolChannelPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftProtocolChannelPlugin registerWithRegistrar:registrar];
}
@end
