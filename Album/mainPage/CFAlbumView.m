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
@property (retain, nonatomic, readwrite) UILabel * label; //!< 信息提示
@property (retain ,nonatomic, readwrite) CFPhotoContainerView * photoCV; //!< 照片容器视图.
@property (retain, nonatomic, readwrite) NSMutableDictionary * photoViews; //!< 存储已经存在的照片视图,以位置为键,视图对象为值.

@end

@implementation CFAlbumView
- (void)dealloc
{
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

- (void)setDelegate:(CFAlbumViewDelegate) delegate
{
    // 设置代理
    [delegate retain];
    [_delegate release];
    _delegate = delegate;
    
    
    /* 额外的操作 */
    
    self.photoCV.delegate = self.delegate;
    
    // 通过代理获取相册图片总数
    NSUInteger numberOfPhotos = [self.delegate numberOfPhotosInAlbumView:self];
    
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
    
    result.frame = CGRectMake(index * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    
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

- (NSRange) latestRangeForVisiblePhotoViews
{
    // !!!:迭代到这里@
    // ???:在这里初始化,真的有意义吗?要不直接null?
    NSRange range = NSMakeRange(0, 1);
    
    
    // !!!:实现轮转的思路.
    // !!!:下面两种情况,真的可以通过self.photoCV.contentOffset.x显现,应该是通过boudce值吧?可以的!
    // !!!考虑往左过度偏移的情况
    if (self.photoCV.contentOffset.x < 0) {
        NSLog(@"x: %f,",self.photoCV.contentOffset.x);
        // ???:逻辑错误,直接返回(0,1)不具有通用性!
        return range;
    }
    
    // !!!:向右过度偏移的情况
    if (self.photoCV.contentOffset.x > self.photoCV.contentSize.width) {
        NSLog(@"x: %f,",self.photoCV.contentOffset.x);
    }
    
    // ???:此处应该通过代理动态获取图片宽度.
    CGFloat widthOfImg = self.photoCV.frame.size.width;
    
    // 计算最左侧显示的图片是第几张图片.
    CGFloat leftOriginal = self.photoCV.contentOffset.x / widthOfImg;
    NSUInteger leftIndex = floor(leftOriginal);
    
    // 计算最右侧显示的是第几张图片.
    CGFloat rightOriginal = (self.photoCV.contentOffset.x + self.photoCV.frame.size.width) / widthOfImg;
    
    // !!!:当self.photoCV.contentOffset.x + self.photoCV.frame.size.width > self.photoCV.contentSize.width即拖动到图片末尾时,此时会多计算一个图片.此处暂时作为BUG进行修复,但结合取余操作,这里应该会成为一个实现"轮转"的捷径!
    if (self.photoCV.contentOffset.x + self.photoCV.frame.size.width > self.photoCV.contentSize.width) {
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
    CFPhotoViewCell * photoView = [self.delegate albumView:self photoAtIndex: index];
    
    if (nil == photoView) { // 代理无法正确给出指定位置上应有的照片视图,直接返回.
        return;
    }
    
    // ???:需要考虑,此键已经存在的情况吗?
    // ???:下面的,封装一下更好吧.
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
}

- (NSArray *) latestIndexesForVisiblePhotoViews
{
    // ???:逻辑有点乱,冗余.
    NSMutableArray * indexes = [[NSMutableArray alloc] initWithCapacity:42];
    NSRange range = [self latestRangeForVisiblePhotoViews];
    for (NSUInteger i = range.location, j = 0; j < range.length; j ++) {
        [indexes addObject:[NSNumber numberWithInteger:(i + j)]];
    }
    
    // ???:[nil count]值是零?
    // ???:indexes长度为0时,直接返回nil?
    
    return indexes;
}
@end
