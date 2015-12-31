//
//  StatusTableViewCell.h
//  新浪微博
//
//  Created by qingyun on 15/12/26.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Status;

@interface StatusTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *source;
@property (weak, nonatomic) IBOutlet UILabel *countent;
@property (weak, nonatomic) IBOutlet UIView *imageSuperView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageSuperContraints;
@property (weak, nonatomic) IBOutlet UILabel *reTwitterlabel;
@property (weak, nonatomic) IBOutlet UIView *reTwitterImageSuperView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reImageSuperViewHeightCon;

+(CGFloat)heightWithStatus:(Status *)info;

-(void)bandingStatus:(Status *)info;
@end
