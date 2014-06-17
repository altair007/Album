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

@end
