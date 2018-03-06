//
//  HLTPettitionerController.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/21.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "HLTPettitionerController.h"
#import "HLTPetitionDitailController.h"

@interface HLTPettitionerController ()

@end

@implementation HLTPettitionerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户申请";
    self.view.backgroundColor = kBackgroundColor;
    [self addLeftBackItem];
    [self setNavigationBarProperty];
    
    [self addCustomUI];
    [self addButtonUI];
}

#pragma mark - 界面
-(void)addCustomUI
{
    CGFloat xPoint = 10.0;
    CGFloat yPoint = 10.0;
    CGFloat height = 100.0;
    CGFloat width = 80.0;
    
    //背景
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, KTopLayoutGuideHeight +10, kMainWidth, 190)];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.userInteractionEnabled = YES;
    [self.view addSubview:_bgView];
    
    UIButton * button = [[UIButton alloc] initWithFrame:_bgView.frame];
    button.tag = 102;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:button];
    
    //头像
    _avatarImage = [[UIImageView alloc] initWithFrame:CGRectMake(xPoint*2, yPoint, width, width)];
    _avatarImage.layer.cornerRadius = width*0.5;
    _avatarImage.clipsToBounds = YES;
    [_avatarImage sd_setImageWithURL:[NSURL URLWithString:_patientModel.avatar] placeholderImage:[UIImage imageNamed:@"ic_error"]];
    [_bgView addSubview:_avatarImage];
    
    //名字
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImage.maxX_wcr +xPoint*3, (height-30)*0.5, height, 30)];
    _nameLabel.text = _patientModel.name;
    [_bgView addSubview:_nameLabel];
    
    //返回图片
    UIImageView * buttonView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainWidth-30, (height-20)*0.5, 10, 20)];
    buttonView.image = [UIImage imageNamed:@"后退-拷贝"];
    [_bgView addSubview:buttonView];
    
    //线
    UIImageView * lineImageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, _avatarImage.maxY_wcr+yPoint, kMainWidth, 1)];
    lineImageview.backgroundColor = [UIColor lightGrayColor];
    [_bgView addSubview:lineImageview];
    
    UILabel * yanzhengLabel  =[[UILabel alloc] initWithFrame:CGRectMake(xPoint*2, lineImageview.maxY_wcr+yPoint*2, kMainWidth-xPoint*4, 10)];
    yanzhengLabel.text = @"验证消息:";
    yanzhengLabel.textColor = [UIColor grayColor];
    [_bgView addSubview:yanzhengLabel];
    
    _verifyContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPoint*2, yanzhengLabel.maxY_wcr+yPoint*2, kMainWidth-xPoint*4, 25)];
    _verifyContentLabel.text = _patientModel.verifyContent;
    _verifyContentLabel.textColor = [UIColor lightGrayColor];
    _verifyContentLabel.numberOfLines = 2;
    [_bgView addSubview:_verifyContentLabel];
    
    _statuLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPoint *2, _bgView.maxY_wcr+yPoint*2, kMainWidth-xPoint*4, 20)];
    [self.view addSubview:_statuLabel];
}

#pragma mark - 添加button
-(void)addButtonUI
{
    if ([_patientModel.status isEqualToString:@"已同意"])
    {
        _statuLabel.text = @"已经同意申请";
    }
    else
    {
        CGFloat width = AUTO_MATE_WIDTH(100);
        CGFloat height = AUTO_MATE_HEIGHT(30);
        CGFloat jiange = 40.0;
        
        //忽略按钮
        _ignoreButton = [[UIButton alloc] initWithFrame:CGRectMake((kMainWidth-width*2-jiange)*0.5, _bgView.maxY_wcr+30, width, height)];
        _ignoreButton.tag = 100;
        _ignoreButton.layer.cornerRadius = 5;
        _ignoreButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _ignoreButton.layer.borderWidth = 1;
        _ignoreButton.clipsToBounds = YES;
        [_ignoreButton setTitle:@"忽略" forState:UIControlStateNormal];
        [_ignoreButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_ignoreButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_ignoreButton];
        
        //同意按钮
        _agreeButton = [[UIButton alloc] initWithFrame:CGRectMake(_ignoreButton.maxX_wcr+jiange, _bgView.maxY_wcr+30, width, height)];
        _agreeButton.tag = 101;
        _agreeButton.layer.cornerRadius = 5;
        _agreeButton.clipsToBounds = YES;
        [_agreeButton setTitle:@"同意" forState:UIControlStateNormal];
        [_agreeButton setBackgroundImage:[UIImage imageNamed:@"背景-拷贝"] forState:UIControlStateNormal];
        [_agreeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_agreeButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_agreeButton];
    }
}

-(void)buttonClick:(UIButton *)button
{
    if (button.tag == 100) {
        NSLog(@"忽略");
        NSMutableDictionary *args = [NSMutableDictionary dictionary];
        args[@"id"] = _patientModel.ID;
        [httpUtil doPostRequest:@"api/ZhengheDoctor/ignoreApply" args:args targetVC:nil response:^(ResponseModel *responseMd) {
            if (responseMd.isResultOk) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
       [self.navigationController popViewControllerAnimated:YES];
        
    }else if(button.tag == 101){
        NSLog(@"同意");
        
        NSMutableDictionary *args = [NSMutableDictionary dictionary];
        args[@"id"] = _patientModel.ID;
        [httpUtil doPostRequest:@"api/ZhengheDoctor/agreeApply" args:args targetVC:nil response:^(ResponseModel *responseMd) {
            if (responseMd.isResultOk) {
            
                [self isStatus];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }else if (button.tag == 102){
        HLTPetitionDitailController * petientDetail = [[HLTPetitionDitailController alloc] init];
        petientDetail.patientModel = _patientModel;
        [self.navigationController pushViewController:petientDetail animated:YES];
    }
}

-(void)isStatus
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"同意成功";
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:1];
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
