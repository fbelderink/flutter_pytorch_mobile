#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageExtension : NSObject
+ (nullable UIImage*)resize:(UIImage*)image toWidth:(int)width toHeight:(int)height;
+ (nullable float*)normalize:(UIImage*)image withMean:(NSArray<NSNumber*>*)mean withSTD:(NSArray<NSNumber*>*)std;
@end

NS_ASSUME_NONNULL_END
