//
//  HLTSearchCell.h
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/22.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLTDiagnose.h"
#import "HLTSearch.h"
@interface HLTSearchCell : UITableViewCell

@property (nonatomic, strong) HLTSearch *searchModel;
@property (nonatomic, strong) huanzhe *huanzheModel;

//患者姓名
@property (nonatomic, copy) UILabel *patientNameLabel;
//性别
@property (nonatomic, copy) UILabel *genderLabel;
//患者年龄
@property (nonatomic, copy) UILabel *ageLabel;
//患者头像
@property (nonatomic, copy) UIImageView *avatarImage;


@end
