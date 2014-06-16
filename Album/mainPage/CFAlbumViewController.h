//
//  CFAlbumViewController.h
//  Album
//
//  Created by   颜风 on 14-6-14.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFAlbumView.h"

// ???:从下往上,优化轻扫代码.
// ???: 核心要求之一:不让视图持有除可视控件和代理之外的任何数据或者属性!
/**
 *  相册视图控制器
 */
@interface CFAlbumViewController : UIViewController <UIScrollViewDelegate, CFAlbumViewDataSource>
@property (retain, nonatomic) CFAlbumView * view; //!< 相册

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


@end