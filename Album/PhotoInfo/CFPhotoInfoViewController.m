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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(didBackBarButtonItemAction:)];
    // ???:无效.
//    id  a = self.navigationController;
    CGRect rect = self.view.frame;
    rect.origin.y = 64;
    self.view.frame = rect;
    
    NSLog(@"frame: %@", NSStringFromCGRect(self.view.frame));
    NSLog(@"bounds: %@", NSStringFromCGRect(self.view.bounds));

}

//???:待删除.
- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"frame: %@", NSStringFromCGRect(self.view.frame));
    NSLog(@"bounds: %@", NSStringFromCGRect(self.view.bounds));

//    if ((nil != self.navigationController) && (NO == [self.navigationController isNavigationBarHidden])) { // 导航栏存在且未隐藏,视图整体下移64(导航栏高度).
//        CGRect rect = self.view.frame;
//        rect.origin.y = 64;
//        self.view.frame = rect;
//    }
//    NSLog(@"frame: %@", NSStringFromCGRect(self.view.frame));
//    NSLog(@"bounds: %@", NSStringFromCGRect(self.view.bounds));
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
