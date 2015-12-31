//
//  NSString+FilePath.m
//  新浪微博
//
//  Created by qingyun on 15/12/25.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "NSString+FilePath.h"

@implementation NSString (FilePath)

+(NSString *)filePathInDocumentsWithFileName:(NSString *)filename
{
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePath = [documentsPath stringByAppendingPathComponent:filename];
    return filePath;
}
@end
