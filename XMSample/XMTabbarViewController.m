//
//  XMTabbarViewController.m
//  XMSample
//
//  Created by Hoan Nguyen on 11/1/17.
//  Copyright © 2017 Hoan Nguyen. All rights reserved.
//

#import "XMTabbarViewController.h"
#import "UIView+LayoutConstraint.h"
#import "UIImage+Ext.h"
#import "SampleViewController.h"
@interface XMTabbarViewController ()
@property (strong, nonatomic) UITabBar *tbarMain;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *vContent;
@property (strong, nonatomic) UIView *vNowPlaying;
@property (strong, nonatomic) NSMutableArray<UITabBarItem *> *tabs;
@property (strong, nonatomic) NSMutableArray<UIViewController *> *viewControllers;
@property (strong, nonatomic) SampleViewController *vcDiscover;
@property (strong, nonatomic) SampleViewController *vcTopic;
@property (strong, nonatomic) SampleViewController *vcRadio;
@property (strong, nonatomic) SampleViewController *vcSearch;
@property (strong, nonatomic) SampleViewController *vcAccount;
@property (weak, nonatomic) SampleViewController *selectedVC;
@end

@implementation XMTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tabs = [NSMutableArray new];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //tabbar
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor greenColor] }
                                             forState:UIControlStateSelected];
    
    [self addComponents];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _tbarMain.selectedItem = _tabs.firstObject;
    [self pageDidShow:0];
}

- (void)addComponents {
    
    // init view controllers
    _viewControllers = [NSMutableArray<XMTabbarViewItemProtocol> new];
    _vcDiscover = [SampleViewController new];
    _vcTopic = [SampleViewController new];
    _vcRadio = [SampleViewController new];
    _vcSearch = [SampleViewController new];
    _vcAccount = [SampleViewController new];
    [_viewControllers addObject:_vcDiscover];
    [_viewControllers addObject:_vcTopic];
    [_viewControllers addObject:_vcRadio];
    [_viewControllers addObject:_vcSearch];
    [_viewControllers addObject:_vcAccount];
    
    //view components
    id topGuide = self.topLayoutGuide;
    _vNowPlaying = [UIView new];
    _vNowPlaying.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_vNowPlaying];
    _tbarMain = [[UITabBar alloc] init];
    _tbarMain.backgroundColor = [UIColor redColor];
    [self.view addSubview:_tbarMain];
    UIView *separator = [UIView new];
    separator.backgroundColor = [UIColor greenColor];
    [self.view addSubview:separator];
    _scrollView = [UIScrollView new];
    _scrollView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_scrollView];
    _vContent = [UIView new];
    [_scrollView addSubview:_vContent];
    //constraints
    [self.view addConstraintsWithVisualFormat:@"V:[v4][v3][v1(60)][v2(1)][v0(50)]|" views:_tbarMain, _vNowPlaying,separator,_scrollView,topGuide, nil];
    [self.view addConstraintsWithVisualFormat:@"H:|[v0]|" views:_tbarMain,nil];
    [self.view addConstraintsWithVisualFormat:@"H:|[v0]|" views:_vNowPlaying,nil];
    [self.view addConstraintsWithVisualFormat:@"H:|[v0]|" views:separator,nil];
    [self.view addConstraintsWithVisualFormat:@"H:|[v0]|" views:_scrollView,nil];
    
    [_scrollView addConstraintsWithVisualFormat:@"V:|[v0]|" views:_vContent, nil];
    [_scrollView addConstraintsWithVisualFormat:@"H:|[v0]|" views:_vContent, nil];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_vContent
                              attribute:NSLayoutAttributeHeight
                              relatedBy:NSLayoutRelationEqual
                              toItem:_scrollView
                              attribute:NSLayoutAttributeHeight
                              multiplier:1.0
                              constant:0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_vContent
                              attribute:NSLayoutAttributeWidth
                              relatedBy:NSLayoutRelationEqual
                              toItem:_scrollView
                              attribute:NSLayoutAttributeWidth
                              multiplier:_viewControllers.count
                              constant:0]];
    
    //add view controllers to scrollview
    SampleViewController *previousVC = nil;
    for (SampleViewController *vc in _viewControllers) {
        [_vContent addSubview:vc.view];
        [self.view addConstraint:[NSLayoutConstraint
                                  constraintWithItem:vc.view
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:_scrollView
                                  attribute:NSLayoutAttributeWidth
                                  multiplier:1.0
                                  constant:0]];
        if (previousVC == nil) {
            previousVC = vc;
            [_vContent addConstraintsWithVisualFormat:@"H:|[v0]" views:previousVC.view,nil];
            [_vContent addConstraintsWithVisualFormat:@"V:|[v0]|" views:previousVC.view,nil];
        }
        else {
            
            [_vContent addConstraintsWithVisualFormat:@"V:|[v0]|" views:vc.view, nil];
            [_vContent addConstraintsWithVisualFormat:@"[v0][v1]" views:previousVC.view, vc.view, nil];
            previousVC = vc;
        }
    }
    
    
    //tabbar's components
    UITabBarItem *item1 = [self tabBarItemWithTitle:@"Khám phá"
                                        imgFontName:@"xmusic-iconfont"
                                        imgFontSize:20
                                         utf8String:"\ue900"
                                          imageSize:CGSizeMake(20, 20)
                                              color:[UIColor whiteColor]
                                      selectedColor:[UIColor greenColor]];
    [_tabs addObject:item1];
    

    UITabBarItem *item2 = [self tabBarItemWithTitle:@"Chủ đề"
                                        imgFontName:@"xmusic-iconfont"
                                        imgFontSize:20
                                         utf8String:"\ue90e"
                                          imageSize:CGSizeMake(20, 20)
                                              color:[UIColor whiteColor]
                                      selectedColor:[UIColor greenColor]];
    [_tabs addObject:item2];
    
    UITabBarItem *item3 = [self tabBarItemWithTitle:@"Radio"
                                        imgFontName:@"xmusic-iconfont"
                                        imgFontSize:20
                                         utf8String:"\ue90d"
                                          imageSize:CGSizeMake(20, 20)
                                              color:[UIColor whiteColor]
                                      selectedColor:[UIColor greenColor]];
    [_tabs addObject:item3];
    
    UITabBarItem *item4 = [self tabBarItemWithTitle:@"Tìm kiếm"
                                        imgFontName:@"xmusic-iconfont"
                                        imgFontSize:20
                                         utf8String:"\ue90c"
                                          imageSize:CGSizeMake(20, 20)
                                              color:[UIColor whiteColor]
                                      selectedColor:[UIColor greenColor]];
    [_tabs addObject:item4];
    UITabBarItem *item5 = [self tabBarItemWithTitle:@"Tài khoản"
                                        imgFontName:@"xmusic-iconfont"
                                        imgFontSize:20
                                         utf8String:"\ue90b"
                                          imageSize:CGSizeMake(20, 20)
                                              color:[UIColor whiteColor]
                                      selectedColor:[UIColor greenColor]];
    [_tabs addObject:item5];
    
    
    _tbarMain.items = @[item1, item2, item3, item4, item5];
    _tbarMain.delegate = self;
    //scrollview content size
    _scrollView.scrollEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
}


