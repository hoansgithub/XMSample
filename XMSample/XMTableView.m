//
//  XMTableView.m
//  XMSample
//
//  Created by Hoan Nguyen on 11/3/17.
//  Copyright © 2017 Hoan Nguyen. All rights reserved.
//

#import "XMTableView.h"
#import "UIView+LayoutConstraint.h"
#import "XMTableViewCell.h"
@interface XMTableView()<UITableViewDelegate ,  UITableViewDataSource, XMTableViewCellDelegate>
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableDictionary<NSIndexPath *, id> *storedOffsets;
@property (strong, nonatomic) NSMutableDictionary<NSIndexPath *, UICollectionViewLayout *> *storedLayouts;
@end

@implementation XMTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupComponents];
    }
    return self;
}

- (void)setupComponents {
    _storedOffsets = [NSMutableDictionary new];
    _storedLayouts = [NSMutableDictionary new];
    _tableView = [UITableView new];
    [self addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[XMTableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"header"];
    
    [self addConstraintsWithVisualFormat:@"V:|[v0]|" views:_tableView, nil];
    [self addConstraintsWithVisualFormat:@"H:|[v0]|" views:_tableView, nil];
    
}

- (void)reloadData {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView setNeedsLayout];
        [_tableView layoutIfNeeded];
        [_tableView reloadData];
    });
}

#pragma mark -Datasource , Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.delegate) {
        return [self.delegate numberOfSectionsInXMTableView:self];
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.delegate) {
        return [self.delegate xmTableView:self numberOfRowsInSection:section];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate) {
        CGFloat cellHeight = [self.delegate xmTableView:self heightForRowAtIndexPath:indexPath];
        CGFloat headerHeight = [self.delegate xmTableView:self heightForSubHeaderAtCellIndexPath:indexPath];
        
        return cellHeight + headerHeight + 1;
    }
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.delegate) {
        return [self.delegate xmTableView:self heightForHeaderInSection:section];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XMTableViewCell *cell = (XMTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.preservesSuperviewLayoutMargins = NO;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *cell = (UITableViewHeaderFooterView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    cell.textLabel.text = [NSString stringWithFormat:@"sec %ld", (long)section];
    return  cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    XMTableViewCell *mCell = (XMTableViewCell *)cell;
    mCell.delegate = self;
    [mCell triggerCollectionViewProtocols:indexPath];
    CGPoint offset = [_storedOffsets[indexPath] CGPointValue];
    [mCell setCollectionViewOffset:offset];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    XMTableViewCell *mCell = (XMTableViewCell *)cell;
    _storedOffsets[indexPath] = @([mCell collectionViewOffset]);
    
}

#pragma mark -XMTableViewCellDelegate
- (UICollectionViewLayout *)xmTableViewCell:(XMTableViewCell *)cell layoutForCollectionViewAt:(NSIndexPath *)indexPath {
    if (_storedLayouts[indexPath] == nil && self.delegate) {
        UICollectionViewLayout *layout = [self.delegate xmTableView:self layoutForCollectionViewAt:indexPath];
        _storedLayouts[indexPath] = layout;
    }
    return _storedLayouts[indexPath];
}

- (Class)xmTableViewCell:(XMTableViewCell *)cell itemClassForCellIndexPath:(NSIndexPath *)indexPath {
    
    if (self.delegate) {
        Class c = [self.delegate xmTableView:self itemClassForCellIndexPath:indexPath];
        if ([c isSubclassOfClass:[UICollectionViewCell class]]) {
            return c;
        }
    }
    
    return [UICollectionViewCell class];
}

- (NSInteger)xmTableViewCell:(XMTableViewCell *)cell numberOfItemForCellIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate) {
        return  [self.delegate xmTableView:self numberOfItemForCellIndexPath:indexPath];
    }
    return 0;
}

- (CGFloat)xmTableViewCell:(XMTableViewCell *)cell heightForSubHeaderAtCellIndexPath:(NSIndexPath *)indexPath {
    
    if (self.delegate) {
        return [self.delegate xmTableView:self heightForSubHeaderAtCellIndexPath:indexPath];
    }
    return 100;
}

@end
