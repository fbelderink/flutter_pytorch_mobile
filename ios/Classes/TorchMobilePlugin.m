#import "TorchMobilePlugin.h"
#if __has_include(<torch_mobile/torch_mobile-Swift.h>)
#import <torch_mobile/torch_mobile-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "torch_mobile-Swift.h"
#endif

@implementation TorchMobilePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTorchMobilePlugin registerWithRegistrar:registrar];
}
@end
