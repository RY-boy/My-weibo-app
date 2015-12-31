//
//  User.m
//  新浪微博
//
//  Created by qingyun on 15/12/27.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "User.h"
#import "Common.h"


@implementation User

-(instancetype)initUserWithDic:(NSDictionary *)info
{
    if (self=[super init]) {
        self.userID =info[kUserID];
        self.name = info[kUserInfoName];
        self.userDescription =info[kUserDescription];
        self.profile_image_url = info[kUserProfileImageURL];
        self.avatar_large = info[kUserAvatarLarge];
        self.verified_reason = info[kUserVerifiedReson];
    }
    return self;
}

@end
