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
// ???:可以直接使用两个对象接口.已经验证了结论
@property (retain, nonatomic, readonly) NSMutableArray * photoViews; //!< 存储相片视图的数组.

//???: 应该设置一个daataSource代理协议.

/**
 *  返回一个可复用的CFPhotoView对象.
 *
 *  @return 可复用的CFPhotoView对象.
 */
- (CFPhotoView *) dequeueReusablePhotoView;

/**
 *  设置相册指定位置上的照片.
 *
 *  @param index 指定的相册位置.
 */
- (void) setPhotoAtIndex: (NSUInteger) index;

/**
 *  获取指定位置上图片的名称.
 *
 *  @param index 图片在相册中的位置.
 *
 *  @return 图片名称.
 */
- (NSString *) photoNameAtIndex: (NSUInteger) index;

/**
 *  返回照片总数.
 *
 *  @return 照片总数.
 */
- (NSUInteger) numberOfPhotos;

/**
 *  获取所有的照片名称.
 *
 *  @return 所有照片的名称.
 */
- (NSArray *) namesOfPhotos;

/**
 *  获取页面上所有可视的照片的位置.
 *
 *  @return 一个数组,存储页面上所有可视的照片的位置.照片位置从0开始计数.
 */
- (NSArray *) indexesOfAllVisiblePhotos;

/**
 *  指定相册位置是否已经有照片.
 *
 *  注意:由于相片视图使用了复用机制,前一时刻某位置有照片,并不能说明现在或未来的某一时刻此位置仍然有照片.你必须在需要判断某位置是否有相册时,重新向对象发送此消息.
 *
 *  @param index 相册中的某个位置.
 *
 *  @return YES,此位置已经存在照片;NO,此位置不存在照片.
 */
- (BOOL)isHasPhotoAtIndex: (NSUInteger) index;

@end
