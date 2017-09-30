//
//  HLTChatViewController.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/23.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "HLTChatViewController.h"
#import "HLTPDetailController.h"

@interface HLTChatViewController ()

@end

@implementation HLTChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftBackItem];
    [self addRightButton];
    [self setNavigationBarProperty];
    self.view.backgroundColor= kBackgroundColor;
    
}

#pragma mark - 右边患者详情button
-(void)addRightButton
{
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    button.tag = 500;
    [button setImage:[UIImage imageNamed:@"iconfont-yonghutouxiang"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addRightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

-(void)addRightButtonClick
{
    HLTPDetailController * pDetailVC = [[HLTPDetailController alloc] init];
    pDetailVC.huanzheModel = _huanzheModel;
    pDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pDetailVC animated:YES];
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
