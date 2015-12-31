//
//  UITableView+Index.m
//  新浪微博
//
//  Created by qingyun on 15/12/25.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "UITableView+Index.h"

@implementation UITableView (Index)

/**
 *将indexpath转化为index
 *
 * @param  indexPath  indexPath description
 *
 *@return return value description
 *
 */

-(NSInteger)indexWithIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger index =indexPath.row;
    
    for (int i = 0; i <indexPath.section;i++) {
        
        index +=[self numberOfRowsInSection:i];
    }
    return index;
}

@end
