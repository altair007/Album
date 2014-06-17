//
//  CFPhotoView.m
//  Album
//
//  Created by   颜风 on 14-6-14.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import "CFPhotoViewCell.h"
#import "UIImage+AssetUrl.h"

@interface CFPhotoViewCell ()
@property (retain, nonatomic, readwrite) UIImageView * imageView; //!< 用于放置图片.
@end
@implementation CFPhotoViewCell
-(void)dealloc
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
        [self setupSubviews];
    }
    
    return self;
}

- (void)setupSubviews
{
    // 设置最大和最小缩放比
    self.minimumZoomScale = 0.5;
    self.maximumZoomScale = 3.0;
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    self.imageView = imageView;
    [imageView release];
    [self addSubview:self.imageView];
}

- (void) setNameOfPhoto:(NSString *)nameOfPhoto
{
    // 设置属性.
    NSString * name = [nameOfPhoto copy];
    [_nameOfPhoto release];
    _nameOfPhoto = name;

    // 设置相片
    [UIImage imageForAssetUrl:nameOfPhoto success:^(UIImage * img) {
        self.imageView.image = img;
    } fail:NULL];
}


-(void)setFrame:(CGRect)frame
{
    [super setFrame: frame];
    
    /* 其他设置 */
    self.imageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

- (void) prepareForReuseWithFrame: (CGRect) frame;
{
    // ???:为什么重新设置之后,不再支持缩放了?缩放后无法复原!
    self.frame = frame;
}


@end
