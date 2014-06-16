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
    
    CFAlbumView * albumView = [[CFAlbumView alloc] initWithFrame: rect];
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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && nil == self.view.window) {
        self.view = nil;
    }
}

- (void) tapGesture: (UITapGestureRecognizer *) gesture
{
    CFPhotoInfoViewController * photoVC = [[CFPhotoInfoViewController alloc] init];
    photoVC.title = self.view.infoLabel.text;
    
    [self.navigationController pushViewController:photoVC animated:YES];
    
    [photoVC release];
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

# pragma mark - CFAlbumViewDelegate协议方法.
- (CGFloat) widthForPhotoInAlbumView: (CFAlbumView *) albumView
{
    return albumView.frame.size.width;
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
        // ???:又出现了错误值!图片信息无效的提示!
        [self.view showPhotoViewAtIndex: [obj integerValue]];
    }];
//    if (indexes.count > 1) { // 说明正在滑动
//            NSLog(@"*");
//        [indexes enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
//            // ???:又出现了错误值!图片信息无效的提示!
//            [self.view showPhotoViewAtIndex: [obj integerValue]];
//        }];
//        return;
//    }
    
//    NSUInteger curNum = [(NSNumber *)[indexes objectAtIndex:0] integerValue];
//    
//    // 要在label显示的提示信息
//    NSString * info = [[[NSString alloc] initWithFormat:@"正在显示页数 %lu / %lu", curNum + 1, sum] autorelease];
//
//    // 设置图片
//    [self.view showPhotoViewAtIndex: curNum];
//    
//    // 设置lable
//    self.view.infoLabel.text = info;
//    
//    // 修改pageControl的值.
//    // ???:滑动速度过快时,pageControl无法总是同步更新.
//    // ???:可能的解决策略:把此步的相关方法封装为一个方法,在加速或者减速时也调用.
//    self.view.pageControl.currentPage = curNum;
//    [self.view.pageControl updateCurrentPageDisplay];
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
