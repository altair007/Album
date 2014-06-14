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
#import "CFPhotoView.h"

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
    // ???:如何动态获取导航栏高度?必须用固定值?
    rect.size.height -= 64;
    
    CFAlbumView * albumView = [[CFAlbumView alloc] initWithFrame: rect];
    albumView.delegate = self;
    albumView.namesOfPhotos = [CFAlbumController sharedInstance].namesOfPhotos;
    
    self.view = albumView;
    [albumView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view
    self.navigationItem.title = @"相册";
    // ???: 应该使用自定义的ImageView,可以同时存储图片对象和图片名称.
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
    photoVC.title = self.view.label.text;
    
    [self.navigationController pushViewController:photoVC animated:YES];
    
    [photoVC release];
}

- (void) handlePageControlAction:(UIPageControl *)pageControl
{
    // 获取相册对象
    
    // 计算需要的内容偏移量.
    CGPoint contentOffset = CGPointMake((pageControl.currentPage) * (self.view.frame.size.width),self.view.contentOffset.y);
    
    // 设置相册的偏移,使需要的图片显示出来.
    [self.view setContentOffset:contentOffset animated: YES];
    
}

- (NSUInteger) numberOfPhotos
{
    NSUInteger number = self.namesOfPhotos.count;
    return number;
}

- (NSArray *) namesOfPhotos
{
    NSArray * namesOfPhotos = [CFAlbumController sharedInstance].namesOfPhotos;
    
    return namesOfPhotos;
}

- (NSArray *) indexesOfAllVisiblePhotos
{
    NSArray * indexes;
    
    // 考虑往左过度偏移的情况
    if (self.view.contentOffset.x < 0) {
        indexes = @[[NSNumber numberWithInteger:0]];
        return indexes;
    }
    
    CGFloat value =  self.view.contentOffset.x / self.view.frame.size.width;
    
    // 向上取整,
    NSInteger up = ceil(value);
    
    // 向下取整
    NSInteger down = floor(value);
    
    if (up == down) {
        indexes = @[[NSNumber numberWithInteger: down]];
        return indexes;
    }
    
    indexes = @[[NSNumber numberWithInteger: down],[NSNumber numberWithInteger: up]];
    
    return indexes;
}

- (void)scrollViewDidScroll:(CFAlbumView *) album
{
    // 触发这个事件的也可能是放置单张相片的UIScrollView
    // ???:有必要考虑这种情况吗?
    if ( ! [album isKindOfClass: [CFAlbumView class]]) {
        return;
    }
    
    // 修改lable的提示信息
    // 计算图片总数量
    NSUInteger sum = [self numberOfPhotos];
    
    // 计算当前是第几张图片,从零开始计数
    NSArray * indexes = [self indexesOfAllVisiblePhotos];
    
    if (indexes.count > 1) { // 说明正在滑动
        [indexes enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
            [self setPhotoAtIndex: [obj integerValue]];
        }];
        return;
    }
    
    NSUInteger curNum = [(NSNumber *)[indexes objectAtIndex:0] integerValue];
    
    // 要在label显示的提示信息
    NSString * info = [[[NSString alloc] initWithFormat:@"正在显示页数 %lu / %lu", curNum + 1, sum] autorelease];
    
    // 设置图片
    [self setPhotoAtIndex: curNum];
    
    // ???:不建议相册视图直接继承自UIScrollView.这样,label和pageControl边框就不要动态调整了!
    // 设置lable
    album.label.text = info;
    CGRect rectOfLabel = album.label.frame;
    rectOfLabel.origin.x = self.view.contentOffset.x;
    album.label.frame = rectOfLabel;
    
    // 修改pageControl的值
    album.pageControl.currentPage = curNum;
    CGRect rectOfPageControl = album.pageControl.frame;
    rectOfPageControl.origin.x = self.view.contentOffset.x;
    album.pageControl.frame = rectOfPageControl;
    [album.pageControl updateCurrentPageDisplay];
}

- (void) setPhotoAtIndex: (NSUInteger) index
{
    // 先判断此位置上是否已经有照片,已经有,则直接返回.
    if (YES == [self isHasPhotoAtIndex: index]) {
        return;
    }
    
    // 获取此位置图片的名称.
    NSString * nameOfPhoto = [self photoNameAtIndex: index];
    
    // 获取照片视图.
    CFPhotoView * photoView = [self.view dequeueReusablePhotoView];
    
    // 设置照片视图属性.
    photoView.nameOfPhoto = nameOfPhoto;
    photoView.frame = CGRectMake(index * self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
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

- (BOOL)isHasPhotoAtIndex: (NSUInteger) index
{
    __block BOOL result = NO;
    
    // 先获取的此位置对应的横向偏移坐标
    CGFloat x = index * self.view.frame.size.width;
    
    // 判断已经存在的照片视图中是否已经有位于此位置的
    [self.view.photoViews enumerateObjectsUsingBlock:^(CFPhotoView * obj, NSUInteger idx, BOOL *stop) {
        if (x == obj.frame.origin.x) {
            result = YES;
            * stop = YES;
        }
    }];
    
    return result;
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

@end
