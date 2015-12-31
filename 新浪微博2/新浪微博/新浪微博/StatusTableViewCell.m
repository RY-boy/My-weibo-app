//
//  StatusTableViewCell.m
//  新浪微博
//
//  Created by qingyun on 15/12/26.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "StatusTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "Common.h"
#import "NSString+StringSize.h"
#import "Status.h"
#import "User.h"
#import "SDPhotoBrowser.h"


#define kImageWith 90//图片的宽
#define kImageHeight 90//图片的高
#define kImageMarge 5 //图片之间的间隔

@interface StatusTableViewCell ()<SDPhotoBrowserDelegate>

@end

@implementation StatusTableViewCell

+(CGFloat)heightWithStatus:(Status *)info
{
    //首先计算出文字显示需要的高度
    NSString *text = info.text;
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:17] With:kAppScreenBounds.size.width-20];
    //再加上上下约束的高度，就是cell的总高度
    Status *reStatus =info.retweeted_status;
    if (reStatus) {
        //加上转发微博需要的高度
        CGSize reStitterSize =[reStatus.text sizeWithFont:[UIFont systemFontOfSize:17] With:kAppScreenBounds.size.width-20];
        CGFloat imageHeight = [StatusTableViewCell imageSuperHeightWith:reStatus.pic_urls];
        return size.height +reStitterSize.height +imageHeight +60 +1;
    }else{
        //没有转发微博的时候，加上正文图片的高度
        //计算出图片显示需要的高度
        CGFloat imageHeight =[StatusTableViewCell imageSuperHeightWith:info.pic_urls];
        
           return size.height +imageHeight+60+2+1;
    }
}

//
+(CGFloat)imageSuperHeightWith:(NSArray *)pic_urls
{
    NSInteger count =pic_urls.count;
    if (count==0) {
        return 0;
    }
    if (count>9) {
        count=9;
    }
    NSInteger line =(count-1) / 3 +1;//计算出需要多少行
    CGFloat height =line *kImageHeight + (line -1)*kImageMarge;
    return height;
    
}


- (void)awakeFromNib
{
    //label预计显示的最大宽度
    self.countent.preferredMaxLayoutWidth =kAppScreenBounds.size.width-20;
    self.reTwitterlabel.preferredMaxLayoutWidth=kAppScreenBounds.size.width-20;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)bandingStatus:(Status *)info
{
//     NSDictionary *user = info[@"user"];
    NSString *urlString = info.user.profile_image_url;
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
//    self.icon.image = [UIImage imageWithData:data];
    //存在bug 网速不好的时候会重现数据（如图片混乱）
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.icon.image = [UIImage imageWithData:data];
//
//        });
//            });
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:urlString]];
    self.icon.layer.cornerRadius=self.icon.bounds.size.width /2;
    self.icon.layer.masksToBounds = YES;
    
    self.name.text =info.user.name;
    self.time.text =info.timeAgo;
    self.source.text =info.source;
    self.countent.text =info.text;
    Status *retwitter = info.retweeted_status;
    if (retwitter) {
        //清空微博配图
        [self layoutImage:nil forView:self.imageSuperView HeightContients:self.imageSuperContraints];
        self.reTwitterlabel.text = retwitter.text;
        [self layoutImage:retwitter.pic_urls forView:self.reTwitterImageSuperView HeightContients:self.reImageSuperViewHeightCon];
    }else{
        //布局微博子视图
        [self layoutImage:info.pic_urls forView:self.imageSuperView HeightContients:self.imageSuperContraints];
        //清空转发的内容
        self.reTwitterlabel.text =nil;
        [self layoutImage:nil forView:self.reTwitterImageSuperView HeightContients:self.reImageSuperViewHeightCon];

    }
    
}
-(void)layoutImage:(NSArray *)images forView:(UIView *)view HeightContients:(NSLayoutConstraint *)heighthConstraint
{
    //移除掉view的子视图
    NSArray *subView =view.subviews;
    //数组中的每一个对象，都会发一个这样的消息
    [subView makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //将view调整到合适的高度
    CGFloat height =[StatusTableViewCell imageSuperHeightWith:images];
    //修改的是高度上的约束
    heighthConstraint.constant =height;

    
    //添加新的View
    [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //取出图片
        NSString *urlstring = obj[@"thumbnail_pic"];
        //初始化ImageView
        UIImageView *imageView = [[UIImageView alloc]init];
        //计算出行和列
        CGFloat imageX =idx%3*(kImageWith +kImageMarge);
        CGFloat imageY = idx/3*(kImageHeight +kImageMarge);
        imageView.frame = CGRectMake(imageX, imageY, kImageWith, kImageHeight);
        imageView.userInteractionEnabled =YES;
        
        //添加响应
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageShow:)];
        [imageView addGestureRecognizer:tap];
        imageView.tag = idx;
        
        
        [view addSubview:imageView];
//        缓存图片
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlstring]];
    }];
}

//
-(void)imageShow:(UITapGestureRecognizer *)gesture
{
    UIView *view =gesture.view;
    NSLog(@"view.tag:%ld",view.tag);
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc]init];
    browser.sourceImagesContainerView = view.superview;
    browser.imageCount = view.superview.subviews.count;
    browser.currentImageIndex =(int)view.tag;
    browser.delegate =self;
    [browser show];
}

-(UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    //返回占位图
    UIView *superView =self.imageSuperView.subviews.count !=0 ? self.imageSuperView : self.reTwitterImageSuperView;
    
    UIImageView *imageView = superView.subviews[index];
    return imageView.image;
}


-(NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    // 返回高质量图片的url
    //返回占位图
    UIView *superView = self.imageSuperView.subviews.count !=0 ? self.imageSuperView : self.reTwitterImageSuperView;
    UIImageView *imageView =superView.subviews[index];
   
    //找到图片绑定的url
    NSString *urlString = imageView.sd_imageURL.absoluteString;
    //组合大图的url
    urlString = [urlString stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"large"];
    return [NSURL URLWithString:urlString];
    
}


@end
