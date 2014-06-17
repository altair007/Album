//
//  CFAlbumViewDelegate.h
//  Album
//
//  Created by   颜风 on 14-6-15.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CFAlbumView;

@protocol CFAlbumViewDelegate <UIScrollViewDelegate>
@optional

/**
 *  获取相册中图片的宽度.
 *
 *  @param albumView 相册.
 *
 *  @return 图片宽度.
 */
- (CGFloat) widthForPhotoInAlbumView: (CFAlbumView *) albumView;

/**
 *  当选中某张图片时,执行的操作.
 *
 *  @param albumView 相册.
 *  @param index     图片位置.
 */
- (void) albumView:(CFAlbumView *)albumView didSelectPhotoAtIndex: (NSUInteger) index;

@end
