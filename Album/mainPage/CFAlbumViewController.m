//
//  CFAlbumViewController.m
//  Album
//
//  Created by   颜风 on 14-6-14.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import "CFAlbumViewController.h"
#import "CFAlbumController.h"
#import "CFPhotoInfoViewController.h"
#import "CFPhotoViewCell.h"
#import "CFPhotoContainerView.h"

@interface CFAlbumViewController ()

@end

@implementation CFAlbumViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    CGRect  rect = [UIScreen mainScreen].bounds;
    
    CFAlbumView * albumView = [[CFAlbumView alloc] init];
//    CFAlbumView * albumView = [[CFAlbumView alloc] initWithFrame: rect];
    // ???:在没设置代理或数据源代理时,不应该让程序崩!应该对可选或者必选方法做出不同的处理!(容错)
    albumView.delegate = self;
    albumView.dataSource = self;
    
    self.view = albumView;
    [albumView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view
    self.navigationItem.title = @"相册";
    
    if ((nil != self.navigationController) && (NO == [self.navigationController isNavigationBarHidden])) { // 导航栏存在且未隐藏,视图整体下移64(导航栏高度).
        CGRect rect = self.view.bounds;
        rect.origin.y = - 64;
        self.view.bounds = rect;
        
        // 修正UIScrollowView的默认实现.
        self.view.photoCV.contentInset =UIEdgeInsetsMake(-64, 0, 0, 0);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && nil == self.view.window) {
        self.view = nil;
    }
}

- (void) handlePageControlAction:(UIPageControl *)pageControl
{
    // 计算需要的内容偏移量.
    CGPoint contentOffset = CGPointMake((pageControl.currentPage) * (self.view.frame.size.width),self.view.photoCV.contentOffset.y);
    
    // 设置相册的偏移,使需要的图片显示出来.
    [self.view.photoCV setContentOffset:contentOffset animated: YES];
    
}


- (NSString *)photoNameAtIndex:(NSUInteger)index
{
    NSArray * photoNames = [CFAlbumController sharedInstance].namesOfPhotos;
    
    if (photoNames.count <= index) {
        return nil;
    }
    
    NSString * nameOfPhoto = [photoNames objectAtIndex: index];
    
    return nameOfPhoto;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"view- frame:%@", NSStringFromCGRect(self.view.photoCV.frame));
    NSLog(@"view - bounce:%@", NSStringFromCGRect(self.view.photoCV.bounds));
}

# pragma mark - CFAlbumViewDelegate协议方法.
- (CGFloat) widthForPhotoInAlbumView: (CFAlbumView *) albumView
{
    return albumView.frame.size.width;
}

- (void) albumView:(CFAlbumView *)albumView didSelectPhotoAtIndex: (NSUInteger) index
{
    [[CFAlbumController sharedInstance] swithToPhotoInfoViewAtIndex: index];
}

- (void)scrollViewDidScroll:(UIScrollView *) scrollView
{

    // 获取图片总数量
    NSUInteger sum = [self.view numberOfPhotos];
    
    if (0 == sum) { // 没有图片,直接返回
        return;
    }
    
    // 计算当前是第几张图片,从零开始计数
    NSArray * indexes = [self.view latestIndexesForVisiblePhotoViews];
    
    [indexes enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        [self.view showPhotoViewAtIndex: [obj integerValue]];
    }];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    UIImageView * zoomImageView = (UIImageView *) [scrollView.subviews objectAtIndex: 0];
    return zoomImageView;
}

#pragma mark - CFAlbumViewDataSource协议方法
- (NSUInteger) numberOfPhotosInAlbumView: (CFAlbumView *) albumView
{
    NSUInteger result = [[[CFAlbumController sharedInstance] namesOfPhotos] count];
    
    return result;
}

- (CFPhotoViewCell *) albumView: (CFAlbumView *) albumView
                   photoAtIndex: (NSUInteger) index
{
    // 获取此位置图片的名称.
    NSString * nameOfPhoto = [self photoNameAtIndex: index];
    
    // 获取照片视图.
    CFPhotoViewCell * photoView = [self.view dequeueReusablePhotoViewAtIndex:index];
    
    if (nil == photoView) {
        photoView = [[CFPhotoViewCell alloc] initWithFrame:CGRectMake(index * self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
        //        多余的?
        //        [photoView autorelease];
    }
    
    // 设置照片视图属性.
    photoView.nameOfPhoto = nameOfPhoto;
    
    return photoView;
}

@end
