//
//  CFAlbumView.h
//  Album
//
//  Created by   颜风 on 14-5-30.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFAlbumViewDataSource.h"
#import "CFAlbumViewDelegate.h"
#import "CFAlbumViewDataSource.h"

// ???:应该是可以通过内容模式,boud等,取消内层UIScrollView的需要.
@class CFPhotoViewCell;
@class CFPhotoContainerView;

/**
 *  相册类视图
 */
@interface CFAlbumView : UIView

#pragma mark -属性
@property (assign, nonatomic) id<CFAlbumViewDelegate>  delegate; //!< 相册代理.
@property (assign, nonatomic) id<CFAlbumViewDataSource> dataSource; //!< 数据源代理.
@property (retain, nonatomic, readonly) UIPageControl * pageControl; //!< 页面控制
@property (retain, nonatomic, readonly) UILabel * infoLabel; //!< 信息提示
@property (retain ,nonatomic, readonly) CFPhotoContainerView * photoCV; //!< 照片容器视图.
@property (retain, nonatomic, readonly) NSMutableDictionary * photoCells; //!< 存储已经存在的照片视图,以位置为键,视图对象为值.
@property (assign, nonatomic, readonly) NSRange rangeForVisiblePhotoCells; //!< 可见的照片视图的范围,以在照片在相册中的相对位置为单位进行度量.
/**
 *  设置子视图.
 */
- (void) setupSubviews;

/**
 *  返回一个用于放置在相册指定位置的可复用的CFPhotoView对象.
 *
 *  @param index 此照片视图将要用在相册的此位置.
 *
 *  @return 可复用的CFPhotoView对象.
 */
- (CFPhotoViewCell *) dequeueReusablePhotoViewAtIndex: (NSUInteger) index;

/**
 *  获取indexesForVisiblePhotoViews属性的最新值.
 *  
 *  在每次滑动相册时,indexesForVisiblePhotoViews可能都会发生变化.你可以向实例对象发送此消息来获取indexesForVisiblePhotoViews属性的最新值.
 */
- (NSRange) latestRangeForVisiblePhotoViews;

/**
 *  使相册某个位置上的照片可见.
 *
 *  @param index 相册中照片的位置.
 */
- (void) showPhotoViewAtIndex: (NSUInteger) index;

/**
 *  获取最新的所有应当被用户看到的图片的位置
 *
 *  每次滑动相册时,应当被用户看到的图片都有可能发生变化.你可以向实例对象发送此消息来获取所有应当被用户看到的图片的位置最新值.
 *
 *  @return 所有应当被用户看到的图片的位置
 */
- (NSArray *) latestIndexesForVisiblePhotoViews;

/**
 *  获取相册中照片总数.
 *
 *  @return 相册中照片总数.
 */
- (NSUInteger) numberOfPhotos;

/**
 *  响应选中照片事件.
 *
 *  @param gesture 轻击手势.
 */
- (void) DidSelectPhotoAction: (UITapGestureRecognizer *) gesture;

@end
