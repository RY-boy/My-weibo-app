//
//  NSString+StringSize.m
//  新浪微博
//
//  Created by qingyun on 15/12/26.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "NSString+StringSize.h"

@implementation NSString (StringSize)

-(CGSize)sizeWithFont:(UIFont *)font With:(CGFloat)with
{
    CGSize size = CGSizeMake(with, MAXFLOAT);//限制文字显示的一个区域
    NSDictionary *att =@{NSFontAttributeName : font};//文字显示的属性
    CGRect rect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:nil];//计算出文字显示需要的大小
    return rect.size;
    
    
    
    
}
@end
