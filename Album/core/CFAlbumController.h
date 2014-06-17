//
//  CFAlbumController.h
//  Album
//
//  Created by   颜风 on 14-6-14.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CFAlbumViewController;
@class CFAlbumModel;
@class CFPhotoInfoViewController;

/**
 *  相册主控制器.
 */
@interface CFAlbumController : NSObject
@property (retain, nonatomic) CFAlbumViewController * albumVC; //!<相册视图控制器.
@property (retain, nonatomic) CFAlbumModel * albumModel; //!< 相册数据模型.
@property (retain, nonatomic) CFPhotoInfoViewController * photoInfoVC; //!< 照片详情页面.

/**
 *  获取单例对象.
 *
 *  @return 单例对象.
 */
+ (CFAlbumController *) sharedInstance;

/**
 *  获取所有图片的名字.
 *
 *  @return 数据源中所有图片的名字.
 */
- (NSArray *) namesOfPhotos;

/**
 *  转向相册主页面.
 */
- (void) swithToAlbumView;

/**
 *  转向图片详情页.
 *
 *  @param index 图片位置.
 */
- (void) swithToPhotoInfoViewAtIndex: (NSUInteger) index;

@end
