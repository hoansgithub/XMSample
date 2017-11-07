//
//  UIView+LayoutConstraint.h
//  XMSample
//
//  Created by Hoan Nguyen on 11/1/17.
//  Copyright © 2017 Hoan Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LayoutConstraint)
- (NSArray<NSLayoutConstraint *> *)addConstraintsWithVisualFormat:(NSString*)format views: (UIView *)view, ...;
@end
