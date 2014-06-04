//
//  CFMainViewController.m
//  Album
//
//  Created by   颜风 on 14-5-30.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import "CFMainViewController.h"
#import "CFAlbumView.h"
#import "CFPhotoViewController.h"

@interface CFMainViewController ()

@end

@implementation CFMainViewController
- (void) dealloc
{
    self.album = nil;
    
    [super dealloc];
}

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
    
    self.navigationItem.title = @"相册";
    
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
- (void) tapGesture: (UITapGestureRecognizer *) gesture
{
    CFPhotoViewController * photoVC = [[CFPhotoViewController alloc] init];
    photoVC.title = self.album.label.text;
    
    [self.navigationController pushViewController:photoVC animated:YES];
    
    [photoVC release];
}

- (void) handlePageControlAction:(UIPageControl *)pageControl
{
    // 获取相册对象
    CFAlbumView * album = (CFAlbumView *) pageControl.superview;
    
    // 计算需要的内容偏移量.
    CGPoint contentOffset = CGPointMake((pageControl.currentPage) * (album.scrollView.frame.size.width), album.scrollView.contentOffset.y);
    
    // 设置相册的偏移,使需要的图片显示出来.
    [album.scrollView setContentOffset:contentOffset animated: YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 获取相册对象
    CFAlbumView * album = (CFAlbumView *)scrollView.superview;
    
    // 触发这个事件的也可能是放置单张相片的UIScrollView
    if ( ! [album isKindOfClass: [CFAlbumView class]]) {
        return;
    }
    
    // 修改lable的提示信息
    // 计算图片总数量
    NSUInteger sum = (NSUInteger) scrollView.contentSize.width / scrollView.frame.size.width;
    
    // 计算当前是第几张图片,从零开始计数
    NSUInteger curNum = (NSUInteger) scrollView.contentOffset.x / scrollView.frame.size.width;
    
    // 考虑往左过度偏移的情况
    if (scrollView.contentOffset.x < 0) {
        curNum = 0;
    }
    
    // ???:无法实现:将前一张照片(向后浏览)或者前一张照片(向前浏览)的照片尺寸重置为默认值
    // !!!:当使用不同的容器放置单张照片时,下面的逻辑需要简单修改!
    // !!!:很明显,相册封装的不够好,需要定义一个单独的"相册页类",然后使用在相册类中存在一个数组存储相片!
    // !!!: 应该提供一个接口,可以设置label,而不是直接操作lable!
    // !!!:存在一个BUG  放大后,无法正确复原!
    // 分情况处理:先解决单向的复原!
    // 由前到后!
//    if (curNum != 0) {
//        NSLog(@"%ld", curNum);
//        UIScrollView * temp = [scrollView.subviews objectAtIndex:curNum - 1];
//        UIImageView * tempImageView = (UIImageView *)temp.subviews[0];
////        temp.frame = CGRectMake(0, 0,  320, 568);
////        temp.bounds = CGRectMake(0, 0,  320, 568);
//        tempImageView.frame = CGRectMake(0, 0,  320, 568);
////        tempImageView.bounds = CGRectMake(0, 0,  320, 568);
//    }
//    if (curNum + 1 < scrollView.subviews.count - 1) {
//        UIScrollView * temp = [scrollView.subviews objectAtIndex:curNum + 1];
//        UIImageView * tempImageView = (UIImageView *)temp.subviews[0];
////        temp.frame = CGRectMake(0, 0,  320, 568);
////        temp.bounds = CGRectMake(0, 0,  320, 568);
//        tempImageView.frame = CGRectMake(0, 0,  320, 568);
////        tempImageView.bounds = CGRectMake(0, 0,  320, 568);
////        temp.bounds = CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height);
////        tempImageView.frame = scrollView.frame;
////        tempImageView.bounds = scrollView.bounds;
//    }
    
    // 要在label显示的提示信息
    NSString * info = [[[NSString alloc] initWithFormat:@"正在显示页数 %lu / %lu", curNum + 1, sum] autorelease];
    
    // 设置lable
    album.label.text = info;
    
    // 修改pageControl的值
    album.pageControl.currentPage = curNum;
    [album.pageControl updateCurrentPageDisplay];
}

// any zoom scale changes
- (void)scrollViewDidZoom:(UIScrollView *)scrollView NS_AVAILABLE_IOS(3_2)
{
    
}

// called on start of dragging (may require some time and or distance to move)
// called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0)
{
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}

// called on finger up as we are moving
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    
}

// called when scroll view grinds to a halt
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

// called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
}

// return a view that will be scaled. if delegate returns nil, nothing happens
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    UIImageView * zoomImageView = (UIImageView *) [scrollView.subviews objectAtIndex: 0];
    return zoomImageView;
}

// called before the scroll view begins zooming its content
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view NS_AVAILABLE_IOS(3_2)
{
    
}

// scale between minimum and maximum. called after any 'bounce' animations
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    
}

// return a yes if you want to scroll to the top. if not defined, assumes YES
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    return NO;
}

// called when scrolling animation finished. may be called immediately if already at top
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    
}

@end
