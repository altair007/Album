//
//  CFAlbumViewController.h
//  Album
//
//  Created by   颜风 on 14-6-14.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFAlbumView.h"
#import "CFAlbumViewDataSource.h"
#import "CFAlbumViewDelegate.h"

/**
 *  相册视图控制器
 */
@interface CFAlbumViewController : UIViewController <UIScrollViewDelegate, CFAlbumViewDataSource, CFAlbumViewDelegate>
@property (retain, nonatomic) CFAlbumView * view; //!< 相册

/**
 *  获取指定位置上图片的名称.
 *
 *  @param index 图片在相册中的位置.
 *
 *  @return 图片名称.
 */
- (NSString *) photoNameAtIndex: (NSUInteger) index;

@end