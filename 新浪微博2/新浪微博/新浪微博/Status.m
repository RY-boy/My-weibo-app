//
//  Status.
//  新浪微博
//
//  Created by qingyun on 15/12/26.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "Status.h"
#import "Common.h"
#import "User.h"

@implementation Status

-(instancetype)initStatusWithDic:(NSDictionary *)info
{
    if (self=[super init]) {
        NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
        NSString *dataFormatterString = @"EEE MMM dd HH:mm:ss zzz yyyy";//时间的格式化
        formatter.dateFormat=dataFormatterString ;
        NSLocale  *local =[NSLocale currentLocale];
        formatter.locale=local;
        self.created_at =[formatter dateFromString:info[kStatusCreateTime]];
        
        self.statusId=info[kStatusID];
        self.text=info[kStatusText];
        self.source=[self sourceWithString:info[kStatusSource]];
        NSDictionary *userInfo=info[kStatusUserInfo];
        self.user = [[User alloc]initUserWithDic:userInfo];
        NSDictionary *re_status=info[kStatusRetweetStatus];
        if (re_status) {
            self.retweeted_status =[[Status alloc]initStatusWithDic:re_status];
        }
        self.reposts_count = info[kStatusRepostsCount];
        self.attitudes_count = info[kStatusAttitudesCount];
        self.comments_count =info[kStatusCommentsCount];
        self.pic_urls = info[kStatusPicUrls];
    }
    return self;
}

-(NSString *)timeAgo
{
    //动态计算出属性的值
    //计算出当前时间和creat_at的一个时间差，然后返回对应的显示方式
    NSTimeInterval interval = [[NSDate date]timeIntervalSinceDate:self.created_at];//单位是秒
    if (interval<60) {
        return @"刚刚";
    }else if (interval <60*60){
        return [NSString stringWithFormat:@"%ld 分钟前",(NSInteger)interval/60];
    }else if (interval <60*60*24){
        return [NSString stringWithFormat:@"%ld 小时前",(NSInteger)interval/(60*60)];
    }else if (interval <60*60*24*30){
        return [NSString stringWithFormat:@"%ld 天前",(NSInteger)interval/(60*60*24)];
    }else{
        return [NSDateFormatter localizedStringFromDate:self.created_at dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
    }
    
}

-(NSString *)sourceWithString:(NSString *)string
{
    //排除无效的字符串
    if ([string isKindOfClass:[NSNull class]]||[string isEqualToString:@""]||!string) {
        return nil;
    }
    //正则表达式条件
    NSString *regExStr=@">.*<";
    NSError *error;
    //初始化一个正则表达式的对象
    NSRegularExpression *repression =[NSRegularExpression regularExpressionWithPattern:regExStr options:0 error:&error];
    //用正则表达式查找字符串中满足条件的结果
    NSTextCheckingResult *result =[repression firstMatchInString:string options:0 range:NSMakeRange(0, string.length)];
    if (result) {
        //根据结果取出满足条件的子字符串
        NSRange range =result.range;
        NSString *source =[string substringWithRange:NSMakeRange(range.location+1, range.length-2)];
        source=[@"来自" stringByAppendingString:source];
        return source;
    }
    return nil;
}
@end
