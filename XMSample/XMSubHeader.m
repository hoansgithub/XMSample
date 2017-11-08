//
//  XMSubHeader.m
//  XMSample
//
//  Created by Hoan Nguyen on 11/7/17.
//  Copyright © 2017 Hoan Nguyen. All rights reserved.
//

#import "XMSubHeader.h"
#import "UIView+LayoutConstraint.h"
@implementation XMSubHeader

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupViewComponents];
    }
    return self;
}

- (void)setupViewComponents {
    self.clipsToBounds = YES;
    _lblText = [UILabel new];
    _lblDesc = [UILabel new];
    [self addSubview:_lblText];
    [self addSubview:_lblDesc];
    
    [self addConstraintsWithVisualFormat:@"H:[v0]-8-|" views:_lblDesc, nil];
    [self addConstraintsWithVisualFormat:@"H:|-8-[v0]" views:_lblText, nil];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_lblDesc attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_lblText attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
}

@end
