//
//  CFMyAlbumView.h
//  Album
//
//  Created by   颜风 on 14-5-31.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CFMyAlbumPageView; //!< 相册页.

/**
 *  相册协议
 */
@protocol CFMyAlbumViewDelegate <UIScrollViewDelegate>
@required
- (void) handlePageControlAction: (UIPageControl *) pageControl;

@end

/**
 *  相册代理的别名
 */
typedef id<CFMyAlbumViewDelegate> AlbumDelegate;

/**
 *  相册类
 */
@interface CFMyAlbumView : UIScrollView

#pragma mark -属性
@property (retain, nonatomic) NSArray * dataSource; //!< 数据源,存储图片对象的数组.
@property (retain, nonatomic, readonly) UILabel * info; //!< 信息提示
@property (assign, nonatomic) AlbumDelegate delegate; //!< 符合相册协议的代理
@property (retain, nonatomic, readonly) CFMyAlbumPageView * leftPage; //!< 左页
@property (retain, nonatomic, readonly) CFMyAlbumPageView * middlePage; //!< 中页
@property (retain, nonatomic, readonly) CFMyAlbumPageView * rightPage; //!< 右页

#pragma mark - 便利初始化
- (instancetype) initWithFrame: (CGRect) frame
                      delegate: (AlbumDelegate) delegate
                    dataSource: (NSArray *) dataSource;
#pragma mark - 实例方法
/**
 *  设置相册左上角的提示信息
 *
 *  @param aStr 一个字符串
 */
- (void) setInfoOfAlbum: (NSString *) aStr;

/**
 *  设置左侧相册页的照片
 *
 *  @param aImg 照片
 */
- (void) setImageOfLeftPage: (UIImage *) aImg;

/**
 *  设置中间相册页的照片
 *
 *  @param aImg 照片
 */
- (void) setImageOfMiddlePage: (UIImage *) aImg;

/**
 *  设置右侧相册页的照片
 *
 *  @param aImag 照片
 */
- (void) setImageOfRightPage: (UIImage *) aImag;
@end
