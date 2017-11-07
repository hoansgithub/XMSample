//
//  XMTabbarViewItemProtocol.h
//  XMSample
//
//  Created by Hoan Nguyen on 11/2/17.
//  Copyright © 2017 Hoan Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol XMTabbarViewItemProtocol <NSObject>
- (void)tabBarDidSelectCurrentView;
- (void)tabbarDidLeaveCurrentView;
@end
