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
@property (strong, nonatomic) UILabel *headerTitle;
@property (strong, nonatomic) UILabel *headerSubTitle;
@property (strong, nonatomic) NSIndexPath *tableViewCellIndexPath;
@property (strong, nonatomic) NSLayoutConstraint *csHeaderHeight;
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
    _subHeader = [XMSubHeader new];
    _subHeader.backgroundColor = [UIColor grayColor];
    [self addSubview:_subHeader];
    //sub-header tap recognizer
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSubHeaderTap:)];
    recognizer.numberOfTapsRequired = 1;
    recognizer.numberOfTouchesRequired = 1;
    _subHeader.userInteractionEnabled = YES;
    [_subHeader addGestureRecognizer:recognizer];
    
    //temporary layout
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 50, 50) collectionViewLayout:flowLayout];
    _collectionView.pagingEnabled = YES;
    _collectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:_collectionView];

    _collectionView.collectionViewLayout = flowLayout;
    [self addConstraintsWithVisualFormat:@"V:|[v1][v0]|" views:_collectionView,_subHeader,nil];
    _csHeaderHeight = [NSLayoutConstraint constraintWithItem:_subHeader attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    [self addConstraint:_csHeaderHeight];
    [self addConstraintsWithVisualFormat:@"H:|[v0]|" views:_collectionView,nil];
    [self addConstraintsWithVisualFormat:@"H:|[v0]|" views:_subHeader,nil];
    
}

#pragma mark -Gesture
-(void) handleSubHeaderTap:(UIGestureRecognizer *)gestureRecognizer {
    if (self.delegate) {
        [self.delegate xmTableViewCell:self didSelectSubHeaderAtCellIndexPath:_tableViewCellIndexPath];
    }
}

#pragma mark -CollectionView


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate) {
        [self.delegate xmTableViewCell:self didSelectItemAtIndex:indexPath.row forCellIndexPath:_tableViewCellIndexPath];
    }
}

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
        return cell;
    }
    return [UICollectionViewCell new];
    
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.delegate) {
        [self.delegate xmTableViewCell:self willDisplayItem:cell atIndex:indexPath.row forCellIndexPath:_tableViewCellIndexPath];
    }
}


- (void)triggerCollectionViewProtocols:(NSIndexPath *)indexPath{
    _tableViewCellIndexPath = indexPath;
    if (self.delegate) {
        //header
        _csHeaderHeight.constant = [self.delegate xmTableViewCell:self heightForSubHeaderAtCellIndexPath:_tableViewCellIndexPath];
        _subHeader.lblText.text = @"TEST";
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
