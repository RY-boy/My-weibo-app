//
//  UINavigationController+notification.m
//  新浪微博
//
//  Created by qingyun on 15/12/30.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "UINavigationController+notification.h"
#import "Common.h"
@implementation UINavigationController (notification)

-(void)showNotification:(NSString *)string
{
    UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(0, 20, kAppScreenBounds.size.width, 44)];
    label.text =string;
    label.backgroundColor = [UIColor orangeColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    //把label作为navVC的view的subView，并且在navigationbar下面
    [self.view insertSubview:label belowSubview:self.navigationBar];
    [UIView animateWithDuration:0.3 animations:^{
        label.frame = CGRectOffset(label.frame, 0, 44);
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.25 animations:^{
                label.frame = CGRectOffset(label.frame, 0, -44);
            } completion:^(BOOL finished) {
                [label removeFromSuperview];
            }];
        });
    }];
}
@end
