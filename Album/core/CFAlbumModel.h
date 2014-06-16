//
//  CFAlbumModel.h
//  Album
//
//  Created by   颜风 on 14-6-14.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CFAlbumModel;

// 初始化数据成功和失败时分别执行的block别名.
// 初始化数据成功或者失败时,均会将自身作为参数传入.
typedef void (^CFAlbumModelInitSuccessBlock) (CFAlbumModel *);
typedef void (^CFAlbumModelInitFailBlock) (NSError *);

/**
 *  相册模型类
 */
@interface CFAlbumModel : NSObject
@property (retain, nonatomic) NSMutableArray * namesOfPhotos; //!< 相册中所有照片的名字.

/**
 *  便利初始化.
 *
 *  @param successBlock 初始化数据成功时执行的block.
 *  @param failBlock    初始化数据失败时执行的block.
 *
 *  @return 初始化后的对象.
 */
- (instancetype) initWithSuccessBlock: (CFAlbumModelInitSuccessBlock)successBlock
                            failBlock: (CFAlbumModelInitFailBlock) failBlock;

/**
 *  初始化数据.
 *
 *  @param successBlock 初始化数据成功后执行的block.
 *  @param failBlock    初始化数据失败后执行的block.
 */
- (void) setupDataWithSuccessBlock: (CFAlbumModelInitSuccessBlock) successBlock
                         failBlock: (CFAlbumModelInitFailBlock) failBlock;

@end
