#import "FlutterBluetoothPlugin.h"
#if __has_include(<flutter_bluetooth/flutter_bluetooth-Swift.h>)
#import <flutter_bluetooth/flutter_bluetooth-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_bluetooth-Swift.h"
#endif

@implementation FlutterBluetoothPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterBluetoothPlugin registerWithRegistrar:registrar];
    
}
@end
