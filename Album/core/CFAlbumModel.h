//
//  CFAlbumModel.h
//  Album
//
//  Created by   颜风 on 14-6-14.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  相册模型类
 */
@interface CFAlbumModel : NSObject

/**
 *  获取所有图片的名称
 *
 *  @return 所有图片的名称组成的数组.
 */
- (NSArray *) namesOfPhotos;

@end
