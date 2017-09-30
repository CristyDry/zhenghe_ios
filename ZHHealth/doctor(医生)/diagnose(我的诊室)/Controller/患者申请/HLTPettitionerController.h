//
//  HLTPettitionerController.h
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/21.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLTPatient.h"

@interface HLTPettitionerController : UIViewController

@property (nonatomic, strong) HLTPatient *patientModel;


/*患者头像*/
@property (nonatomic, strong) UIImageView *avatarImage;
/*患者姓名*/
@property (nonatomic, strong) UILabel *nameLabel;
/*患者内容*/
@property (nonatomic, strong) UILabel *verifyContentLabel;
/*专家是否同意*/
@property (nonatomic, strong) UILabel *statuLabel;
//背景
@property (nonatomic, strong) UIView *bgView;
//忽略按钮
@property (nonatomic, strong) UIButton *ignoreButton;
//同意按钮
@property (nonatomic, strong) UIButton *agreeButton;

@end
