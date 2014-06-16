//
//  CFPhotoView.h
//  Album
//
//  Created by   颜风 on 14-6-14.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef id<UIScrollViewDelegate> CFPhotoViewCellDelegate;
/**
 *  照片视图,用于展示单张照片
 */
@interface CFPhotoViewCell : UIScrollView
@property (copy ,nonatomic) NSString * nameOfPhoto; //!< 相片名称.
@property (retain, nonatomic, readonly) UIImageView * imageView; //!< 用于放置图片.

/**
 *  设置子视图.
 */
- (void) setupSubviews;

/**
 *  为复用做准备.
 *
 *  @param frame 边框值.
 */
- (void) prepareForReuseWithFrame: (CGRect) frame;

@end
