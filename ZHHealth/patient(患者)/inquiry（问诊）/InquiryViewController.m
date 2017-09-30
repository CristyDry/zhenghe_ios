//
//  InquiryViewController.m
//  ZHMedical
//
//  Created by U1KJ on 15/11/10.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "InquiryViewController.h"
#import "DVSwitch.h"
#import "BZMyDoctorViewController.h"
#import "BZMyMessageViewController.h"
#import "BZDoctorModel.h"
#import "MMSChatViewController.h"

@interface InquiryViewController ()

@property (nonatomic, weak) DVSwitch  *dvSwitch;


@end

@implementation InquiryViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    // 判断是否已登录
    if ([LoginResponseAccount isLogin]) {
        // 已经登录
        [self setupDVSwitch];
    }else{
        // 未登录，跳转到登录界面
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

-(void)setupDVSwitch{
    // 设置DVSwitch
    DVSwitch *dvSwitch = [[DVSwitch alloc]initWithStringsArray:@[@"医生",@"消息"]];
    _dvSwitch = dvSwitch;
    dvSwitch.frame = CGRectMake(0, 0, kMainWidth * 0.4, 30);
    dvSwitch.backgroundColor = [UIColor colorWithHexString:@"#05b7c3"];
    dvSwitch.font = [UIFont systemFontOfSize:17];
    dvSwitch.labelTextColorInsideSlider = [UIColor colorWithHexString:@"#05b7c3"];
    dvSwitch.layer.cornerRadius = 15;
    dvSwitch.layer.borderWidth = 1;
    dvSwitch.layer.borderColor = [UIColor whiteColor].CGColor;
    self.navigationItem.titleView = dvSwitch;
    
    // 子控制器
    // 我的医生
    BZMyDoctorViewController *myDoctorViewController = [[BZMyDoctorViewController alloc] init];
    [self addChildViewController:myDoctorViewController];
    // 消息
    MMSChatViewController *myMessageViewController = [[MMSChatViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:myMessageViewController];
    [self addChildViewController:nvc];
    
    //     切换控制器
    [_dvSwitch setPressedHandler:^(NSUInteger index){
        self.selectedIndex = index;
    }];
}


@end

