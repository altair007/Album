//
//  CFPhotoView.h
//  Album
//
//  Created by   颜风 on 14-6-14.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  照片视图,用于展示单张照片
 */
@interface CFPhotoView : UIScrollView
@property (copy ,nonatomic) NSString * nameOfPhoto; //!< 相片名称.
@property (retain, nonatomic, readonly) UIImageView * imageView; //!< 用于放置图片.

- (void) setupSubviews;
@end
