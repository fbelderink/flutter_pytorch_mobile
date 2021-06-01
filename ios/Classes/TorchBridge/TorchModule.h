#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TorchModule : NSObject

- (nullable instancetype)initWithFileAtPath:(NSString*)filePath;
- (nullable NSArray<NSNumber*>*)predictImage:(void*)imageBuffer withWidth:(int)width andHeight:(int)height;
- (nullable NSArray<NSNumber*>*)predict:(void*)data withShape:(NSArray<NSNumber*>*)shape andDtype:(NSString*)dtype;
- (nullable NSArray<NSArray<NSNumber*>* >*) detectron2:(void*)imageBuffer withWidth:(int)width withHeight:(int)height withMinScore: (float)minScore;

@end

NS_ASSUME_NONNULL_END
