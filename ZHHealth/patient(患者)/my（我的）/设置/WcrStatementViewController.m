//
//  WcrStatementViewController.m
//  ZHMedical
//
//  Created by U1KJ on 15/11/16.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "WcrStatementViewController.h"

@interface WcrStatementViewController ()
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSString *urlString;

@end

@implementation WcrStatementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addLeftBackItem];
    
    [self setNavigationBarProperty];
    
    self.title = @"免责声明";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addWebview];
    
}

#pragma mark - 添加webview
-(void)addWebview
{
     __weak typeof(self) weakSelf = self;
    [httpUtil doPostRequest:@"api/ZhengheDoctor/disclaimer" args:nil targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            
            weakSelf.urlString = responseMd.response;
            _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kMainWidth, kMainHeight-64)];
//            _webView.backgroundColor = [UIColor purpleColor];
            NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:weakSelf.urlString]];//@"https://www.baidu.com"
            
            [_webView loadRequest:request];
            [self.view addSubview:_webView];
        }
    }];
   
}

@end
