//
//  HLTNewCardCell.h
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/29.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLTMRecordModel.h"
@interface HLTNewCardCell : UITableViewCell

@property (nonatomic, strong) LoginResponseAccount *account;
@property (nonatomic, strong) UILabel *textlabel;
@property (nonatomic, strong) NSString *textString;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) HLTMRecordModel *cordModel;
@property (nonatomic, strong) cdList *cdlistModel;


@end
