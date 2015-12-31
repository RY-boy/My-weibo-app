//
//  Accoount.h
//  新浪微博
//
//  Created by qingyun on 15/12/24.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Accoount : NSObject
//单例的类方法
+(instancetype)currentAccount;
//保存登录信息的方法
-(void)saveLogin:(NSDictionary *)info;
//返回登录状态
-(BOOL)isLogin;
//返回请求open API 所需要的参数
-(NSMutableDictionary *)requestParams;

//清除登录信息
-(void)logout;
@end
