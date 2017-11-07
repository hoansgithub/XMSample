//
//  XMTableViewCell.m
//  XMSample
//
//  Created by Hoan Nguyen on 11/3/17.
//  Copyright © 2017 Hoan Nguyen. All rights reserved.
//

#import "XMTableViewCell.h"
#import "UIView+LayoutConstraint.h"
@interface XMTableViewCell()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UILabel *headerTitle;
@property (strong, nonatomic) UILabel *headerSubTitle;
@property (strong, nonatomic) NSIndexPath *tableViewCellIndexPath;
@property (strong, nonatomic) NSLayoutConstraint *csHeaderHeight;
@property (strong, nonatomic) UIView *headerContentView;
@end
@implementation XMTableViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewComponents];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViewComponents];
    }
    return self;
}

- (void)setupViewComponents {
    
    _headerView = [UIView new];
    _headerView.backgroundColor = [UIColor grayColor];
    [self addSubview:_headerView];
    
    
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 50, 50) collectionViewLayout:flowLayout];
    _collectionView.pagingEnabled = YES;
    _collectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:_collectionView];

    _collectionView.collectionViewLayout = flowLayout;
    [self addConstraintsWithVisualFormat:@"V:|[v1][v0]|" views:_collectionView,_headerView,nil];
    _csHeaderHeight = [NSLayoutConstraint constraintWithItem:_headerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    [self addConstraint:_csHeaderHeight];
    [self addConstraintsWithVisualFormat:@"H:|[v0]|" views:_collectionView,nil];
    [self addConstraintsWithVisualFormat:@"H:|[v0]|" views:_headerView,nil];
    
}

#pragma mark -CollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.delegate) {
        return [self.delegate xmTableViewCell:self numberOfItemForCellIndexPath:_tableViewCellIndexPath];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate) {
        Class cellClass = [self.delegate xmTableViewCell:self itemClassForCellIndexPath:_tableViewCellIndexPath];
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(cellClass) forIndexPath:indexPath];
        UIColor *bg = [UIColor colorWithHue:drand48() saturation:1.0 brightness:1.0 alpha:1.0];
        cell.backgroundColor = bg;
        return cell;
    }
    return [UICollectionViewCell new];
    
}


- (void)triggerCollectionViewProtocols:(NSIndexPath *)indexPath{
    _tableViewCellIndexPath = indexPath;
    if (self.delegate) {
        _csHeaderHeight.constant = [self.delegate xmTableViewCell:self heightForSubHeaderAtCellIndexPath:_tableViewCellIndexPath];
        
        if (_headerContentView == nil) {
            _headerContentView = [UIView new];
        }
        
        //appearance
        Class cellClass = [self.delegate xmTableViewCell:self itemClassForCellIndexPath:_tableViewCellIndexPath];
        if ([cellClass isSubclassOfClass:[UICollectionViewCell class]]) {
            [_collectionView registerClass:[cellClass class] forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
        }
        UICollectionViewLayout *layout = [self.delegate xmTableViewCell:self layoutForCollectionViewAt:_tableViewCellIndexPath];
        _collectionView.dataSource = nil;
        _collectionView.delegate = nil;
        [_collectionView setCollectionViewLayout:layout animated:NO];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
          [_collectionView reloadData];
        }];
    }
    
}

- (void)setCollectionViewOffset:(CGPoint)point {
    _collectionView.contentOffset = point;
}

- (CGPoint)collectionViewOffset{
    return _collectionView.contentOffset;
}


@end
