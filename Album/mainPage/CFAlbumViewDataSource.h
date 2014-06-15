//
//  CFAlbumViewDataSource.h
//  Album
//
//  Created by   颜风 on 14-6-15.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CFAlbumView;
@class CFPhotoView;

@protocol CFAlbumViewDataSource <NSObject>
@required

/**
 *  返回相册中照片总数.
 *
 *  @param albumView 相册
 *
 *  @return 照片总数
 */
- (NSUInteger) numberOfPhotosInAlbumView: (CFAlbumView *) albumView;

/**
 *  返回相册某一位置的图片视图.
 *
 *  注意:你应该重用图片视图,在创建新的照片视图之前,请先试着通过CFAlbumView对象的dequeueReusablePhotoView方法获取可以被重用的图片视图对象.
 *
 *  @param albumView 相册
 *  @param index     位置
 *
 *  @return 返回相册中指定位置的图片视图.
 */
- (CFPhotoView *) albumView: (CFAlbumView *) albumView
               photoAtIndex: (NSUInteger) index;

@end
