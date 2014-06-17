//
//  CFPhotoViewController.m
//  Album
//
//  Created by   颜风 on 14-6-4.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import "CFPhotoInfoViewController.h"
#import "CFAlbumController.h"
#import "CFPhotoInfoView.h"

@implementation CFPhotoInfoViewController

// ???:有一个BUG:  初次加载详情页视图时,有一定几率出现短暂的空白!
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    CFPhotoInfoView * temp = [[CFPhotoInfoView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.view = temp;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if (nil != self.navigationItem) { // 存在导航栏
        // 不让导航栏遮蔽视图.
        CGRect rect = self.view.bounds;
        rect.origin.y = -64;
        self.view.bounds = rect;
        
        // 自定义返回按钮
        UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(didBackBarButtonItemAction:)];
        self.navigationItem.leftBarButtonItem = backItem;
        [backItem release];
    }
}

- (void) didBackBarButtonItemAction: (id) sender
{
    [[CFAlbumController sharedInstance] swithToAlbumView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && nil == self.view.window) {
        self.view = nil;
    }
    
}

- (void)setIndex:(NSUInteger)index
{
    _index = index;
    
    /* 设置导航栏标题 */
    NSUInteger total = [CFAlbumController sharedInstance].namesOfPhotos.count;
    NSString * title = [[NSString alloc] initWithFormat:@"正在显示 %lu / %lu", index + 1, total];
    
    self.navigationItem.title = title;
    
    /* 设置图片 */
    NSString * nameOfPhoto = [[CFAlbumController sharedInstance].namesOfPhotos objectAtIndex:index];
    
    self.view.nameOfPhoto = nameOfPhoto;
}


@end
