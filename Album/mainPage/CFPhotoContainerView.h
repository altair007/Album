//
//  CFPhotoContainerView.h
//  Album
//
//  Created by   颜风 on 14-6-15.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CFPhotoView;

/**
 *  用于放置和显示多张图片.
 */
@interface CFPhotoContainerView : UIScrollView
@property (retain, nonatomic) NSArray * namesOfPhotos; //!< 存储图片名字的数组.
@property (retain, nonatomic, readonly) NSMutableArray * photoViews; //!< 存储相片视图的数组.

/**
 *  返回一个可复用的CFPhotoView对象.
 *
 *  @return 可复用的CFPhotoView对象.
 */
- (CFPhotoView *) dequeueReusablePhotoView;

@end
