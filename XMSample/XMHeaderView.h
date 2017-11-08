//
//  XMHeaderView.h
//  XMSample
//
//  Created by Hoan Nguyen on 11/8/17.
//  Copyright © 2017 Hoan Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMHeaderView : UITableViewHeaderFooterView
@property (strong, nonatomic, readonly) UILabel *lblText;
@property (strong, nonatomic, readonly) UILabel *lblDesc;
@property  NSInteger section;
@end
