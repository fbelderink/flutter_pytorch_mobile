#import "TorchModule.h"
#import <LibTorch/LibTorch.h>

@implementation TorchModule{
    @protected
    torch::jit::script::Module _impl;
}

- (nullable instancetype)initWithPath:(NSString*)path {
    self = [super init];
    if( self ){
        try{
            auto qengines = at::globalContext().supportedQEngines();
            if(std::find(qengines.begin(), qengines.end(), at::QEngine::QNNPACK) != qengines.end()){
                at::globalContext().setQEngine(at::QEngine::QNNPACK);
            }
            _impl = torch::jit::load(path.UTF8String);
            _impl.eval();
        }catch(const std::exception& exception){
            NSLog(@"%s", exception.what());
            return nil;
        }
    }
    return self;
}

- (NSArray<NSNumber*>*)predict:(void*) input (NSArray<NSNumber*>*) shape (NSString*) dtype {
    try{
        at::Tensor tensor = torch::from_blob(input, toIntArrayRef(shape), at::kFloat);
        torch::autograd::AutoGradMode guard(false);
        at::AutoNonVariableTypeMode non_var_type_mode(true);
        auto outputTensor = _impl.forward({tensor}).toTensor();
        float* floatBuffer = outputTensor.data_ptr<float>();
        if(!floatBuffer) {
            return nil;
        }
        NSMutableArray* results = [[NSMutableArray alloc] init];
        for(int i = 0; i < @(floatBuffer).length(); i++){
            [results addObject:@(floatBuffer[i])];
        }
        return [results copy];
    }catch(const std::exception& exception){
        NSLog(@"%s", exception.what());
    }
    return nil;
}

@end

at::IntArrayRef toIntArrayRef(NSArray<NSNumber*>* array){
    return {1,3,224,224}
}

