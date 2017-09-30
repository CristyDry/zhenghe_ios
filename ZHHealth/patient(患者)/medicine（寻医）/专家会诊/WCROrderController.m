//
//  WCROrderController.m
//  ZHHealth
//
//  Created by U1KJ on 15/11/18.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "WCROrderController.h"

@interface WCROrderController ()

@end

@implementation WCROrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addLeftBackItem];
    
    [self setNavigationBarProperty];
    
    self.title = @"预约说明";
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kMainWidth, kMainHeight)];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    [self.view addSubview: webView];
    [webView loadRequest:request];
}


@end
