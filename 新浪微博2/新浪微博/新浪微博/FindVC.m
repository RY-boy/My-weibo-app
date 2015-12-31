//
//  FindVC.m
//  新浪微博
//
//  Created by qingyun on 15/12/25.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "FindVC.h"
#import "Accoount.h"

@interface FindVC ()
@property (nonatomic,strong) UIBarButtonItem *rightButton;

@end
@implementation FindVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[Accoount currentAccount] isLogin]) {
        self.rightButton = self.navigationItem.rightBarButtonItem;
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        if (self.rightButton) {
            self.navigationItem.rightBarButtonItem = self.rightButton;

        }
    }
}

@end
