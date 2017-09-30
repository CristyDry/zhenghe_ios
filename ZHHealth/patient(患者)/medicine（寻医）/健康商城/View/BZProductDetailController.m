//
//  BZProductDetailController.m
//  ZHHealth
//
//  Created by pbz on 15/12/7.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZProductDetailController.h"
#define mainWidth  [UIScreen mainScreen].bounds.size.width
#define mainHeight [UIScreen mainScreen].bounds.size.height
@interface BZProductDetailController ()

@end

@implementation BZProductDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航栏
    [self navigation];

    
}
// 设置导航栏
- (void)navigation{
    [self addLeftBackItem];
    // 药品说明书
    UIWebView *instructionView = [[UIWebView alloc] init];
    instructionView.frame = self.view.frame;
    self.navigationItem.title = @"药品详情";
    UIButton *rightBarButton = [[UIButton alloc] initWithFrame:CGRectMake(mainWidth - 70, 0, 64, 64)];
    [rightBarButton setBackgroundImage:[UIImage imageNamed:@"iconfont-add@3x"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
}


@end
