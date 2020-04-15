#import <Foundation/Foundation.h>
#import <LibTorch/LibTorch.h>

NS_ASSUME_NONNULL_BEGIN

@interface TorchModule : NSObject

- (nullable instancetype)initWithPath:(NSString*)filePath NS_SWIFT_NAME(init(path:))NS_DESIGNATED_INITIALIZER;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (nullable NSArray<NSNumber*>*)predict:(void*)input (NSArray<NSNumber*>*)shape (NSString*)dtype NS_SWIFT_NAME(predict(input:));

@end

NS_ASSUME_NONNULL_END