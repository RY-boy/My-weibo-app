//
//  StatusFooterView.m
//  新浪微博
//
//  Created by qingyun on 15/12/30.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "StatusFooterView.h"
#import "Status.h"

@implementation StatusFooterView
-(void)awakeFromNib
{
    self.backgroundView = [[UIView alloc]init];
    self.backgroundView.backgroundColor =[UIColor whiteColor];
}
-(void)bandingStatus:(Status *)status
{
    NSNumber *reTwitterCount = status.reposts_count;//转发微博数量
    [self.reTwitter setTitle:reTwitterCount.stringValue forState:UIControlStateNormal];
    [self.comment setTitle:status.comments_count.stringValue  forState:UIControlStateNormal];
    [self.like setTitle:status.attitudes_count.stringValue forState:UIControlStateNormal];
}


@end
