//
//  HLTMRecordCell.h
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/29.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLTMRecordModel.h"

@interface HLTMRecordCell : UITableViewCell

@property (nonatomic, strong) HLTMRecordModel *cordModel;

@property (nonatomic, copy) UILabel *mhNameLabel;//患者名

@property (nonatomic, copy) UILabel *mhTitleLabel;//病历标题

@property (nonatomic, copy) UILabel *DescriptionLabel;//描述

@property (nonatomic, copy) UILabel *createDateLabel;//创建日期

@property (nonatomic, strong) UIImageView *imageview;

@end
