#import "SmileSelfiePlugin.h"
#if __has_include(<smile_selfie/smile_selfie-Swift.h>)
#import <smile_selfie/smile_selfie-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "smile_selfie-Swift.h"
#endif

@implementation SmileSelfiePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSmileSelfiePlugin registerWithRegistrar:registrar];
}
@end
