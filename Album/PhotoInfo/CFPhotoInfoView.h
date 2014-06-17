//
//  CFPhotoInfoView.h
//  Album
//
//  Created by   颜风 on 14-6-17.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFPhotoInfoView : UIView
@property (copy ,nonatomic) NSString * nameOfPhoto; //!< 相片名称.
@property (retain, nonatomic) UIImageView * imageView; //!< 相片视图.

/**
 *  更新页面组件的边框信息.
 */
- (void) updateFramesOfComponents;

@end
