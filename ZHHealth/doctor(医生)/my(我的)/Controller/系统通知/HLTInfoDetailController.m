//
//  HLTInfoDetailController.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/18.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "HLTInfoDetailController.h"


@interface HLTInfoDetailController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation HLTInfoDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addLeftBackItem];
    [self setNavigationBarProperty];
    [self addWebview];
}

#pragma mark - 添加webview
-(void)addWebview
{
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, KTopLayoutGuideHeight, kMainWidth, kMainHeight-KTopLayoutGuideHeight)];
    //_webView.backgroundColor = [UIColor purpleColor];
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:_infoModel.url]];//@"https://www.baidu.com"
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
