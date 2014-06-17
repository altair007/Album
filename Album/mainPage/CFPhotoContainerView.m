//
//  CFPhotoContainerView.m
//  Album
//
//  Created by   颜风 on 14-6-15.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import "CFPhotoContainerView.h"
#import "CFPhotoViewCell.h"

@interface CFPhotoContainerView ()
@end

@implementation CFPhotoContainerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // 设置分页效果
        self.pagingEnabled = YES;
        
        // 不允许同时进行水平和竖直方向上的滚动.
        self.directionalLockEnabled = YES;
    }
    return self;
}

- (void)setContentSize:(CGSize)contentSize
{
    [super setContentSize: contentSize];
}

@end
