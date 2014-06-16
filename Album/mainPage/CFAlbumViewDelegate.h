//
//  CFAlbumViewDelegate.h
//  Album
//
//  Created by   颜风 on 14-6-15.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CFAlbumView;

// !!!:猜想:可以简单通过修改UITableView的boundc值来实现相册.
@protocol CFAlbumViewDelegate <UIScrollViewDelegate>
@optional

- (CGFloat) widthForPhotoInAlbumView: (CFAlbumView *) albumView;

@end
