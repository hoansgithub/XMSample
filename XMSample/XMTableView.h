//
//  XMTableView.h
//  XMSample
//
//  Created by Hoan Nguyen on 11/3/17.
//  Copyright © 2017 Hoan Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMTableView;
@protocol XMTableviewDelegate<NSObject>
- (NSUInteger)numberOfSectionsInXMTableView:(XMTableView *)tableView;
- (NSUInteger)xmTableView:(XMTableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (CGFloat)xmTableView:(XMTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)xmTableView:(XMTableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (UICollectionViewLayout *)xmTableView:(XMTableView *)tableView layoutForCollectionViewAt:(NSIndexPath *)indexPath;
- (Class)xmTableView:(XMTableView *)tableView itemClassForCellIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)xmTableView:(XMTableView *)tableView numberOfItemForCellIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)xmTableView:(XMTableView *)tableView heightForSubHeaderAtCellIndexPath:(NSIndexPath *)indexPath;
@end

@interface XMTableView : UIView
@property (weak, nonatomic) id<XMTableviewDelegate> delegate;
- (void)reloadData;
@end