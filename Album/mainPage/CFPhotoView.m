//
//  CFPhotoView.m
//  Album
//
//  Created by   颜风 on 14-6-14.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import "CFPhotoView.h"

// ???:命名为cell是不是更合适?
@interface CFPhotoView ()
@property (retain, nonatomic, readwrite) UIImageView * imageView; //!< 用于放置图片.
@end
@implementation CFPhotoView

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
    // FIXME:临时添加,背景色
    self.backgroundColor = [UIColor redColor];
    
    // 设置最大和最小缩放比
    self.minimumZoomScale = 0.5;
    self.maximumZoomScale = 3.0;
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    imageView.userInteractionEnabled = YES;
    
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
    self.imageView.image = [UIImage imageNamed: nameOfPhoto];
    NSArray * arr = self.subviews;
    UIImage * image = self.imageView.image;
}

- (void)setDelegate:(id<UIScrollViewDelegate>)delegate
{
    [super setDelegate:delegate];
    
    // 添加触摸手势,点击显示详情!
    // ???:这种警告,应该使用什么策略清除
    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.delegate action:@selector(tapGesture:)];
    [self.imageView addGestureRecognizer: recognizer];
}

@end
