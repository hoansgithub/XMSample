//
//  UIView+LayoutConstraint.m
//  XMSample
//
//  Created by Hoan Nguyen on 11/1/17.
//  Copyright © 2017 Hoan Nguyen. All rights reserved.
//

#import "UIView+LayoutConstraint.h"

@implementation UIView (LayoutConstraint)
- (NSArray<NSLayoutConstraint *> *)addConstraintsWithVisualFormat:(NSString*)format views: (UIView *)view, ... {
    NSMutableDictionary *viewDict = [NSMutableDictionary new];
    NSArray<NSLayoutConstraint *> *constraints = nil;
    
    if (view != nil) {
        va_list args;
        va_start(args, view);
        UIView *mView = view;
        int index = 0;
        do {
            NSString *key = [NSString stringWithFormat:@"v%d",index];
            viewDict[key] = mView;
            if ([mView respondsToSelector:@selector(translatesAutoresizingMaskIntoConstraints)]) {
                mView.translatesAutoresizingMaskIntoConstraints = NO;
            }
            index++;
        } while ((mView = va_arg(args, UIView*)));
        va_end(args);
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:viewDict];
        [self addConstraints:constraints];
    }
    return constraints;
}
@end
