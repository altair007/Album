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
#import "CFPhotoViewCell.h"
#import "CFPhotoContainerView.h"

@interface CFAlbumView ()
@property (retain, nonatomic, readwrite) UIPageControl * pageControl; //!< 页面控制
@property (retain, nonatomic, readwrite) UILabel * infoLabel; //!< 信息提示
@property (retain ,nonatomic, readwrite) CFPhotoContainerView * photoCV; //!< 照片容器视图.
@property (retain, nonatomic, readwrite) NSMutableDictionary * photoCells; //!< 存储已经存在的照片视图,以位置为键,视图对象为值.

@end

@implementation CFAlbumView
- (void)dealloc
{
    self.pageControl = nil;
    self.infoLabel = nil;
    self.photoCV = nil;
    self.photoCells = nil;
    
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
    // 设置背景颜色.
    self.backgroundColor = [UIColor grayColor];
    
    /* 设置相片容器 */
    CFPhotoContainerView * photoCV = [[CFPhotoContainerView alloc] initWithFrame:self.frame];
    self.photoCV = photoCV;
    [photoCV release];
    
    /* 创建支持页面切换的控件. */
    UIPageControl * pageC = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height * 0.95, self.frame.size.width, self.frame.size.height * 0.05)];
    
    // 设置背景颜色
    pageC.backgroundColor = [UIColor grayColor];
    
    // 设置透明度
    pageC.alpha = 0.3;
    
    // 当只有一张图片时,隐藏此控件.
    pageC.hidesForSinglePage = YES;
    
    // 设置分页指示器颜色
    pageC.currentPageIndicatorTintColor = [UIColor blackColor];
    pageC.pageIndicatorTintColor = [UIColor whiteColor];
    
    // 设置何时显示当前页(圆点)
    pageC.defersCurrentPageDisplay = YES;
    
    // 添加响应方法
    [pageC addTarget:(CFAlbumViewController *)self.delegate action:@selector(handlePageControlAction:) forControlEvents: UIControlEventValueChanged];
    
    self.pageControl = pageC;
    [pageC release];
    
    /* 设置用于显示相册信息的label */
    UILabel * label = [[UILabel alloc] init];
    
    label.adjustsFontSizeToFitWidth = YES;
    label.textColor = [UIColor blackColor];
    
    self.infoLabel = label;
    [label release];
}

- (void)setDelegate: (id<CFAlbumViewDelegate>) delegate
{
    // 设置代理
    _delegate = delegate;
    
    /* 额外的操作 */
    // 设置相册容器的代理
    self.photoCV.delegate = self.delegate;
}

- (void)setDataSource:(id<CFAlbumViewDataSource>)dataSource
{
    // 设置数据源代理
    _dataSource = dataSource;
    
    /* 额外的操作 */
    // 通过代理获取相册图片总数
    NSUInteger numberOfPhotos = [self.dataSource numberOfPhotosInAlbumView:self];
    
    // 设置相册容器的内容偏移量
    self.photoCV.contentSize = CGSizeMake(self.frame.size.width * numberOfPhotos, self.photoCV.contentSize.height);
    
    // 设置页面控制器的页数.
    self.pageControl.numberOfPages = numberOfPhotos;
}

