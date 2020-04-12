#import "PyTorchMobilePlugin.h"
#if __has_include(<pytorch_mobile/pytorch_mobile-Swift.h>)
#import <pytorch_mobile/pytorch_mobile-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "pytorch_mobile-Swift.h"
#endif

@implementation PyTorchMobilePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPyTorchMobilePlugin registerWithRegistrar:registrar];
}
@end
