//
//  HLTGroupViewController.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/14.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "HLTGroupViewController.h"
#import "HLTNewGroupViewController.h"

@interface HLTGroupViewController ()

@end

@implementation HLTGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分组管理";
    [self addLeftBackItem];
    [self setNavigationBarProperty];
    [self addRightButton];
    
}

#pragma mark - 右边新建按钮
-(void)addRightButton
{
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    [rightBtn setTintColor:[UIColor whiteColor]];
    [rightBtn setTitle:@"新建" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(createNew) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
 
}

#pragma mark - 新建按钮点击事件
-(void)createNew
{
    HLTNewGroupViewController * newGroup = [[HLTNewGroupViewController alloc] init];
    [self.navigationController pushViewController:newGroup animated:NO];
    
}

#pragma mark - 请求患者数据
-(void)requestPetitionerdata
{
    
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
