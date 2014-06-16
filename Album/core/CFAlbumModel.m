//
//  CFAlbumModel.m
//  Album
//
//  Created by   颜风 on 14-6-14.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import "CFAlbumModel.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation CFAlbumModel
-(void)dealloc
{
    self.namesOfPhotos = nil;
    
    [super dealloc];
}

- (instancetype) initWithSuccessBlock: (CFAlbumModelInitSuccessBlock)successBlock
                            failBlock: (CFAlbumModelInitFailBlock) failBlock
{
    if (self = [super init]) {
        [self setupDataWithSuccessBlock:successBlock failBlock:failBlock];
    }
    
    return self;
}

- (instancetype)init
{
    if (self = [self initWithSuccessBlock:NULL failBlock:NULL]) {
        
    }
    
    return self;
}

- (void) setupDataWithSuccessBlock: (CFAlbumModelInitSuccessBlock) successBlock
                         failBlock: (CFAlbumModelInitFailBlock) failBlock
{
    if (nil == self.namesOfPhotos) {
        NSMutableArray * temp = [[NSMutableArray alloc] initWithCapacity:42];
        self.namesOfPhotos = temp;
        [temp release];
    }
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]init];
    
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (nil != group) {
            [group enumerateAssetsUsingBlock:^(ALAsset * result, NSUInteger index, BOOL *stop) {
                if (nil != result) {
                    NSString * assetUrl = [[result valueForProperty:ALAssetPropertyAssetURL] description];
                    [self.namesOfPhotos addObject: assetUrl];
                }
            }];
            
            return;
        }
        // group为nil,说明遍历结束.
        if (NULL != successBlock) {
            successBlock(self);
        }
        
    } failureBlock:^(NSError *error) {
        failBlock(error);
    }];
}

// ???:临时删除!
//- (NSMutableArray *) namesOfPhotos
//{
//    // FIXME:暂时先用假数据.
//    // ???: 应该存在某种方式,可以获取本地相册中所有图片的地址.
//    
//    NSArray * temp = @[@"the_secret_1.jpg", @"the_secret_2.jpg", @"the_secret_3.jpg", @"the_secret_4.jpg", @"the_secret_5.jpg",@"the_secret_6.jpg",@"the_secret_7.jpg", @"the_secret_8.jpg", @"the_secret_9.jpg", @"the_secret_10.jpg"];
//
//    NSMutableArray * photos = [NSMutableArray arrayWithArray: temp];
//    
//    return photos;
//}

@end
