//
//  SampleViewController.m
//  XMSample
//
//  Created by Hoan Nguyen on 11/2/17.
//  Copyright © 2017 Hoan Nguyen. All rights reserved.
//

#import "SampleViewController.h"
#import "XMTableView.h"
#import "UIView+LayoutConstraint.h"
#import "CarouselizedCell.h"
@interface SampleViewController ()<XMTableviewDelegate,CarouselizedCellDelegate>
@property (strong , nonatomic) XMTableView *xmTableView;
@end

@implementation SampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIColor *bg = [UIColor colorWithHue:drand48() saturation:1.0 brightness:1.0 alpha:1.0];
    self.view.backgroundColor = bg;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupViewComponents];
}

- (void)setupViewComponents {
    _xmTableView = [XMTableView new];
    [self.view addSubview:_xmTableView];
    [self.view addConstraintsWithVisualFormat:@"V:|[v0]|" views:_xmTableView,nil];
    [self.view addConstraintsWithVisualFormat:@"H:|[v0]|" views:_xmTableView,nil];
    _xmTableView.delegate = self;
    [_xmTableView reloadData];
}

- (void)tabbarDidLeaveCurrentView {

}

- (void)tabBarDidSelectCurrentView {
    
}

#pragma mark -XMTableviewDelegate

- (void)xmTableView:(XMTableView *)tableView didSelectSubHeaderAtCellIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSUInteger)numberOfSectionsInXMTableView:(XMTableView *)tableView {
    return 4;
}

- (NSUInteger)xmTableView:(XMTableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
        case 1:
        case 2:
            return 1;
            break;
        case 3:
            return 3;
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)xmTableView:(XMTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    CGFloat screenHeight = UIScreen.mainScreen.bounds.size.height;
    switch (indexPath.section) {
        case 1:
            return (screenWidth/3 * 1.3 ) * 2;
            break;
        case 2 :
            return ((screenHeight)/ 3) * 2;
            break;
        case 3:
            if (indexPath.row == 0) {
                return (screenWidth / 4) * 5;
            }
            break;
        default:
            break;
    }
    
    return screenWidth/4;
    
}

- (CGFloat)xmTableView:(XMTableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 50;
}

- (UICollectionViewLayout *)xmTableView:(XMTableView *)tableView layoutForCollectionViewAt:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsZero;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
        flowLayout.itemSize = CGSizeMake(screenWidth, screenWidth / 4);
        return flowLayout;
    }
    else if(indexPath.section == 1) {
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.minimumLineSpacing = 5;
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
        CGFloat expectedWidth = (screenWidth  - 20 )/ 3;
        flowLayout.itemSize = CGSizeMake(expectedWidth, expectedWidth * 1.3);
        return flowLayout;
    }
    else if (indexPath.section == 2) {
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsZero;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        CGFloat screenHeight = UIScreen.mainScreen.bounds.size.height;
        CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
        flowLayout.itemSize = CGSizeMake(screenWidth, (screenHeight / 3) * 2);
        return flowLayout;
    }
    else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
            flowLayout.minimumLineSpacing = 0;
            flowLayout.sectionInset = UIEdgeInsetsZero;
            flowLayout.minimumInteritemSpacing = 0;
            flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
            flowLayout.itemSize = CGSizeMake(screenWidth, screenWidth / 4);
            return flowLayout;
        }
    }
    
    
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsZero;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    flowLayout.itemSize = CGSizeMake(screenWidth / 4, screenWidth / 4);
    return flowLayout;
}

- (Class)xmTableView:(XMTableView *)tableView itemClassForCellIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [CarouselizedCell class];
    }
    return [UICollectionViewCell class];
}

- (NSInteger)xmTableView:(XMTableView *)tableView numberOfItemForCellIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 1;
        case 1:
            return 6;
        case 2:
            return 3;
        case 3 :
        {
            switch (indexPath.row) {
                case 0:
                    return 5;
                default:
                    return 10;
            }
        }
        default:
            return 12;
    }
}

- (NSInteger)xmTableView:(XMTableView *)tableView heightForSubHeaderAtCellIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        case 1:
            return 0;
            break;
            
        default:
            return 50;
            break;
    }
    
}

- (void)xmTableView:(XMTableView *)tableView willDisplayItem:(UICollectionViewCell *)collectionViewCell atIndex:(NSInteger)index forCellIndexPath:(NSIndexPath *)indexPath {
    if ([collectionViewCell isKindOfClass:[CarouselizedCell class]]) {
        CarouselizedCell *cell = (CarouselizedCell *)collectionViewCell;
        cell.delegate = self;
        [cell reloadData];
    }
}

- (void)xmTableView:(XMTableView *)tableView willDisplayHeaderView:(XMHeaderView *)view forSection:(NSInteger)section {
    if (section == 1) {
        view.lblDesc.text = @"ZAZA";
    }
}

- (void)xmTableView:(XMTableView *)tableView didSelectHeaderInSection:(NSInteger)section {
    
}

- (void)xmTableView:(XMTableView *)cell didSelectItemAtIndex:(NSInteger)index forCellIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"item  %ld ---- section %ld   ===  %ld", (long)index,(long)indexPath.section, (long)indexPath.row,nil);
}

#pragma mark -CarouselizedCellDelegate
- (void)carouselizedCell:(CarouselizedCell *)cell willDisplayItemAtIndex:(NSInteger)index usingView:(UIView *)view {
    
}

- (UIView *)carouselizedCell:(CarouselizedCell *)cell viewForItemAtIndex:(NSInteger)index {
    UIImage *img = [UIImage imageNamed:@"temp"];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    imgView.contentMode = UIViewContentModeScaleToFill;
    imgView.frame = cell.frame;
    
    return imgView;
}

- (void)carouselizedCell:(CarouselizedCell *)cell didSelectItemAtIndex:(NSInteger)index {
    
}

- (NSInteger)numberOfItemInCarouselizedCell:(CarouselizedCell *)cell {
    return 5;
}


@end
