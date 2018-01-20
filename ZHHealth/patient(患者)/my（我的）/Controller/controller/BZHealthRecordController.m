//
//  BZHealthRecordController.m
//  ZHHealth
//
//  Created by pbz on 15/12/16.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZHealthRecordController.h"
#import "BZBloodPressureController.h"
#import "BZWeightController.h"
#import "BZHeartRateController.h"
#import "LoginResponseAccount.h"
#import "BZBooldPressureModel.h"
#import "BZHeartRateModel.h"
#import "BZWeightModel.h"
#import "LoginViewController.h"
@interface BZHealthRecordController ()
@property (nonatomic,strong)  NSArray *booldPressureModelA;
@property (nonatomic,strong)  NSArray *heartRateModelA;
@property (nonatomic,strong)  NSArray *weightModelA;
@end

@implementation BZHealthRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addLeftBackItem];
    self.navigationItem.title = @"健康记录";
    self.view.backgroundColor = kBackgroundColor;

    [self setBtn];
}

- (void)setBtn{
    CGFloat pointX = kMainWidth * 0.1;
    CGFloat height = kMainWidth * 0.2;
    CGFloat width = kMainWidth - pointX * 2;
    CGFloat marginY = pointX * 0.5;
    // 血压
    UIButton *bloodPressureBtn = [[UIButton alloc] initWithFrame:CGRectMake(pointX, kMainWidth * 0.5, width, height)];
    bloodPressureBtn.backgroundColor = [UIColor colorWithRGB:235 G:119 B:151];
    [bloodPressureBtn addTarget:self action:@selector(bloodPressure) forControlEvents:UIControlEventTouchUpInside];
    [bloodPressureBtn setImage:[UIImage imageNamed:@"血压"] forState:UIControlStateNormal];
    [bloodPressureBtn setTitle:@"血压" forState:UIControlStateNormal];
    bloodPressureBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    bloodPressureBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -20);
    [self.view addSubview:bloodPressureBtn];
    // 心率
    UIButton *heartRateBtn = [[UIButton alloc] initWithFrame:CGRectMake(pointX, CGRectGetMaxY(bloodPressureBtn.frame) + marginY, width, height)];
    heartRateBtn.backgroundColor = [UIColor colorWithRGB:88 G:168 B:260];
    [heartRateBtn addTarget:self action:@selector(heartRate) forControlEvents:UIControlEventTouchUpInside];
    [heartRateBtn setImage:[UIImage imageNamed:@"心率"] forState:UIControlStateNormal];
    [heartRateBtn setTitle:@"心率" forState:UIControlStateNormal];
    heartRateBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    heartRateBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -20);
    [self.view addSubview:heartRateBtn];
    // 体重指数
    UIButton *weightBtn = [[UIButton alloc] initWithFrame:CGRectMake(pointX, CGRectGetMaxY(heartRateBtn.frame) + marginY, width, height)];
    weightBtn.backgroundColor = [UIColor colorWithRGB:250 G:191 B:85];
    [weightBtn addTarget:self action:@selector(weight) forControlEvents:UIControlEventTouchUpInside];
    [weightBtn setImage:[UIImage imageNamed:@"体重"] forState:UIControlStateNormal];
    [weightBtn setTitle:@"体重指数" forState:UIControlStateNormal];
    weightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    weightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -20);
    [self.view addSubview:weightBtn];
    
}
// 血压
- (void)bloodPressure{
    BZBloodPressureController *bloodPressureVC = [[BZBloodPressureController alloc] init];
    [self jumpVC:bloodPressureVC];
}
// 心率
- (void)heartRate{
    BZHeartRateController *heartRateVC = [[BZHeartRateController alloc] init];
    [self jumpVC:heartRateVC];
}
// 体重指数
- (void)weight{
    BZWeightController *weightVC = [[BZWeightController alloc] init];
    [self jumpVC:weightVC];
}

// 跳转控制器
- (void)jumpVC:(UIViewController *)VC{
    // 判断是否已登录
    if ([LoginResponseAccount isLogin]) {
        // 已经登录
        [self.navigationController pushViewController:VC animated:YES];
    }else{
        // 未登录，跳转到登录界面
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

@end
