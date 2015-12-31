//
//  Accoount.m
//  新浪微博
//
//  Created by qingyun on 15/12/24.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "Accoount.h"
#import "Common.h"
#import "NSString+FilePath.h"

@interface Accoount ()<NSCoding>
@property (nonatomic,strong)NSString *accessToken;//author认证的标识
@property (nonatomic,strong)NSDate *expiresIn;//有效期
@property (nonatomic,strong)NSString *uid;//用户id

@end
@implementation Accoount

+(instancetype)currentAccount
{
    static Accoount *account;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *filePath=[NSString filePathInDocumentsWithFileName:kAccountFileName];
        account =[NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        if (!account) {
            account =[[Accoount alloc]init];
        }
    });
    return account;
}
-(void)saveLogin:(NSDictionary *)info
{
    self.accessToken =info[access_token];
    NSNumber *expres =info[expires_in];
    //当前时间，加上生命周期，就等于失效时间
    self.expiresIn = [[NSDate date] dateByAddingTimeInterval:expres.integerValue];
    self.uid =info[userId];
    
    //通过归档方式保存登录model
    [NSKeyedArchiver archiveRootObject:self toFile:[NSString filePathInDocumentsWithFileName:kAccountFileName]];
    }
-(BOOL)isLogin
{
    //有token，并且有效
    if (self.accessToken &&[[NSDate date]compare:self.expiresIn]<0) {
        return YES;
    }
    return NO;
}

#pragma mark -coding
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.accessToken forKey:access_token];
    [aCoder encodeObject:self.expiresIn forKey:expires_in];
    [aCoder encodeObject:self.uid forKey:userId];
    
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self =[super init];
    if (self) {
        self.accessToken =[aDecoder decodeObjectForKey:access_token];
        self.expiresIn = [aDecoder decodeObjectForKey:expires_in];
        self.uid=[aDecoder decodeObjectForKey:userId];
    }
    return self;
}

-(void)logout
{
    self.accessToken =nil;
    self.expiresIn = nil;
    self.uid =nil;
    NSString *filePath = [NSString filePathInDocumentsWithFileName:kAccountFileName];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}


-(NSMutableDictionary *)requestParams
{
    if (self.isLogin) {
        return [NSMutableDictionary dictionaryWithObject:self.accessToken forKey:access_token];
    }
    return nil;
}





@end
