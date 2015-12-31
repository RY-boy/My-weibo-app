//
//  HomeVC.m
//  新浪微博
//
//  Created by qingyun on 15/12/25.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "HomeVC.h"
#import "AFHTTPRequestOperationManager.h"
#import "Accoount.h"
#import "Common.h"
#import "StatusTableViewCell.h"
#import "Status.h"
#import "DataBaseEngine.h"
#import "UINavigationController+notification.h"
#import "StatusFooterView.h"

typedef enum :NSUInteger
{
    kLoadDefault,//基本加载
    kLoadNew,//加载更新的数据
    kLoadMore//加载更多的数据
    
}StatusLoadType;

@interface HomeVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSMutableArray *statuses;//请求到的微博数据

@property (nonatomic)BOOL loading;//正在加载时的判断

@property (nonatomic)BOOL loadMoreEnd;//加载更多结束的判断

@end
@implementation HomeVC

-(NSMutableArray *)statuses
{
    if (!_statuses) {
        _statuses=[NSMutableArray array];
    }
    return _statuses;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.statuses = [NSMutableArray arrayWithArray:[DataBaseEngine getStatusFromDB]];
    [self loadData];
    
    
    //添加下拉刷新的控件
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(loadNew:) forControlEvents:UIControlEventValueChanged];
    //设置refreshControl的标题为下拉刷新
    self.refreshControl.attributedTitle =[self refreshControlTileWithString:@"下拉刷新"];
    
    //注册footerView
    [self.tableView registerNib:[UINib nibWithNibName:@"StatusFooterView" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"footerView"];

}

#pragma mark -custom
-(NSAttributedString *)refreshControlTileWithString:(NSString *)title
{
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor grayColor]};
    NSAttributedString *string = [[NSAttributedString alloc]initWithString:title attributes:attributes];
    return string;
}

-(void)loadNew:(UIRefreshControl *)sender
{
    self.refreshControl.attributedTitle = [self refreshControlTileWithString:@"正在刷新"];
    [self loadDataWithType:kLoadNew];
}



-(void)loadMore
{
    [self loadDataWithType:kLoadMore];
}


-(void)endrefresh
{
    [self.refreshControl endRefreshing];
    self.refreshControl.attributedTitle =[self refreshControlTileWithString:@"下拉刷新"];
}
-(void)loadDataWithType:(StatusLoadType)loadType
{
    //url地址
    NSString *urlString =[kBaseUrl stringByAppendingPathComponent:@"statuses/home_timeline.json"];
    //基本的请求参数
    NSMutableDictionary *params =[[Accoount currentAccount]requestParams];
    switch (loadType) {
        case kLoadNew:
        {
            [params setObject:[self.statuses.firstObject statusId] forKey:@"since_id"];
        }
            break;
        case kLoadMore:
        {
            [params setObject:[self.statuses.firstObject statusId] forKey:@"max_id"];
        }
            break;
            
        default:
            break;
    }
    //加载更多完成
    if (loadType == kLoadMore && self.loadMoreEnd) {
        return;
    }
    //有正在加载的过程，就不进行新的加载
    if (self.loading) {
        return;
    }
    self.loading = YES;
    //进行网络请求
    AFHTTPRequestOperationManager *manager =[AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"刷新了数据:%ld条",[responseObject[@"statuses"]count]);
        //model数组
        NSMutableArray *result = [NSMutableArray array];
        //json数组
        NSArray *statusArray = responseObject[@"statuses"];
        [statusArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Status *status = [[Status alloc] initStatusWithDic:obj];
            [result addObject:status];
        }];
        if (loadType == kLoadNew) {
            //将转化的模型，整体插入到数据的最前面
            [self.statuses insertObjects:result atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, result.count)]];
            //通知用户刷新了多少条数据
            [self.navigationController showNotification:[NSString stringWithFormat:@"更新了%ld条微博",result.count]];
            
            [self endrefresh];
        }else{
            [self.statuses addObjectsFromArray:result];
        }
        
        [self.tableView reloadData];
        
        //加载更多完成
        if (loadType == kLoadMore && statusArray.count <20) {
            self.loadMoreEnd = YES;
        }
        self.loading = NO;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        self.loading =NO;
        
    }];

    
    
    
}
//从服务器加载数据
-(void)loadData
{
    [self loadDataWithType:kLoadDefault];
}
-(void)reTwitter:(UIButton *)button
{
    
    
}
-(void)comment:(UIButton *)button
{
    
}
-(void)like:(UIButton *)button
{
    
}

#pragma mark -Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //用section区分微博
    return self.statuses.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //一个section只有一条微博
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StatusTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"statusCell" forIndexPath:indexPath];
    [cell bandingStatus:self.statuses[indexPath.section]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //计算出cell高度
//    StatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"statusCell"];
//    //要计算高度需要绑定内容
//    [cell bandingStatus:self.statuses[indexPath.row]];
//    CGSize size =[cell.contentView  systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//      return size.height+1;
    
    Status *info =self.statuses[indexPath.section];
    return [StatusTableViewCell heightWithStatus:info];
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //indexPath行将要显示
    //进行加载更多的操作
    if (self.statuses.count -indexPath.section <=5) {
        //用户滑动到了倒数第五条，可以进行加载更多
        [self loadMore];
        
    }
    
}
//对微博下边的评论 赞  转发 三个按钮的设置
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    StatusFooterView *footerView =[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footerView"];
    //绑定内容
    [footerView bandingStatus:self.statuses[section]];
    [footerView.reTwitter addTarget:self action:@selector(reTwitter:) forControlEvents:UIControlEventTouchUpInside];
    footerView.reTwitter.tag = section;
    [footerView.comment addTarget:self action:@selector(comment) forControlEvents:UIControlEventTouchUpInside];
    [footerView.like addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
    return footerView;
}
//footerView的高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30.f;
}



@end

