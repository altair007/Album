//
//  CFAlbumView.h
//  Album
//
//  Created by   颜风 on 14-5-30.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CFPhotoView;

/**
 *  相册类视图
 */
@interface CFAlbumView : UIScrollView

#pragma mark -属性
@property (retain, nonatomic) NSArray * namesOfPhotos; //!< 数据源,存储图片名字的数组.
@property (retain, nonatomic, readonly) NSMutableArray * photoViews; //!< 存储相片视图的数组.
@property (retain, nonatomic, readonly) UIPageControl * pageControl; //!< 页面控制
@property (retain, nonatomic, readonly) UILabel * label; //!< 信息提示

- (void) setupSubviews;

/**
 *  返回一个可复用的CFPhotoView对象.
 *
 *  @return 可复用的CFPhotoView对象.
 */
- (CFPhotoView *) dequeueReusablePhotoView;

@end
