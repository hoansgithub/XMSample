//
//  CarouselizedCell.h
//  XMSample
//
//  Created by Hoan Nguyen on 11/8/17.
//  Copyright © 2017 Hoan Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CarouselizedCell;
@protocol CarouselizedCellDelegate
- (NSInteger)numberOfItemInCarouselizedCell:(CarouselizedCell *)cell;
- (UIView *)carouselizedCell:(CarouselizedCell *)cell viewForItemAtIndex:(NSInteger)index;
- (void)carouselizedCell:(CarouselizedCell *)cell didSelectItemAtIndex:(NSInteger)index;
- (void)carouselizedCell:(CarouselizedCell *)cell willDisplayItemAtIndex:(NSInteger)index usingView:(UIView *)view;
@end

@interface CarouselizedCell : UICollectionViewCell
@property (weak, nonatomic) id<CarouselizedCellDelegate> delegate;
- (void)reloadData;
@end
