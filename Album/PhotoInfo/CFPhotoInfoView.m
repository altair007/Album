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
        self.image = img;
    } fail:NULL];
}

@end
