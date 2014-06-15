//
//  CFPhotoContainerView.m
//  Album
//
//  Created by   颜风 on 14-6-15.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import "CFPhotoContainerView.h"
#import "CFPhotoView.h"

@interface CFPhotoContainerView ()
@property (retain, nonatomic, readwrite) NSMutableArray * photoViews; //!< 存储相片视图的数组.
@end

@implementation CFPhotoContainerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // 设置分页效果
        self.pagingEnabled = YES;
        
        // 不允许同时进行水平和竖直方向上的滚动.
        self.directionalLockEnabled = YES;
    }
    return self;
}

- (void)setNamesOfPhotos:(NSArray *)namesOfPhotos
{
    // 设置属性
    [namesOfPhotos retain];
    [_namesOfPhotos release];
    _namesOfPhotos = namesOfPhotos;
    
    // 设置内容偏移量
    self.contentSize = CGSizeMake(self.frame.size.width * self.namesOfPhotos.count, self.frame.size.height);
}

- (CFPhotoView *) dequeueReusablePhotoView
{
    if (nil == self.photoViews) {
        self.photoViews = [[[NSMutableArray alloc] initWithCapacity: 42] autorelease];
    }
    
    __block CFPhotoView * result = nil;
    
    [self.photoViews enumerateObjectsUsingBlock:^(CFPhotoView * obj, NSUInteger idx, BOOL *stop) {
        if (obj.frame.origin.x < self.contentOffset.x - self.frame.size.width ||
            obj.frame.origin.x > self.contentOffset.x + self.frame.size.width) {
            result = obj;
            * stop = YES;
        }
    }];
    
    if (nil == result) {
        CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        result = [[[CFPhotoView alloc] initWithFrame: rect] autorelease];
        [self.photoViews addObject: result];
    }
    
    if (NO == [self.subviews containsObject: result]) {
        [self addSubview: result];
    }
    // !!!:临时添加输出对象地址,来判断是否是同一对象
    NSLog(@"%p", result);
    
    return result;
}

- (void)setDelegate:(id<UIScrollViewDelegate>)delegate
{
    // ???:下面这一句,可能会循环调用.
    [super setDelegate: delegate];
    
    [self.photoViews enumerateObjectsUsingBlock:^(CFPhotoView * obj, NSUInteger idx, BOOL *stop) {
        obj.delegate = self.delegate;
    }];
}

@end
