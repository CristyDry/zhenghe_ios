//
//  HLTPatientTableViewCell.h
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/14.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLTPatient.h"

@interface HLTPatientTableViewCell : UITableViewCell

@property (nonatomic, strong) HLTPatient *patient;

/*患者id*/
@property (nonatomic, strong) UILabel *idLabel;
/*患者头像*/
@property (nonatomic, strong) UIImageView *avatarImage;
/*患者姓名*/
@property (nonatomic, strong) UILabel *nameLabel;
/*患者内容*/
@property (nonatomic, strong) UILabel *verifyContentLabel;
/*专家是否同意*/
@property (nonatomic, strong) UIButton *statuButton;

@end
