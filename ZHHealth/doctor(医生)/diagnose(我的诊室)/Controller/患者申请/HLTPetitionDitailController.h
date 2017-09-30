//
//  HLTPetitionDitailController.h
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/21.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLTPatient.h"

@interface HLTPetitionDitailController : UIViewController

@property (nonatomic, strong) HLTPatient *patientModel;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *bgView2;

/*患者头像*/
@property (nonatomic, strong) UIImageView *avatarImage;
/*患者姓名*/
@property (nonatomic, strong) UILabel *nameLabel;
//性别
@property (nonatomic, strong) UILabel *genderLabel;
//患者年龄
@property (nonatomic, strong) UILabel *ageLabel;
//患者地址
@property (nonatomic, strong) UILabel *addressLabel;


@end
