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

@interface CFAlbumView ()
@property (retain, nonatomic, readwrite) NSMutableArray * photoViews; //!< 存储相片视图的数组.
@property (retain, nonatomic, readwrite) UIPageControl * pageControl; //!< 页面控制
@property (retain, nonatomic, readwrite) UILabel * label; //!< 信息提示
@end

@implementation CFAlbumView
- (void)dealloc
{
    self.namesOfPhotos = nil;
    self.photoViews = nil;
    self.pageControl = nil;
    self.label = nil;
    
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
    // 设置分页效果
    self.pagingEnabled = YES;
    
    // 不允许同时进行水平和竖直方向上的滚动.
    self.directionalLockEnabled = YES;
    
    // 创建支持页面切换的控件.
    self.pageControl = [[[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height * 0.95, self.frame.size.width, self.frame.size.height * 0.05)] autorelease];
    
    // 设置背景颜色
    self.pageControl.backgroundColor = [UIColor grayColor];
    
    // 设置透明度
    self.pageControl.alpha = 0.3;
    
    // 设置分页指示器颜色
    self.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    
    // 设置何时显示当前页(圆点)
    self.pageControl.defersCurrentPageDisplay = YES;
    
    // 添加响应方法
    [self.pageControl addTarget:[CFAlbumController sharedInstance].albumVC action:@selector(handlePageControlAction:) forControlEvents: UIControlEventValueChanged];
    
    [self addSubview: self.pageControl];
    
    // 添加lable,显示相册信息.
    self.label = [[[UILabel alloc] initWithFrame:CGRectMake( 0, 0, self.frame.size.width * 0.3, self.frame.size.height * 0.05)] autorelease];
    
    // 设置文本自适应
    self.label.adjustsFontSizeToFitWidth = YES;
    
    // 设置颜色.
    self.label.textColor = [UIColor redColor];
    
    [self addSubview: self.label];
}
- (void)setNamesOfPhotos:(NSArray *)namesOfPhotos
{
    // 设置属性
    [namesOfPhotos retain];
    [_namesOfPhotos release];
    _namesOfPhotos = namesOfPhotos;
    
    // 设置内容偏移量
    self.contentSize = CGSizeMake(self.frame.size.width * self.namesOfPhotos.count, self.frame.size.height);
    
    // 设置页面控制器的页数.
    self.pageControl.numberOfPages = self.namesOfPhotos.count;
    
    // 设置label的文本显示.
    self.label.text = [[[NSString alloc]initWithFormat:@"当前正在显示 %ld/%ld", (NSUInteger)(self.contentOffset.x / self.frame.size.width), self.namesOfPhotos.count] autorelease];
}

- (void)setDelegate:(id<UIScrollViewDelegate>)delegate
{
    [super setDelegate: delegate];
    
    [self.photoViews enumerateObjectsUsingBlock:^(CFPhotoView * obj, NSUInteger idx, BOOL *stop) {
        obj.delegate = self.delegate;
    }];
}

- (CFPhotoView *) dequeueReusablePhotoView
{

    if (nil == self.photoViews) {
        self.photoViews = [[[NSMutableArray alloc] initWithCapacity: 42] autorelease];
    }
    
    __block CFPhotoView * result = nil;
    
    [self.photoViews enumerateObjectsUsingBlock:^(CFPhotoView * obj, NSUInteger idx, BOOL *stop) {
        CGFloat a = obj.frame.origin.x;
        CGFloat b = self.contentOffset.x - self.frame.size.width;
        CGFloat c = self.contentOffset.x + self.frame.size.width;
        if (obj.frame.origin.x < self.contentOffset.x - self.frame.size.width ||
            obj.frame.origin.x > self.contentOffset.x + self.frame.size.width) {
            result = obj;
            * stop = YES;
        }
    }];

    if (nil == result) {
        CGRect rect = [UIScreen mainScreen].bounds;
        result = [[[CFPhotoView alloc] initWithFrame:rect] autorelease];
        [self.photoViews addObject: result];
    }
    
    if (NO == [self.subviews containsObject: result]) {
        [self addSubview: result];
        [self sendSubviewToBack: result];
    }
    // !!!:临时添加输出对象地址,来判断是否是同一对象
    NSLog(@"%p", result);
    return result;
}
@end
