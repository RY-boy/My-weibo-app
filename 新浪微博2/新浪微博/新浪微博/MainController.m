//
//  MainController.m
//  新浪微博
//
//  Created by qingyun on 15/12/24.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "MainController.h"
#import "Accoount.h"
#import "Common.h"

@interface MainController ()

@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];

    //未登录的时候默认选择第三个控制器
    if (![[Accoount currentAccount]isLogin]) {
        self.selectedIndex = 3;
    }
    
    self.tabBar.tintColor = [UIColor orangeColor];
    
    //注册登录成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:kLoginSuccess object:nil];
}
-(void)loginSuccess:(NSNotification *)notification
{
    
    //登录成功，切换控制器的选择
    self.selectedIndex =0;
}
-(void)logout
{
    
    self.selectedIndex =3;
    
    UIViewController *VC =[self.storyboard instantiateViewControllerWithIdentifier:@"loginNav"];
    [self presentViewController:VC animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
