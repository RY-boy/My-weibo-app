//
//  DataBaseEngine.h
//  新浪微博
//
//  Created by qingyun on 15/12/28.
//  Copyright © 2015年 qingyun. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface DataBaseEngine : NSObject

+(void)saveStatus:(NSArray *)statuses;

+(NSArray *)getStatusFromDB;
@end
