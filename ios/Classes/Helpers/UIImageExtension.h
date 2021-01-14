#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageExtension : NSObject
+ (nullable UIImage*)resize:(UIImage*)image toWidth:(int)width toHeight:(int)height;
+ (nullable float*)normalize:(UIImage*)image;
@end

NS_ASSUME_NONNULL_END
