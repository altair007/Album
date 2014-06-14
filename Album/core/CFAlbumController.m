//
//  CFAlbumController.m
//  Album
//
//  Created by   颜风 on 14-6-14.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import "CFAlbumController.h"
#import "CFAlbumModel.h"

@implementation CFAlbumController
static CFAlbumController * sharedObj = nil; //!< 单例对象.

+ (CFAlbumController *)sharedInstance
{
    if (nil == sharedObj) {
        sharedObj = [[self alloc] init];
    }
    
    return sharedObj;
}

+ (instancetype) allocWithZone:(struct _NSZone *)zone
{
    if (nil == sharedObj) {
        sharedObj = [super allocWithZone: zone];
    }
    
    return sharedObj;
}

- (instancetype) copyWithZone: (NSZone *) zone
{
    return self;
}

- (NSUInteger)retainCount
{
    return UINT_MAX;
}

- (oneway void)release
{
    
}

- (instancetype)autorelease
{
    return self;
}

- (void)dealloc
{
    self.albumVC = nil;
    self.albumModel = nil;
    
    [super dealloc];
}

- (NSArray *) namesOfPhotos
{
    return self.albumModel.namesOfPhotos;
}
@end
