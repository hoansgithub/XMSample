//
//  XMTableViewCell.h
//  XMSample
//
//  Created by Hoan Nguyen on 11/3/17.
//  Copyright © 2017 Hoan Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMTableViewCell;
@protocol XMTableViewCellDelegate<NSObject>
- (Class)xmTableViewCell:(XMTableViewCell *)cell itemClassForCellIndexPath:(NSIndexPath *)indexPath;
- (UICollectionViewLayout *)xmTableViewCell:(XMTableViewCell *)cell layoutForCollectionViewAt:(NSIndexPath *)indexPath;
- (NSInteger)xmTableViewCell:(XMTableViewCell *)cell numberOfItemForCellIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)xmTableViewCell : (XMTableViewCell *)cell heightForSubHeaderAtCellIndexPath:(NSIndexPath *)indexPath;
@end

@interface XMTableViewCell : UITableViewCell
- (void)triggerCollectionViewProtocols:(NSIndexPath *)indexPath;
- (void)setCollectionViewOffset:(CGPoint)point;
- (CGPoint)collectionViewOffset;
@property (weak , nonatomic) id<XMTableViewCellDelegate> delegate;
@end
