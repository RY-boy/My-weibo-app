//
//  GuideViewController.m
//  新浪微博
//
//  Created by qingyun on 15/12/22.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "GuideViewController.h"
#import "AppDelegate.h"
#import "Common.h"

@interface GuideViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation GuideViewController
-(void)dealloc
{
    NSLog(@"guide realse");
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    CGRect frame =[[UIScreen mainScreen]bounds];
//    self.scrollView.contentSize=CGSizeMake(frame.size.width*4, frame.size.height);
    [self.pageControl addTarget:self action:@selector(pageChange:
                                                      ) forControlEvents:UIControlEventValueChanged];
    self.scrollView.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)guideEnd:(id)sender
{
    //引导结束，切换到首页
    
    AppDelegate *app =[UIApplication sharedApplication].delegate;
    [app guideEnd];
}

-(void)pageChange:(UIPageControl *)page
{
    self.scrollView.contentOffset = CGPointMake(page.currentPage *kAppScreenBounds.size.width, 0);
}

#pragma mark --scrollView delegate
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        //scrollView的滚动就结束了
        self.pageControl.currentPage =self.scrollView.contentOffset.x / kAppScreenBounds.size.width;
    }else{
        //减速完滚动才结束
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //scrollView的滚动才结束
     self.pageControl.currentPage =self.scrollView.contentOffset.x / kAppScreenBounds.size.width;
    
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
