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
#import "XMHeaderView.h"
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
        [self setupViewComponents];
    }
    return self;
}

- (void)setupViewComponents {
    _storedOffsets = [NSMutableDictionary new];
    _storedLayouts = [NSMutableDictionary new];
    _tableView = [UITableView new];
    [self addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[XMTableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView registerClass:[XMHeaderView class] forHeaderFooterViewReuseIdentifier:@"header"];
    
    [self addConstraintsWithVisualFormat:@"V:|[v0]|" views:_tableView, nil];
    [self addConstraintsWithVisualFormat:@"H:|[v0]|" views:_tableView, nil];
    
    //refresh control
    _refreshControl = [UIRefreshControl new];
    _refreshControl.backgroundColor = [UIColor whiteColor];
    _refreshControl.tintColor = [UIColor greenColor];
    [_refreshControl addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:_refreshControl];
}

- (void)refreshTableView {
    //request to refresh data
    if (self.delegate) {
        [self.delegate xmTableviewDidRequestDataRefreshing:self];
    }
    
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
    }
}

- (void)endRefreshing {
    [self.refreshControl endRefreshing];
}

- (void)reloadData {
    dispatch_async(dispatch_get_main_queue(), ^{
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
    XMHeaderView *cell = (XMHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    cell.lblText.text = [NSString stringWithFormat:@"sec %ld", (long)section];
    cell.lblDesc.text = @"details";
    cell.lblDesc.textColor = [UIColor greenColor];
    cell.section = section;
    //gesture
    if (cell.gestureRecognizers.count > 0) {
        [cell removeGestureRecognizer:cell.gestureRecognizers.firstObject];
    }
    //header tap recognizer
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleHeaderTap:)];
    recognizer.numberOfTapsRequired = 1;
    recognizer.numberOfTouchesRequired = 1;
    cell.userInteractionEnabled = YES;
    [cell addGestureRecognizer:recognizer];
    
    return  cell;
}

-(void) handleHeaderTap:(UIGestureRecognizer *)gestureRecognizer {
    XMHeaderView *cell = (XMHeaderView *)gestureRecognizer.view;
    NSInteger section = cell.section;
    if (self.delegate) {
        [self.delegate xmTableView:self didSelectHeaderInSection:section];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if (self.delegate) {
        [self.delegate xmTableView:self willDisplayHeaderView:(XMHeaderView *)view forSection:section];
    }
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

- (void)xmTableViewCell:(XMTableViewCell *)cell didSelectItemAtIndex:(NSInteger)index forCellIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate) {
        [self.delegate xmTableView:self didSelectItemAtIndex:index forCellIndexPath:indexPath];
    }
}

- (void)xmTableViewCell:(XMTableViewCell *)cell didSelectSubHeaderAtCellIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate) {
        [self.delegate xmTableView:self didSelectSubHeaderAtCellIndexPath:indexPath];
    }
}

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

- (void)xmTableViewCell:(XMTableViewCell *)cell willDisplayItem:(UICollectionViewCell *)collectionViewCell atIndex:(NSInteger)index forCellIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate) {
        [self.delegate xmTableView:self willDisplayItem:collectionViewCell atIndex:index forCellIndexPath:indexPath];
    }
}

@end
