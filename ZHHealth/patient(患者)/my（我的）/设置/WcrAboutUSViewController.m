//
//  WcrAboutUSViewController.m
//  ZHMedical
//
//  Created by U1KJ on 15/11/16.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "WcrAboutUSViewController.h"

@interface WcrAboutUSViewController ()

@end

@implementation WcrAboutUSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 关于我们
    self.title = @"关于我们";
    
    [self addLeftBackItem];
    
    [self setNavigationBarProperty];
    
    [self customAboutUSUI];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)customAboutUSUI {
    
    CGFloat width = 80.0f;
    CGFloat height = width;
    CGFloat xPoint = (kMainWidth - width) / 2.0;
    CGFloat yPoint = 30.0f + KTopLayoutGuideHeight;
    CGRect frame = CGRectMake(xPoint, yPoint, width, height);
    
    // icon
    UIImageView *iconIV = [[UIImageView alloc]initWithFrame:frame];
    [iconIV imageViewWithImageName:@"患者默认头像" andModeScaleAspectFill:YES andCorner:5.0f];
    [self.view addSubview:iconIV];
    
    frame.origin.x = 0.0;
    frame.origin.y = iconIV.maxY_wcr + 10;
    frame.size.width = kMainWidth;
    frame.size.height = 30.0f;
    UILabel *versionLabel = [[UILabel alloc]initWithFrame:frame];
    // 获取应用程序的版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 版本号
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [versionLabel labelWithText:[NSString stringWithFormat:@"正合 %@",version] andTextColor:kBlackColor andFontSize:KFont - 2 andBackgroundColor:nil];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:versionLabel];
    
    frame.origin.y = kMainHeight - 100.0;
    UILabel *contactUsLabel = [[UILabel alloc]initWithFrame:frame];
    [contactUsLabel labelWithText:@"联系我们" andTextColor:kBlackColor andFontSize:KFont - 5 andBackgroundColor:nil];
    contactUsLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:contactUsLabel];
    
    
    frame.origin.y = contactUsLabel.maxY_wcr;
    UILabel *emailLabel = [[UILabel alloc]initWithFrame:frame];
    [emailLabel labelWithText:@"邮箱：cs@zhenghe.com" andTextColor:kBlackColor andFontSize:KFont - 5 andBackgroundColor:nil];
    emailLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:emailLabel];
    
    frame.origin.y = emailLabel.maxY_wcr;
    UILabel *companyLabel = [[UILabel alloc]initWithFrame:frame];
    [companyLabel labelWithText:@"Copyright佛山市正和医疗器械有限公司" andTextColor:kBlackColor andFontSize:KFont - 5 andBackgroundColor:nil];
    companyLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:companyLabel];
    
}


@end
