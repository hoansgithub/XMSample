//
//  XMHeaderView.m
//  XMSample
//
//  Created by Hoan Nguyen on 11/8/17.
//  Copyright © 2017 Hoan Nguyen. All rights reserved.
//

#import "XMHeaderView.h"
#import "UIView+LayoutConstraint.h"
@implementation XMHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupViewComponents];
    }
    return self;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViewComponents];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewComponents];
    }
    return self;
}

- (void)setupViewComponents {
    _lblText = [UILabel new];
    _lblDesc = [UILabel new];
    [self.contentView addSubview:_lblText];
    [self.contentView addSubview:_lblDesc];
    
    [self.contentView addConstraintsWithVisualFormat:@"H:[v0]-8-|" views:_lblDesc, nil];
    [self.contentView addConstraintsWithVisualFormat:@"H:|-8-[v0]" views:_lblText, nil];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lblDesc attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lblText attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
}

@end
