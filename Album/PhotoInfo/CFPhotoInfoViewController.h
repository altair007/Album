//
//  CFPhotoViewController.h
//  Album
//
//  Created by   颜风 on 14-6-4.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFPhotoInfoView.h"

@interface CFPhotoInfoViewController : UIViewController
@property (assign, nonatomic) NSUInteger index; //!< 相片位置.
@property (retain, nonatomic) CFPhotoInfoView * view; //!< 父类的view属性.
@end
