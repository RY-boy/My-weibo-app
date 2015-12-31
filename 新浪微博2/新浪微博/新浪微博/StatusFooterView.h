//
//  StatusFooterView.h
//  新浪微博
//
//  Created by qingyun on 15/12/30.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Status;
@interface StatusFooterView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UIButton *reTwitter;
@property (weak, nonatomic) IBOutlet UIButton *comment;
@property (weak, nonatomic) IBOutlet UIButton *like;


-(void)bandingStatus:(Status *)status;
@end
