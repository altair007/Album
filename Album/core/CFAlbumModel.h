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
@property (retain, nonatomic, readonly) NSMutableArray * namesOfPhotos; //!< 存储所有相片的名称

@end
