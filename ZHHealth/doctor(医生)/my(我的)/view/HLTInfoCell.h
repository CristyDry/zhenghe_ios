//
//  HLTInfoCell.h
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/17.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLTInfoModel.h"
@interface HLTInfoCell : UITableViewCell

@property (nonatomic, strong) HLTInfoModel *infoModel;

@property (nonatomic, strong) UILabel *IdLabel;//消息id
@property (nonatomic, strong) UILabel *titleLabel;//标题
@property (nonatomic, strong) UILabel *textLabel1;//详情
@property (nonatomic, strong) UILabel *dataLabel;//日期

@end
