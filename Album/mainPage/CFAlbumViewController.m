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
    albumView.delegate = self;
    
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
    photoVC.title = self.view.label.text;
    
    [self.navigationController pushViewController:photoVC animated:YES];
    
    [photoVC release];
}

- (void) handlePageControlAction:(UIPageControl *)pageControl
{
    // ???:或许可以通过某中简单地"取余"策略,实现轮转!
    // 计算需要的内容偏移量.
    CGPoint contentOffset = CGPointMake((pageControl.currentPage) * (self.view.frame.size.width),self.view.photoCV.contentOffset.y);
    
    // 设置相册的偏移,使需要的图片显示出来.
    [self.view.photoCV setContentOffset:contentOffset animated: YES];
    
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
    if (self.view.photoCV.contentOffset.x < 0) {
        indexes = @[[NSNumber numberWithInteger:0]];
        return indexes;
    }
    
    CGFloat value =  self.view.photoCV.contentOffset.x / self.view.photoCV.frame.size.width;
    
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

- (void)scrollViewDidScroll:(UIScrollView *) scrollView
{
    // ???:考虑零张图片的特殊情况!
    // ???:pageControll  单张图片或者无图片时,不显示.
    
    // 触发这个事件的也可能是放置单张相片的UIScrollView
    // ???:有必要考虑这种情况吗?
    // ???:为什么不支持缩放了?
//    if ( ! [album isKindOfClass: [CFAlbumView class]]) {
//        return;
//    }
    
    // 修改lable的提示信息
    // 计算图片总数量
    NSUInteger sum = [self numberOfPhotos];
    
    // 计算当前是第几张图片,从零开始计数
    NSArray * indexes = [self.view latestIndexesForVisiblePhotoViews];
    
    if (indexes.count > 1) { // 说明正在滑动
        [indexes enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
            [self.view showPhotoViewAtIndex: [obj integerValue]];
        }];
        return;
    }
    
    NSUInteger curNum = [(NSNumber *)[indexes objectAtIndex:0] integerValue];
    
    // 要在label显示的提示信息
    NSString * info = [[[NSString alloc] initWithFormat:@"正在显示页数 %lu / %lu", curNum + 1, sum] autorelease];

    // 设置图片
    [self.view showPhotoViewAtIndex: curNum];
    
    // 设置lable
    self.view.label.text = info;
    
    // 修改pageControl的值.
    // ???:滑动速度过快时,pageControl无法总是同步更新.
    // ???:可能的解决策略:把此步的相关方法封装为一个方法,在加速或者减速时也调用.
    self.view.pageControl.currentPage = curNum;
    [self.view.pageControl updateCurrentPageDisplay];
}

- (CFPhotoViewCell *) albumView: (CFAlbumView *) albumView
               photoAtIndex: (NSUInteger) index
{
    // ???:以下两步可以省,但是逻辑必须在其他步中体现.
    // ???:省略后,可能引起最后一个视图后直接出现窗口.
    // ???:可以使用两个大的ScrollView模仿轮转.
    // 是否有有效的位置?
    if (index >= [self numberOfPhotos]) {
        return nil;
    }
    
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

- (NSString *)photoNameAtIndex:(NSUInteger)index
{
    NSArray * photoNames = [CFAlbumController sharedInstance].namesOfPhotos;
    
    if (photoNames.count <= index) {
        return nil;
    }
    
    NSString * nameOfPhoto = [photoNames objectAtIndex: index];
    
    return nameOfPhoto;
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

#pragma mark - CFAlbumViewDataSource协议方法
- (NSUInteger) numberOfPhotosInAlbumView: (CFAlbumView *) albumView
{
    NSUInteger result = [[[CFAlbumController sharedInstance] namesOfPhotos] count];
    
    return result;
}

@end
