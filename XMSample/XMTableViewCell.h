//
//  XMTableViewCell.h
//  XMSample
//
//  Created by Hoan Nguyen on 11/3/17.
//  Copyright © 2017 Hoan Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMSubHeader.h"
@class XMTableViewCell;
@protocol XMTableViewCellDelegate<NSObject>
- (Class)xmTableViewCell:(XMTableViewCell *)cell itemClassForCellIndexPath:(NSIndexPath *)indexPath;
- (UICollectionViewLayout *)xmTableViewCell:(XMTableViewCell *)cell layoutForCollectionViewAt:(NSIndexPath *)indexPath;
- (NSInteger)xmTableViewCell:(XMTableViewCell *)cell numberOfItemForCellIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)xmTableViewCell : (XMTableViewCell *)cell heightForSubHeaderAtCellIndexPath:(NSIndexPath *)indexPath;
- (void)xmTableViewCell : (XMTableViewCell *)cell willDisplayItem:(UICollectionViewCell *)collectionViewCell atIndex:(NSInteger)index forCellIndexPath:(NSIndexPath *)indexPath;
- (void)xmTableViewCell:(XMTableViewCell *)cell didSelectSubHeaderAtCellIndexPath:(NSIndexPath *)indexPath;
- (void)xmTableViewCell : (XMTableViewCell *)cell didSelectItemAtIndex:(NSInteger)index forCellIndexPath:(NSIndexPath *)indexPath;
@end

@interface XMTableViewCell : UITableViewCell
- (void)triggerCollectionViewProtocols:(NSIndexPath *)indexPath;
- (void)setCollectionViewOffset:(CGPoint)point;
- (CGPoint)collectionViewOffset;
@property (strong, nonatomic, readonly) XMSubHeader *subHeader;
@property (weak , nonatomic) id<XMTableViewCellDelegate> delegate;
@end
