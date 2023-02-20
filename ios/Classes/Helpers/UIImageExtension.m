#import "UIImageExtension.h"

@implementation UIImageExtension

+ (UIImage*)resize:(UIImage*)image toWidth:(int) width toHeight:(int)height {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height),NO,1);
    
    [image drawInRect:CGRectMake(0,0,width,height)];
	
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

+ (nullable float*)normalize:(UIImage*)image withMean:(NSArray<NSNumber*>*)mean withSTD:(NSArray<NSNumber*>*)std {
    CGImageRef cgImage = [image CGImage];
    NSUInteger w = CGImageGetWidth(cgImage);
    NSUInteger h = CGImageGetHeight(cgImage);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * w;
    NSUInteger bitsPerComponent = 8;
    
    UInt8 *rawBytes = (UInt8*) calloc(h*w*4, sizeof(UInt8));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rawBytes, 
                                                 w, 
                                                 h, 
                                                 bitsPerComponent,
                                                 bytesPerRow, 
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(context,CGRectMake(0,0,w,h),cgImage);
	
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
	
    float* normalizedBuffer = malloc(3*h*w * sizeof(float));
    for(int i = 0; i < (w*h); i++) {
        normalizedBuffer[i] = (rawBytes[i * 4 + 0] / 255.0 - mean[0].floatValue) / std[0].floatValue;
        normalizedBuffer[w * h + i] = (rawBytes[i * 4 + 1] / 255.0 - mean[1].floatValue) / std[1].floatValue;
        normalizedBuffer[w * h * 2 + i] = (rawBytes[i * 4 + 2] / 255.0 - mean[2].floatValue) / std[2].floatValue;	
    }
    
    free(rawBytes);
    return normalizedBuffer;
}

@end
