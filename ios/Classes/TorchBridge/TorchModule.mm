#import "TorchModule.h"
#import "Convert.h"

@implementation TorchModule {
@protected
    torch::jit::script::Module _module;
}

- (nullable instancetype)initWithFileAtPath:(NSString*)filePath {
    self = [super init];
    if (self) {
      try {
          _module = torch::jit::load(filePath.UTF8String);
          _module.eval();
      } catch (const std::exception& e) {
          NSLog(@"%s", e.what());
          return nil;	
      }
    }
    return self;
}

- (NSArray<NSNumber*>*)predictImage:(void*)imageBuffer withWidth:(int)width andHeight:(int)height {
    try {
        at::Tensor tensor = torch::from_blob(imageBuffer, {1, 3, 244, 244}, torch::kFloat64);
        torch::autograd::AutoGradMode guard(false);
        at::AutoNonVariableTypeMode non_var_type_mode(true);
        
        at::Tensor outputTensor = _module.forward({tensor}).toTensor();
        
        float *floatBuffer = outputTensor.data_ptr<float>();
        if(!floatBuffer){
            return nil;
        }
        
        NSMutableArray *results = [[NSMutableArray alloc] init];
        for (int i = 0; i < (sizeof floatBuffer); i++) {
            [results addObject:@(floatBuffer[i])];   
        }
        
        return [results copy];
    } catch (const std::exception& e) {
        NSLog(@"%s", e.what());
    }
    return nil;
}

- (NSArray<NSNumber*>*)predict:(void*)data withShape:(NSArray<NSNumber*>*)shape andDtype:(NSString*)dtype {
    std::vector<int64_t> shapeVec;    
    for(int i = 0; i < [shape count]; i++){
        shapeVec.push_back([[shape objectAtIndex:i] intValue]);
    }
    at::ScalarType type = [Convert dtypeFromString:dtype];
    
    at::Tensor tensor = torch::from_blob(data, shapeVec, type);
    torch::autograd::AutoGradMode guard(false);
	at::AutoNonVariableTypeMode non_var_type_mode(true);    
	
    at::Tensor output =  _module.forward({tensor}).toTensor();
	
    float* floatBuffer = output.data_ptr<float>();
	if(!floatBuffer){
		return nil;
	}
	
    NSMutableArray *results = [[NSMutableArray alloc] init];
	for(int i = 0; i < sizeof(results); i++){
		[results addObject:@(floatBuffer[i])];
	}
    
    return [results copy];
}



@end
