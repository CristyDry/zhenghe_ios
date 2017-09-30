//
//  HLTNewDiaryViewController.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/12.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "HLTNewDiaryViewController.h"

@interface HLTNewDiaryViewController ()

@property (nonatomic, strong) UIButton * leftBtn ;
@property (nonatomic, strong) UIButton * rightBtn;

@end

@implementation HLTNewDiaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //修改导航栏的属性
    [self addNavigatinbar];
    self.view.backgroundColor = kBackgroundColor;
}

-(void)addNavigatinbar
{
    UIButton * leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    [leftButton setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    //取消按钮
    _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, kMainWidth/2, 70)];
    [_leftBtn setBackgroundColor:[UIColor whiteColor]];
    [_leftBtn addTarget:self action:@selector(leftButton) forControlEvents:UIControlEventTouchUpInside];
    UILabel * leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kMainWidth/2, 70)];
    leftLabel.text = @"取消";
    leftLabel.font = [UIFont systemFontOfSize:22];
    leftLabel.textAlignment = NSTextAlignmentLeft;
    [_leftBtn addSubview:leftLabel];
    [self.navigationController.navigationBar addSubview:_leftBtn];
    
    //保存按钮
    _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainWidth/2, 10, kMainWidth/2, 70)];
    [_rightBtn setBackgroundColor:[UIColor whiteColor]];
    [_rightBtn addTarget:self action:@selector(rightButton) forControlEvents:UIControlEventTouchUpInside];
    UILabel * rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kMainWidth/2-20, 70)];
    rightLabel.text = @"保存";
    rightLabel.font = [UIFont systemFontOfSize:22];
    rightLabel.textAlignment = NSTextAlignmentRight;
    [_rightBtn addSubview:rightLabel];
    [self.navigationController.navigationBar addSubview:_rightBtn];
    
    
}

//取消按钮点击事件
-(void)leftButton
{
    [self.navigationController popViewControllerAnimated:NO];
}

//保存按钮点击事件
-(void)rightButton
{
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    _leftBtn.hidden = YES;
    _rightBtn.hidden = YES;
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
