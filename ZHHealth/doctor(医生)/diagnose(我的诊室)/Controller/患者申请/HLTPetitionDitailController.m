//
//  HLTPetitionDitailController.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/21.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "HLTPetitionDitailController.h"

@interface HLTPetitionDitailController ()

@end

@implementation HLTPetitionDitailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"患者详情";
    self.view.backgroundColor = kBackgroundColor;
    [self addLeftBackItem];
    [self setNavigationBarProperty];
    [self addCustomUI];
    
}

-(void)addCustomUI
{
    CGFloat xPoint = 10.0;
    CGFloat yPoint = 10.0;
    CGFloat height = 100.0;
    CGFloat width = 80.0;
    
    //背景
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, KTopLayoutGuideHeight +10, kMainWidth, height)];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.userInteractionEnabled = YES;
    [self.view addSubview:_bgView];
    
    
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
    
    
    //背景
    _bgView2 = [[UIView alloc] initWithFrame:CGRectMake(0, _bgView.maxY_wcr +10, kMainWidth, 150)];
    _bgView2.backgroundColor = [UIColor whiteColor];
    _bgView2.userInteractionEnabled = YES;
    [self.view addSubview:_bgView2];
    
    xPoint = 20.0;
    width = 50.0;
    height = 30.0;
    //性别
    UILabel * gender1 = [[UILabel alloc] initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    [self createLabel:_bgView2 andLabel:gender1 andNsstring:@"性别"];
    _genderLabel = [[UILabel alloc] initWithFrame:CGRectMake(gender1.maxX_wcr, yPoint, kMainWidth-xPoint*3-width, height)];
    [self createLabel:_bgView2 andLabel:_genderLabel andNsstring:_patientModel.gender];
    
    //年龄
    UILabel * age1 = [[UILabel alloc] initWithFrame:CGRectMake(xPoint, gender1.maxY_wcr+2*yPoint, width, height)];
    [self createLabel:_bgView2 andLabel:age1 andNsstring:@"年龄"];
    _ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(age1.maxX_wcr, _genderLabel.maxY_wcr+2*yPoint, kMainWidth-xPoint*3-width, height)];
    [self createLabel:_bgView2 andLabel:_ageLabel andNsstring:_patientModel.age];
    
    
    //地区
    UILabel * address1 = [[UILabel alloc] initWithFrame:CGRectMake(xPoint, age1.maxY_wcr+2*yPoint, width, height)];
    [self createLabel:_bgView2 andLabel:address1 andNsstring:@"地区"];
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(address1.maxX_wcr, _ageLabel.maxY_wcr+2*yPoint, kMainWidth-xPoint*3-width, height)];
    [self createLabel:_bgView2 andLabel:_addressLabel andNsstring:_patientModel.address];
    
    
    
}


#pragma mark - 创建性别等label
-(void)createLabel:(UIView *)view andLabel:(UILabel *)label andNsstring:(NSString *)labelString
{
    label.text = labelString;
    label.font = [UIFont systemFontOfSize:18];
    label.textAlignment = NSTextAlignmentRight;
    [view addSubview:label];
    
    UIImageView * lineImageview = [[UIImageView alloc] initWithFrame:CGRectMake(0,label.maxY_wcr+9, kMainWidth, 1)];
    lineImageview.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:lineImageview];
}

#pragma mark - 添加属性label
-(void)addlabel:(UIView *)view andNSString:(NSString *)labelString andFrame:(UIView *)labelView
{
    
    CGFloat width = AUTO_MATE_WIDTH(150);
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(kMainWidth -width-10.0, labelView.maxY_wcr+2*10.0, width, 30)];
    label.text = labelString;
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    UIImageView * lineImageview = [[UIImageView alloc] initWithFrame:CGRectMake(0,label.maxY_wcr+10, kMainWidth, 1)];
    lineImageview.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:lineImageview];
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
