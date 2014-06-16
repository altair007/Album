//
//  CFAlbumModel.m
//  Album
//
//  Created by   颜风 on 14-6-14.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import "CFAlbumModel.h"

@implementation CFAlbumModel
- (NSArray *) namesOfPhotos
{
    // FIXME:暂时先用假数据.
    // ???: 应该存在某种方式,可以获取本地相册中所有图片的地址.
    NSArray * photos = @[@"the_secret_1.jpg", @"the_secret_2.jpg", @"the_secret_3.jpg", @"the_secret_4.jpg", @"the_secret_5.jpg",@"the_secret_6.jpg",@"the_secret_7.jpg", @"the_secret_8.jpg", @"the_secret_9.jpg", @"the_secret_10.jpg"];
    
    return photos;
}
@end
