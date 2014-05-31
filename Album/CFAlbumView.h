//
//  CFAlbumView.h
//  Album
//
//  Created by   颜风 on 14-5-30.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  相册协议
 */
@protocol CFAlbumViewDelegate <UIScrollViewDelegate>
@required
- (void) handlePageControlAction: (UIPageControl *) pageControl;

@end

/**
 *  相册代理的别名
 */
typedef id<CFAlbumViewDelegate> AlbumDelegate;

/**
 *  相册类视图
 */
@interface CFAlbumView : UIView

#pragma mark -属性
@property (retain, nonatomic) NSArray * dataSource; //!< 数据源,存储图片对象的数组.
@property (retain, nonatomic) UIPageControl * pageControl; //!< 页面控制
@property (retain, nonatomic) UILabel * label; //!< 信息提示
@property (assign, nonatomic) AlbumDelegate delegate; //!< 符合相册协议的代理
// !!!: 命名为album,很不合适!
@property (retain, nonatomic) UIScrollView * album; //!< 相册

#pragma mark - 便利初始化
- (instancetype) initWithFrame: (CGRect) frame
                      delegate: (AlbumDelegate) delegate
                    dataSource: (NSArray *) dataSource;

@end