- (UITabBarItem *)tabBarItemWithTitle:(NSString *)title
                          imgFontName:(NSString *)fontName
                          imgFontSize:(int)fontSize
                           utf8String:(nonnull const char *)string
                            imageSize:(CGSize)size
                                color:(UIColor *)color
                        selectedColor:(UIColor *)selectedColor {
    
    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:title image:nil tag:0];
    item1.image = [UIImage fromFontName:fontName
                               fontSize:fontSize
                             utf8String:string
                              imageSize:size
                                  color:color];
    item1.selectedImage = [UIImage fromFontName:fontName
                                       fontSize:fontSize
                                     utf8String:string
                                      imageSize:size
                                          color:selectedColor];
    return item1;
}

#pragma mark -TabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    int index = (int)[tabBar.items indexOfObject:item];
    CGFloat width = _scrollView.contentSize.width;
    CGFloat expectedOffSetX = (width / _viewControllers.count) * index;
    [_scrollView setContentOffset:CGPointMake(expectedOffSetX, 0) animated:YES];
}

#pragma mark -ScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat width = _scrollView.contentSize.width;
    CGFloat currentOffsetX = _scrollView.contentOffset.x;
    int index = currentOffsetX / (width / _viewControllers.count);
    _tbarMain.selectedItem = _tbarMain.items[index];
    [self pageDidShow:index];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    CGFloat width = _scrollView.contentSize.width;
    CGFloat currentOffsetX = _scrollView.contentOffset.x;
    int index = currentOffsetX / (width / _viewControllers.count);
    [self pageDidShow:index];
}


- (void)pageDidShow:(int)index {
    SampleViewController *item = (SampleViewController *) [_viewControllers objectAtIndex:index];
    if (_selectedVC != item) {
        [item tabBarDidSelectCurrentView];
    }
    if (_selectedVC != item && _selectedVC != nil) {
        [_selectedVC tabbarDidLeaveCurrentView];
    }
    _selectedVC = item;
}


@end
