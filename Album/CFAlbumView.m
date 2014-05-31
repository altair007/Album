//
//  CFAlbumView.m
//  Album
//
//  Created by   颜风 on 14-5-30.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import "CFAlbumView.h"

@implementation CFAlbumView

#pragma mark
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - 便利初始化
- (instancetype) initWithFrame: (CGRect) frame
                      delegate: (AlbumDelegate) delegate
                    dataSource: (NSArray *) dataSource
{
    if (nil == delegate || nil == dataSource) {
        return nil;
    }
    
    if (self = [super initWithFrame:frame]) {
        self.delegate = delegate;
        self.dataSource = dataSource;
    
        // 下面的代码应该被封装
        // 创建并设置相册
        self.scrollView = [[[UIScrollView alloc] initWithFrame:self.frame] autorelease];
        [self addSubview: self.scrollView];
        
        // 设置相册"大小"
        self.scrollView.contentSize = CGSizeMake(self.frame.size.width * self.dataSource.count, self.frame.size.height);
        
        // 设置分页效果
        self.scrollView.pagingEnabled = YES;
        
        // 设置背景色
        self.scrollView.backgroundColor = [UIColor redColor];
        
        // 设置代理
        self.scrollView.delegate = self.delegate;
        
        // 不显示滚动条.
        /*这么做的原因:
         1.显示滚动条不美观
         2.选择显示滚动条,系统会自动为UIScrollView添加两个对应的滚动条子视图;会影响某些依赖于UIScrollView子视图个数的方法的逻辑.
         */
        self.scrollView.showsHorizontalScrollIndicator =NO;
        self.scrollView.showsVerticalScrollIndicator =NO;

        
        
        // 根据数据源中的数据创建相片
        [self.dataSource enumerateObjectsUsingBlock:^(UIImage * img, NSUInteger idx, BOOL *stop) {
            // 单照片相册设置
            UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.frame.size.width * idx, 0, self.frame.size.width, self.frame.size.height)];
            
            // 设置最大和最小缩放比
            scrollView.minimumZoomScale = 0.5;
            scrollView.maximumZoomScale = 3.0;
            
            // 不显示滚动条.
            /*这么做的原因:
             1.显示滚动条不美观
             2.选择显示滚动条,系统会自动为UIScrollView添加两个对应的滚动条子视图;会影响某些依赖于UIScrollView子视图个数的方法的逻辑.
             */
            scrollView.showsHorizontalScrollIndicator =NO;
            scrollView.showsVerticalScrollIndicator =NO;
            
            // 设置背景色
            scrollView.backgroundColor = [UIColor grayColor];
            
            // 设置代理
            scrollView.delegate = self.delegate;
            
            [self.scrollView addSubview: scrollView];
            
            // 相框设置
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
            
            // 打开交互
            imageView.userInteractionEnabled = YES;
            
            // 相片
            imageView.image = img;
            
            [scrollView addSubview:imageView];
            
            // 释放临时变量
            [scrollView release];
            [imageView release];
        }];
        
        // 创建支持页面切换的控件.
        self.pageControl = [[[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height * 0.95, self.frame.size.width, self.frame.size.height * 0.05)] autorelease];
        
        // 设置背景颜色
        self.pageControl.backgroundColor = [UIColor grayColor];
        
        // 设置透明度
        self.pageControl.alpha = 0.3;
        
        // 设置分页数量
        self.pageControl.numberOfPages = self.dataSource.count;
        
        // 设置分页指示器颜色
        self.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        
        // 设置何时显示当前页(圆点)
        self.pageControl.defersCurrentPageDisplay = YES;
        
        // 添加响应方法
        [self.pageControl addTarget:self.delegate action:@selector(handlePageControlAction:) forControlEvents: UIControlEventValueChanged];
        
        [self addSubview: self.pageControl];
        
        // 添加lable,显示相册信息.
        self.label = [[[UILabel alloc] initWithFrame:CGRectMake( 0, self.frame.size.height * 0.05, self.frame.size.width * 0.3, self.frame.size.height * 0.05)] autorelease];
        self.label.text = [[[NSString alloc]initWithFormat:@"当前正在显示 %d/%ld", 1, self.dataSource.count] autorelease];
        // 设置文本自适应
        self.label.adjustsFontSizeToFitWidth = YES;
        
        // 设置颜色.
        self.label.textColor = [UIColor grayColor];
        
        [self addSubview: self.label];
    }
    
    return self;
}

#pragma mark -重写方法
- (void)dealloc
{
    self.dataSource = nil;
    self.pageControl = nil;
    self.label = nil;
    self.scrollView = nil;
    
    [super dealloc];
}

@end
