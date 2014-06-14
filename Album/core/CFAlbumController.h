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

/**
 *  相册主控制器.
 */
@interface CFAlbumController : NSObject
@property (retain, nonatomic) CFAlbumViewController * albumVC; //!<相册视图控制器.
@property (retain, nonatomic) CFAlbumModel * albumModel; //!< 相册数据模型.

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

@end
