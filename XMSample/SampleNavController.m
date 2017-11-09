//
//  SampleNavController.m
//  XMSample
//
//  Created by Hoan Nguyen on 11/9/17.
//  Copyright © 2017 Hoan Nguyen. All rights reserved.
//

#import "SampleNavController.h"

@interface SampleNavController ()

@end

@implementation SampleNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
}

- (void)tabbarDidLeaveCurrentView {
    UIViewController *rootVC = self.viewControllers.firstObject;
    if ([rootVC respondsToSelector:@selector(tabbarDidLeaveCurrentView)]) {
        [rootVC performSelector:@selector(tabbarDidLeaveCurrentView)];
    }
}

- (void)tabBarDidSelectCurrentView {
    [self popToRootViewControllerAnimated:YES];
    UIViewController *rootVC = self.viewControllers.firstObject;
    if ([rootVC respondsToSelector:@selector(tabBarDidSelectCurrentView)]) {
        [rootVC performSelector:@selector(tabBarDidSelectCurrentView)];
    }
}

@end
