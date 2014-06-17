//
//  CFPhotoInfoView.m
//  Album
//
//  Created by   颜风 on 14-6-17.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import "CFPhotoInfoView.h"
#import "UIImage+AssetUrl.h"

@implementation CFPhotoInfoView
- (void)dealloc
{
    self.nameOfPhoto = nil;
    self.imageView = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setNameOfPhoto:(NSString *)nameOfPhoto
{
    [UIImage imageForAssetUrl:nameOfPhoto success:^(UIImage * img) {
        if (nil == self.imageView) {
            UIImageView * imageView = [[UIImageView alloc]init];
            self.imageView = imageView;
            [imageView release];
        }
        
        self.imageView.image = img;
        
    } fail:NULL];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame: frame];
    
    [self updateFramesOfComponents];
}

- (void) updateFramesOfComponents
{
    /* 考虑到导航栏的影响,各组件应使用换算后的真实有效高度值 */
    CGFloat realHeight = self.frame.size.height + self.bounds.origin.y;
    
    // ???:为什么详情页面没有图像了?需要一个单独更新内容的方法?
    self.imageView.frame = CGRectMake(0, 0, 100, 100);
}

@end
