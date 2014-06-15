//
//  CFAlbumView.h
//  Album
//
//  Created by   颜风 on 14-5-30.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CFPhotoView;
@class CFPhotoContainerView;

/**
 *  相册类视图
 */
@interface CFAlbumView : UIView

#pragma mark -属性
// ???:代理的数据类型,最好使用别名,以便于更改代码.
@property (assign, nonatomic) id<UIScrollViewDelegate> delegate; //!< 相册代理.
@property (retain, nonatomic) NSArray * namesOfPhotos; //!< 数据源,存储图片名字的数组.
@property (retain, nonatomic, readonly) NSMutableArray * photoViews; //!< 存储相片视图的数组.
@property (retain, nonatomic, readonly) UIPageControl * pageControl; //!< 页面控制
@property (retain, nonatomic, readonly) UILabel * label; //!< 信息提示
@property (retain, nonatomic, readonly) UIScrollView * albumSV; //!< 相册主视图
@property (retain ,nonatomic, readonly) CFPhotoContainerView * photoCV; //!< 照片容器视图.

- (void) setupSubviews;

/**
 *  返回一个可复用的CFPhotoView对象.
 *
 *  @return 可复用的CFPhotoView对象.
 */
- (CFPhotoView *) dequeueReusablePhotoView;

@end
