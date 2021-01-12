#import <Foundation/Foundation.h>
#import <LibTorch/LibTorch.h>

NS_ASSUME_NONNULL_BEGIN

@interface Convert : NSObject

+ (at::ScalarType)dtypeFromString:(NSString*)dtype;

@end

NS_ASSUME_NONNULL_END
