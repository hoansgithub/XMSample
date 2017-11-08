//
//  CarouselizedCell.m
//  XMSample
//
//  Created by Hoan Nguyen on 11/8/17.
//  Copyright © 2017 Hoan Nguyen. All rights reserved.
//

#import "CarouselizedCell.h"
#import <iCarousel/iCarousel.h>
#import "UIView+LayoutConstraint.h"
@interface CarouselizedCell()<iCarouselDataSource, iCarouselDelegate>
    @property (strong, nonatomic) iCarousel *viewCarousel;
    @end
@implementation CarouselizedCell

    - (instancetype)init {
        self = [super init];
        if (self){
            [self setupViewComponents];
        }
        return self;
    }
    - (instancetype)initWithFrame:(CGRect)frame {
        self = [super initWithFrame:frame];
        if(self){
            [self setupViewComponents];
        }
        return self;
    }
    
    - (void)setupViewComponents{
        _viewCarousel = [iCarousel new];
        _viewCarousel.dataSource = self;
        _viewCarousel.delegate = self;
        _viewCarousel.pagingEnabled = YES;
        _viewCarousel.type = iCarouselTypeLinear;
        [self addSubview:_viewCarousel];
        [self addConstraintsWithVisualFormat:@"V:|[v0]|" views:_viewCarousel, nil];
        [self addConstraintsWithVisualFormat:@"H:|[v0]|" views:_viewCarousel, nil];
    }
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    if (self.delegate) {
        return [self.delegate numberOfItemInCarouselizedCell:self];
    }
    return 0;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    UIView *v = view;
    if (!v) {
        if (self.delegate) {
            v = [self.delegate carouselizedCell:self viewForItemAtIndex:index];
        }
    }
    if (v) {
        if (self.delegate) {
            [self.delegate carouselizedCell:self willDisplayItemAtIndex:index usingView:v];
        }
    }
    return v;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    if (option == iCarouselOptionSpacing) {
        return value * 1.0;
    } else if (option == iCarouselOptionWrap) {
        return YES;
    }
    return value;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    if (self.delegate) {
        [self.delegate carouselizedCell:self didSelectItemAtIndex:index];
    }
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel {
    return self.frame.size.width;
}

- (void)reloadData {
    [_viewCarousel reloadData];
}

@end
