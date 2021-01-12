#import "UIImageExtension.h"

@implementation UIImageExtension

+ (UIImage*)resize:(UIImage*)image toWidth:(int) width toHeight:(int)height {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 1.0);
    
    [image drawInRect:CGRectMake(0,0,width,height)];
	
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}



@end
