//
//  SettingVC.m
//  新浪微博
//
//  Created by qingyun on 15/12/25.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "SettingVC.h"
#import "Accoount.h"
#import "UITableView+Index.h"
#import "MainController.h"
#import "SDImageCache.h"

@interface SettingVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSArray *cellTitle;
@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[Accoount currentAccount] isLogin]) {
        //登录状态显示的信息
        self.cellTitle = @[@[@"帐号管理"],@[@"通知",@"隐私与安全",@"通用设置"],@[@"清理缓存",@"意见反馈",@"关于微博"],@[@"退出当前账号"]];
    }else{
        //未登录状态的信息
        self.cellTitle = @[@[@"通用设置"],@[@"关于微博"]];
    }
        
}

#pragma mark -tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cellTitle.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cellTitle[section]count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==3&&indexPath.row==0) {
        
        UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        cell.textLabel.text=@"退出当前登录";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor=[UIColor redColor];
        cell.accessoryType =UITableViewCellAccessoryNone;
        return cell;
    }
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"settingCell" forIndexPath:indexPath];
    cell.textLabel.text =self.cellTitle[indexPath.section][indexPath.row];
    if (indexPath.section==2&&indexPath.row==0) {
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%2f M",[[SDImageCache sharedImageCache] getSize]/1024.f/1024.f];
    }else{
        cell.detailTextLabel.text=nil;
    }
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index =[tableView indexWithIndexPath:indexPath];

    switch (index) {
        case 7:
        {
            //退出当前登录
            UIAlertController *alert =[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *action =[UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
                //删除当前登录
                [[Accoount currentAccount]logout];
                //退出当前登录
                
                [self.navigationController popViewControllerAnimated:YES];
                
                UIWindow *window =[[[UIApplication sharedApplication]delegate]window];
                
                
                
                MainController *main=(MainController *)window.rootViewController;
                
                [main logout];
                
            }];
            UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil
                                    ];
            [alert addAction:action];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }
            break;
        case 4:
        {
            //清除缓存的工作
            [[SDImageCache sharedImageCache] clearDisk];
            
            [tableView reloadData];
            
        }
            break;
            
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
