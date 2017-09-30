//
//  HLTYijianViewController.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/15.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "HLTYijianViewController.h"
#import "HLTLabel.h"

@interface HLTYijianViewController ()

@end

@implementation HLTYijianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加左边返回按钮
    [self addLeftBackItem];
    //中间标题
    [self addTitleView];
}

#pragma mark - 中间标题
- (void)addTitleView{
    
    HLTLabel * titleLabel = [[HLTLabel alloc] init];
    [titleLabel useLabel:@"意见反馈"];
    self.navigationItem.titleView = titleLabel;
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
