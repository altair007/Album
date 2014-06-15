//
//  CFAlbumView.h
//  Album
//
//  Created by   颜风 on 14-5-30.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFAlbumViewDataSource.h"
@class CFPhotoView;
@class CFPhotoContainerView;

/**
 *  相册类视图
 */
@interface CFAlbumView : UIView

#pragma mark -属性
// ???:代理的数据类型,最好使用别名,以便于更改代码.
@property (assign, nonatomic) id<UIScrollViewDelegate> delegate; //!< 相册代理.
@property (retain, nonatomic) NSArray * namesOfPhotos; //!< 数据源,存储图片名字的数组
@property (retain, nonatomic, readonly) UIPageControl * pageControl; //!< 页面控制
@property (retain, nonatomic, readonly) UILabel * label; //!< 信息提示
@property (retain ,nonatomic, readonly) CFPhotoContainerView * photoCV; //!< 照片容器视图.
@property (retain, nonatomic, readonly) NSMutableDictionary * photoViews; //!< 存储可见的照片视图,以位置为键,视图对象为值.
// ???:最后统一更新下各个类的dealloc.
@property (assign, nonatomic, readonly) NSRange rangeForVisiblePhotoViews; //!< 可见的照片视图的范围,以在照片在相册中的相对位置为单位进行度量.
/**
 *  设置子视图.
 */
- (void) setupSubviews;

/**
 *  返回一个可复用的CFPhotoView对象.
 *
 *  @return 可复用的CFPhotoView对象.
 */
- (CFPhotoView *) dequeueReusablePhotoViewAtIndex: (NSUInteger) index;

/**
 *  获取indexesForVisiblePhotoViews属性的最新值.
 *  
 *  在每次滑动相册时,indexesForVisiblePhotoViews可能都会发生变化.你可以向实例对象发送此消息来获取indexesForVisiblePhotoViews属性的最新值.
 */
- (NSRange) latestRangeForVisiblePhotoViews;

@end
