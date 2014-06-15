//
//  CFAlbumView.m
//  Album
//
//  Created by   颜风 on 14-5-30.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import "CFAlbumView.h"
#import "CFAlbumViewController.h"
#import "CFAlbumController.h"
#import "CFPhotoView.h"
#import "CFPhotoContainerView.h"

@interface CFAlbumView ()
@property (retain, nonatomic, readwrite) NSMutableArray * photoViews; //!< 存储相片视图的数组.
@property (retain, nonatomic, readwrite) UIPageControl * pageControl; //!< 页面控制
@property (retain, nonatomic, readwrite) UILabel * label; //!< 信息提示
@property (retain, nonatomic, readwrite) UIScrollView * albumSV; //!< 相册主视图
@property (retain ,nonatomic, readwrite) CFPhotoContainerView * photoCV; //!< 照片容器视图.
@end

@implementation CFAlbumView
- (void)dealloc
{
    self.namesOfPhotos = nil;
    self.photoViews = nil;
    self.pageControl = nil;
    self.label = nil;
    self.albumSV= nil;
    
    [super dealloc];
}

#pragma mark
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupSubviews];
    }
    return self;
}

- (void) setupSubviews
{
//    /* 设置相册的主视图 */
//    CGRect rectOfalbumSV = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
//    
//    UIScrollView * albumSV = [[UIScrollView alloc] initWithFrame: rectOfalbumSV];
//    // 设置分页效果
//    albumSV.pagingEnabled = YES;
//    
//    // 不允许同时进行水平和竖直方向上的滚动.
//    albumSV.directionalLockEnabled = YES;
//    
//    self.albumSV = albumSV;
//    [albumSV release];
//    
//    
//    [self addSubview: self.albumSV];
//    [self sendSubviewToBack: self.albumSV];
    // ???:多层级视图,共用一个控制器,合适吗?逻辑嵌套过深,有什么好的解决方案吗?
    /* 设置相片容器 */
    CFPhotoContainerView * photoCV = [[CFPhotoContainerView alloc] initWithFrame:self.frame];
    self.photoCV = photoCV;
    [photoCV release];
    
    /* 创建支持页面切换的控件. */
    UIPageControl * pageC = [[[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height * 0.95, self.frame.size.width, self.frame.size.height * 0.05)] autorelease];
    
    // 设置背景颜色
    pageC.backgroundColor = [UIColor grayColor];
    
    // 设置透明度
    pageC.alpha = 0.3;
    
    // 设置分页指示器颜色
    pageC.currentPageIndicatorTintColor = [UIColor blackColor];
    pageC.pageIndicatorTintColor = [UIColor whiteColor];
    
    // 设置何时显示当前页(圆点)
    pageC.defersCurrentPageDisplay = YES;
    
    // 添加响应方法
    [pageC addTarget:[CFAlbumController sharedInstance].albumVC action:@selector(handlePageControlAction:) forControlEvents: UIControlEventValueChanged];
    
    self.pageControl = pageC;
    [pageC release];
    
    /* 设置用于显示相册信息的label */
    // FIXEME:64明显不是最优值!
    UILabel * label = [[[UILabel alloc] initWithFrame:CGRectMake( 0, 64, self.frame.size.width * 0.3, self.frame.size.height * 0.05)] autorelease];
    
    label.adjustsFontSizeToFitWidth = YES;
    label.textColor = [UIColor blackColor];
    
    self.label = label;
    [label release];
}

- (void)setNamesOfPhotos:(NSArray *)namesOfPhotos
{
    // 直接用此数据设置相册容器
    self.photoCV.namesOfPhotos = namesOfPhotos;
    
    // 设置页面控制器的页数.
    self.pageControl.numberOfPages = self.namesOfPhotos.count;
}

-(NSArray *)namesOfPhotos
{
    return self.photoCV.namesOfPhotos;
}

- (void)setDelegate:(id<UIScrollViewDelegate>)delegate
{
    self.photoCV.delegate = delegate;
}

- (id<UIScrollViewDelegate>)delegate
{
    return self.photoCV.delegate;
}

- (CFPhotoView *) dequeueReusablePhotoView
{
    CFPhotoView * result = [self.photoCV dequeueReusablePhotoView];

    return result;
}

-(void)setPhotoCV:(CFPhotoContainerView *)photoCV
{
    [photoCV retain];
    [_photoCV release];
    _photoCV = photoCV;
    
    if (NO == [self.subviews containsObject: _photoCV]) {
        [self addSubview: _photoCV];
        // ???:验证一下,nil添加作为子视图,会不会出错.
        [self addSubview: nil];
    }
}

-(void)setPageControl:(UIPageControl *)pageControl
{
    [pageControl retain];
    [_pageControl release];
    _pageControl = pageControl;
    
    if (NO == [self.subviews containsObject: _pageControl]) {
        [self addSubview: _pageControl];
    }
}

- (void)setLabel:(UILabel *)label
{
    [label retain];
    [_label release];
    _label = label;
    
    if (NO == [self.subviews containsObject: _label]) {
        [self addSubview: _label];
    }
}
@end
