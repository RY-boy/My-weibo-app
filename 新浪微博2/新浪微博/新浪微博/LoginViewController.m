 //
//  LoginViewController.m
//  新浪微博
//
//  Created by qingyun on 15/12/24.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "LoginViewController.h"
#import "Common.h"
#import "AFNetworking.h"
#import "Accoount.h"

@interface LoginViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    //1.将用户引导到登录界面
    NSString *urlString =[NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@&response_type=code",kAppKey,kRedirect];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [self.webView loadRequest:request];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -webView delegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *loadURL =request.URL;
    NSString *urlString =[loadURL absoluteString];
    NSLog(@"%@",urlString);
    //以回调地址开头的url地址中，包含有授权码code
    if ([urlString hasPrefix:kRedirect]) {
        NSArray *result =[urlString componentsSeparatedByString:@"code="];
        NSString *code =result.lastObject;
        //用code换取access Token
        NSString *requstUrl = @"https://api.weibo.com/oauth2/access_token";
        NSDictionary *params = @{@"client_id":kAppKey,
                                 @"client_secret":kAppSecret,
                                 @"grant_type":@"authorization_code",
                                 @"code":code,
                                 @"redirect_uri":kRedirect};
        AFHTTPRequestOperationManager *mannager =[AFHTTPRequestOperationManager manager];
        mannager.responseSerializer.acceptableContentTypes =[NSSet setWithObject:@"text/plain"];
        [mannager POST:requstUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [[Accoount currentAccount]saveLogin:responseObject];
            [self dismissViewControllerAnimated:YES completion:nil];
            NSLog(@"%@",responseObject);
            //清除 cookie
            NSHTTPCookieStorage *storage=[NSHTTPCookieStorage sharedHTTPCookieStorage];
            [storage.cookies enumerateObjectsUsingBlock:^(NSHTTPCookie * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [storage deleteCookie:obj];
            }];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
    }
    return YES;
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
