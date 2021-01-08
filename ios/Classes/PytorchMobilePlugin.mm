#import "PytorchMobilePlugin.h"
#import <LibTorch/LibTorch.h>

@implementation PytorchMobilePlugin

NSMutableArray *modules = [[NSMutableArray alloc] init];

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"pytorch_mobile"
                                     binaryMessenger:[registrar messenger]];
    PytorchMobilePlugin* instance = [[PytorchMobilePlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSArray *methods = @[@"loadModel", @"predict", @"predictImage"];
    int method = (int)[methods indexOfObject:call.method];
    switch(method) {
        case 0:
        {
            try {
                NSString *absPath = call.arguments[@"absPath"];
                torch::jit::script::Module module = torch::jit::load(absPath.UTF8String);
                module.eval();
                //[modules addObject: module];
                NSLog(@"%@", absPath);
                result(@([ modules count ]));
            } catch (const std::exception& e){
                NSString *assetPath = call.arguments[@"assetPath"];
                NSLog(@"PyTorchMobile: %@ is not a proper model %s", assetPath, e.what());
                break;
            }
            break;
        }
        case 1:
        {
            try {
                int index = [call.arguments[@"index"] intValue];
                
                
            } catch (const std::exception& e) {
                NSLog(@"PyTorchMobile: error parsing arguments!\\n%s", e.what());
            }
            break;
        }
        case 2:
        {
            try {
                int index = [call.arguments[@"index"] intValue];
                int width = [call.arguments[@"width"] intValue];
                int height = [call.arguments[@"height"] intValue];
            } catch (const std::exception& e) {
                NSLog(@"PyTorchMobile: error reading image!\\n%s", e.what());
            }
            break;
        }
        default:
        {
            result(FlutterMethodNotImplemented);
            break;
        }
    }
}

@end
