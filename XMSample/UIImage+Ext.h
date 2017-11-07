//
//  UIImage+Ext.h
//  XMSample
//
//  Created by Hoan Nguyen on 11/1/17.
//  Copyright © 2017 Hoan Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Ext)
+(UIImage *_Nullable)fromView:(UIView *_Nonnull)view;
+(UIImage *_Nullable)fromFontName:(NSString *_Nonnull)fontName
                fontSize:(int)fontSize
                  utf8String:(nonnull const char *)string
               imageSize:(CGSize)imageSize
                            color:(UIColor *_Nonnull)color;
@end
