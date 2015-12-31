//
//  NSString+FilePath.h
//  新浪微博
//
//  Created by qingyun on 15/12/25.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FilePath)
/**
 *
 *根据文件名，返回文件在Documents下的路径
 *
 *
 *@param filename 文件名
 *
 *@return 文件路径
 *
 */

+(NSString *)filePathInDocumentsWithFileName:(NSString *)filename;

@end