- (CFPhotoViewCell *) dequeueReusablePhotoViewAtIndex: (NSUInteger) index
{
    __block CFPhotoViewCell * result = [self.photoCells objectForKey: [NSNumber numberWithInteger: index]];
    
    if (nil != result) { // 指定位置上的照片视图已经存在,直接返回这个视图即可.
        return result;
    }
    
    /* 已经存在的照片视图中,有没有闲置的 */
    
    [self.photoCells enumerateKeysAndObjectsUsingBlock:^(NSNumber * key, CFPhotoViewCell * obj, BOOL *stop) {
        if (NO == [[self latestIndexesForVisiblePhotoViews] containsObject: key] ) { // 已经存在的照片视图中有闲置的
            result = obj;
            [self.photoCells removeObjectForKey: key];
            *stop = YES;
        }
    }];

    CGRect rect = CGRectMake(index * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    result.frame = rect;
    
    return result;
}

-(void)setPhotoCV:(CFPhotoContainerView *)photoCV
{
    [photoCV retain];
    [_photoCV release];
    _photoCV = photoCV;
    
    if (NO == [self.subviews containsObject: _photoCV]) {
        [self addSubview: _photoCV];
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

- (void)setInfoLabel:(UILabel *)label
{
    [label retain];
    [_infoLabel release];
    _infoLabel = label;
    
    if (NO == [self.subviews containsObject: _infoLabel]) {
        [self addSubview: _infoLabel];
    }
}

- (NSRange) latestRangeForVisiblePhotoViews
{
    NSRange range = NSMakeRange(0, 0);
    
    // 获取图片宽度.
    CGFloat widthOfImg = [self.delegate widthForPhotoInAlbumView: self];
    
    // 计算最左侧显示的图片是第几张图片.
    CGFloat leftOriginal = self.photoCV.contentOffset.x / widthOfImg;
    
    if (self.photoCV.contentOffset.x < 0) { // 往左过度偏移.
        leftOriginal = 0.0;
    }
    
    NSUInteger leftIndex = floor(leftOriginal);
    
    // 计算最右侧显示的是第几张图片.
    CGFloat rightOriginal = (self.photoCV.contentOffset.x + self.photoCV.frame.size.width) / widthOfImg;
    
    if (self.photoCV.contentOffset.x + self.photoCV.frame.size.width > self.photoCV.contentSize.width) { // 往右过度偏移.
        rightOriginal = self.photoCV.contentSize.width / widthOfImg;
    }
    
    NSUInteger rightIndex = floor(rightOriginal);
    
    // 设置可见图片的范围
    range.location = leftIndex;
    range.length = rightIndex - leftIndex + 1;
    
    /*
     考虑两种特殊情况:
     1.两侧刚好是图片的边框,此时计算出的范围会比实际范围多一张图片.
     2.向右过度偏移,此时计算出的范围也会比实际范围多一张图片.
     */
    if ((leftIndex == leftOriginal && rightIndex == rightOriginal) ||
        (rightOriginal == self.photoCV.contentSize.width / widthOfImg)) {
        range.length --;
    }
    
    return range;
}

- (void) showPhotoViewAtIndex: (NSUInteger) index
{
    // 让已经存在但不可见的照片单元格恢复缩放前的状态.
    [self.photoCells enumerateKeysAndObjectsUsingBlock:^(NSNumber * key, CFPhotoViewCell * cell, BOOL *stop) {
        __block BOOL visilble = NO;
        
        [self.latestIndexesForVisiblePhotoViews enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stopInner) {
            if ([obj isEqualToNumber: key]) {
                visilble = YES;
                * stopInner = YES;
            }
        }];
        
        if (NO == visilble) {
            cell.zoomScale = 1.0;
        }
        
    }];
    
    /*  设置信息栏和页面控制器. */
    NSString * info = [[NSString alloc] initWithFormat:@"正在显示 %lu / %lu", index + 1, [self numberOfPhotos]];
    
    self.infoLabel.text = info;
    [info release];
    
    self.pageControl.currentPage = index;
    [self.pageControl updateCurrentPageDisplay];
    
    /* 显示指定位置的图片 */
    if (nil != [self.photoCells objectForKey: [NSNumber numberWithInteger:index]]) { // 此位置上图片已经显示,则直接返回.
        return;
    }
    
    CFPhotoViewCell * photoView = [self.dataSource albumView:self photoAtIndex: index];
    
    if (nil == photoView) { // 代理无法正确给出指定位置上应有的照片视图,直接返回.
        return;
    }

    // 给照片视图设置代理,以支持拖放等操作.
    photoView.delegate = self.delegate;
    
    if (nil == self.photoCells) {
        NSMutableDictionary * photoViews = [[NSMutableDictionary alloc] initWithCapacity: 42];
        self.photoCells = photoViews;
        [photoViews release];
    }
    
    if (NO == [self.photoCV.subviews containsObject: photoView]) { // 添加为相册容器的子视图.
        [self.photoCV addSubview: photoView];
    }
    
    
    /* 添加触摸手势,响应选中事件 */
    __block BOOL result = NO; // 用来标记照片视图是否已经添加过触摸手势.
    [photoView.gestureRecognizers enumerateObjectsUsingBlock:^(UIGestureRecognizer * obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass: [UITapGestureRecognizer class]]) {
            result = YES;
            * stop = YES;
        }
    }];
    
    if (YES != result) { // 触摸手势不存在.
        UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DidSelectPhotoAction:)];
        [photoView addGestureRecognizer: recognizer];
    }

    [self.photoCells setObject:photoView forKey:[NSNumber numberWithInteger: index]];
}

- (NSArray *) latestIndexesForVisiblePhotoViews
{
    NSRange range = [self latestRangeForVisiblePhotoViews];
    
    if (0 == range.length) { // 没有图片应当被显示.
        return nil;
    }
    
    NSMutableArray * indexes = [[NSMutableArray alloc] initWithCapacity:range.length];
    for (NSUInteger i = range.location, j = 0; j < range.length; j ++) {
        
        [indexes addObject:[NSNumber numberWithInteger:(i + j)]];
    }
    
    return [indexes autorelease];
}

- (NSUInteger) numberOfPhotos
{
    NSUInteger number = [self.dataSource numberOfPhotosInAlbumView:self];
    
    return number;
}

- (void) DidSelectPhotoAction: (UITapGestureRecognizer *) gesture
{
    /* 获取此图片的位置 */
    CFPhotoViewCell * cell = (CFPhotoViewCell *)gesture.view;
    __block NSUInteger index = 0;
    
    [self.photoCells enumerateKeysAndObjectsUsingBlock:^(NSNumber * key, CFPhotoViewCell * obj, BOOL *stop) {
        if (obj == cell) {
            index = [key integerValue];
            *stop = YES;
        }
    } ];
    
    // 通知代理进行处理
    [self.delegate albumView: self didSelectPhotoAtIndex: index];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    // 更新页面组件边框信息.
    [self updateFramesOfComponents];
}

- (void) updateFramesOfComponents
{
    self.photoCV.frame = self.frame;
    
    /* 考虑到导航栏的影响,各组件应使用换算后的真实有效高度值 */
    CGFloat realHeight = self.frame.size.height + self.bounds.origin.y;
    
    NSUInteger numberOfPhotos = [self.dataSource numberOfPhotosInAlbumView:self];
    self.photoCV.contentSize = CGSizeMake(self.frame.size.width * numberOfPhotos, self.photoCV.contentSize.height);
    
    self.pageControl.frame = CGRectMake(0, realHeight * 0.95, self.frame.size.width, realHeight * 0.05);
    
    self.infoLabel.frame = CGRectMake( 0, 0, self.frame.size.width * 0.3, realHeight * 0.05);
}
@end
