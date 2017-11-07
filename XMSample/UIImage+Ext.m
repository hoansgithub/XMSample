//
//  UIImage+Ext.m
//  XMSample
//
//  Created by Hoan Nguyen on 11/1/17.
//  Copyright © 2017 Hoan Nguyen. All rights reserved.
//

#import "UIImage+Ext.h"

@implementation UIImage (Ext)
+ (UIImage *)fromView:(UIView *)view {
    // Create a "canvas" (image context) to draw in.
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);  // high res
    // Make the CALayer to draw in our "canvas".
    [[view layer] renderInContext: UIGraphicsGetCurrentContext()];
    
    // Fetch an UIImage of our "canvas".
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Stop the "canvas" from accepting any input.
    UIGraphicsEndImageContext();
    
    // Return the image.
    return image;
}


+ (UIImage *)fromFontName:(NSString *)fontName
                 fontSize:(int)fontSize
                   utf8String:(nonnull const char *)string
                imageSize:(CGSize)imageSize
                    color:(UIColor * _Nonnull)color{
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    NSString *text = [NSString stringWithUTF8String:string];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    label.text = text;
    label.textColor = color;
    label.font = font;
    label.opaque = NO;
    return [[UIImage fromView:label] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
 }

@end
