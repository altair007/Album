//
//  CFMainViewController.m
//  Album
//
//  Created by   颜风 on 14-5-30.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import "CFMainViewController.h"
#import "CFAlbumView.h"

@interface CFMainViewController ()

@end

@implementation CFMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 创建相册
    // FIXME:此处应该使用一个model
    NSArray * photoes = @[[UIImage imageNamed:@"the_secret_1.jpg"],
                          [UIImage imageNamed:@"the_secret_2.jpg"],
                          [UIImage imageNamed:@"the_secret_3.jpg"],
                          [UIImage imageNamed:@"the_secret_4.jpg"],
                          [UIImage imageNamed:@"the_secret_5.jpg"],
                          [UIImage imageNamed:@"the_secret_6.jpg"],
                          [UIImage imageNamed:@"the_secret_7.jpg"],
                          [UIImage imageNamed:@"the_secret_8.jpg"],
                          [UIImage imageNamed:@"the_secret_9.jpg"],
                          [UIImage imageNamed:@"the_secret_10.jpg"]];
    
    self.album = [[[CFAlbumView alloc] initWithFrame:[UIScreen mainScreen].bounds  delegate:self dataSource:photoes] autorelease];
    
    [self.view addSubview: self.album];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 协议方法
- (void) handlePageControlAction:(UIPageControl *)pageControl
{
    // 使用pageControl实现页码指示
    self.album.label.text = [[NSString alloc] initWithFormat:@"正在显示 %ld/%ld", pageControl.currentPage + 1, pageControl.numberOfPages];
    
    // 控制pageControl能够实现scrollview的页面切换
    // 计算需要的内容偏移量.

    // !!!:静态分析器提示潜在的内存泄露错误!!!
    CGPoint contentOffset = CGPointMake((pageControl.currentPage) * (self.album.album.frame.size.width), self.album.album.contentOffset.y);
    
    // 设置相册的偏移,使需要的图片显示出来.
    [self.album.album setContentOffset:contentOffset animated: YES];
    
}

#pragma mark - 重写方法
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    UIImageView * zoomImageView = (UIImageView *) [scrollView.subviews objectAtIndex: 0];
    return zoomImageView;
}

- (void) dealloc
{
    self.album = nil;
    [super dealloc];
}

@end
