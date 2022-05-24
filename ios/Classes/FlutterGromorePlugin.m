#import "FlutterGromorePlugin.h"
#if __has_include(<flutter_gromore/flutter_gromore-Swift.h>)
#import <flutter_gromore/flutter_gromore-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_gromore-Swift.h"
#endif

@implementation FlutterGromorePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterGromorePlugin registerWithRegistrar:registrar];
}
@end
