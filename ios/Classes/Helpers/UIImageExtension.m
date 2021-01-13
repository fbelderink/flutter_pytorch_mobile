#import "UIImageExtension.h"

@implementation UIImageExtension

+ (UIImage*)resize:(UIImage*)image toWidth:(int) width toHeight:(int)height {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 1.0);
    
    [image drawInRect:CGRectMake(0,0,width,height)];
	
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    NSLog(@"resize");
	return newImage;
}

+ (nullable NSArray<NSNumber*>*)normalize:(UIImage*)image{
    CGImageRef cgImage = [image CGImage];
    NSUInteger w = CGImageGetWidth(cgImage);
    NSUInteger h = CGImageGetHeight(cgImage);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * w;
    NSUInteger bitsPerComponent = 8;
    
    NSLog(@"w %d", (long) w);
    NSLog(@"h %d", (long) h);
    
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
	
    Float32 *normalizedBuffer = (Float32*) calloc(w * h * 3, sizeof(Float32));
    for(int i = 0; i < (w*h); i++) {
        normalizedBuffer[i] = (((Float32)rawBytes[i * 4 + 0]) / 255.0 - 0.456) / 0.224; 
        normalizedBuffer[w * h + i] = (((Float32)rawBytes[i * 4 + 1]) / 255.0 - 0.456) / 0.224;
        normalizedBuffer[w * h * 2 + i] = (((Float32)rawBytes[i * 4 + 2]) / 255.0 - 0.406) / 0.225;	
    }
    
    int s = sizeof(normalizedBuffer);
    NSLog(@"size of buffer %d", s);
    NSMutableArray<NSNumber*>* buffer = [[NSMutableArray<NSNumber*> alloc] init];
    for(int i = 0; i < (w*h*3); i++) {
        [buffer addObject: [NSNumber numberWithFloat: normalizedBuffer[i]]];
    }
    return buffer;
}

@end
