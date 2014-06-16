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
@property (retain, nonatomic, readwrite) NSMutableDictionary * photoViews; //!< 存储已经存在的照片视图,以位置为键,视图对象为值.

@end

@implementation CFAlbumView
- (void)dealloc
{
    self.pageControl = nil;
    self.infoLabel = nil;
    self.photoCV = nil;
    self.photoViews = nil;
    
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
    
    // 当只有一张图片时,隐藏此控件.
    pageC.hidesForSinglePage = YES;
    
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
    self.photoCV.contentSize = CGSizeMake(self.frame.size.width * numberOfPhotos, self.frame.size.height);
    
    // 设置页面控制器的页数.
    self.pageControl.numberOfPages = numberOfPhotos;
}

- (CFPhotoViewCell *) dequeueReusablePhotoViewAtIndex: (NSUInteger) index
{
    __block CFPhotoViewCell * result = [self.photoViews objectForKey: [NSNumber numberWithInteger: index]];
    
    if (nil != result) { // 指定位置上的照片视图已经存在,直接返回这个视图即可.
        return result;
    }
    
    /* 已经存在的照片视图中,有没有闲置的 */
    
    [self.photoViews enumerateKeysAndObjectsUsingBlock:^(NSNumber * key, CFPhotoViewCell * obj, BOOL *stop) {
        if (NO == [[self latestIndexesForVisiblePhotoViews] containsObject: key] ) { // 已经存在的照片视图中有闲置的
            result = obj;
            [self.photoViews removeObjectForKey: key];
            *stop = YES;
        }
    }];

    CGRect rect = CGRectMake(index * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    [result prepareForReuseWithFrame:rect];
//    CGRect rect = result.frame;
//    CGRect rect2 = result.imageView.frame;
    
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
    
    // 考虑一种极端情况:两侧刚好是两张图片的边框,此时计算出的范围会比实际范围多一张图片.
    if (leftIndex == leftOriginal && rightIndex == rightOriginal) {
        range.length --;
    }
    
    return range;
}

- (void) showPhotoViewAtIndex: (NSUInteger) index
{
    /*  设置信息栏和页面控制器. */
    NSString * info = [[NSString alloc] initWithFormat:@"正在显示页数 %lu / %lu", index + 1, [self numberOfPhotos]];
    
    self.infoLabel.text = info;
    [info release];
    
    self.pageControl.currentPage = index;
    [self.pageControl updateCurrentPageDisplay];
    
    /* 显示指定位置的图片 */
    if (nil != [self.photoViews objectForKey: [NSNumber numberWithInteger:index]]) { // 此位置上图片已经显示,则直接返回.
        return;
    }
    
    CFPhotoViewCell * photoView = [self.dataSource albumView:self photoAtIndex: index];
    
    if (nil == photoView) { // 代理无法正确给出指定位置上应有的照片视图,直接返回.
        return;
    }

    // ???:感觉这里,非常不妥.代理的代理,隐式定义代理,非常不妥.
    // 给照片视图设置代理,以支持拖放等操作.
    photoView.delegate = self.delegate;
    
    if (nil == self.photoViews) {
        NSMutableDictionary * photoViews = [[NSMutableDictionary alloc] initWithCapacity: 42];
        self.photoViews = photoViews;
        [photoViews release];
    }
    
    if (NO == [self.photoCV.subviews containsObject: photoView]) { // 添加为相册容器的子视图.
        [self.photoCV addSubview: photoView];
    }
    // !!!:临时添加输出对象地址,来判断是否是同一对象
    NSLog(@"%p", photoView);
    
    [self.photoViews setObject:photoView forKey:[NSNumber numberWithInteger: index]];
    
//    /*  设置信息栏和页面控制器. */
//    NSString * info = [[NSString alloc] initWithFormat:@"正在显示页数 %lu / %lu", index + 1, [self numberOfPhotos]];
//    
//    self.infoLabel.text = info;
//    [info release];
//    
//    self.pageControl.currentPage = index;
//    [self.pageControl updateCurrentPageDisplay];
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
    
    return indexes;
}

- (NSUInteger) numberOfPhotos
{
    NSUInteger number = [self.dataSource numberOfPhotosInAlbumView:self];
    
    return number;
}
@end
