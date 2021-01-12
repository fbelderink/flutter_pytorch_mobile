#import "Convert.h"

@implementation Convert

+ (at::ScalarType)dtypeFromString:(NSString*)dtype {
	NSArray *dtypes = @[@"float32", @"float64", @"int32", @"int64", @"int8", @"uint8"];
	int type = (int)[dtypes indexOfObject:dtype];	
	switch(type){
	case 0:
        return torch::kFloat32;
	case 1:
        return torch::kFloat64;
	case 2:
        return torch::kInt32;
	case 3:
        return torch::kInt64;
	case 4:
        return torch::kInt8;
	case 5:
        return torch::kUInt8;
    }
    return at::ScalarType::Undefined;
}

@end
