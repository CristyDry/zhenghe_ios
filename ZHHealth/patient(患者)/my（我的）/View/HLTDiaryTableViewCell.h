//
//  HLTDiaryTableViewCell.h
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/12.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLTLiveDiary.h"

@interface HLTDiaryTableViewCell : UITableViewCell

@property (nonatomic, strong) HLTLiveDiary *liveDiary;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *imageview;

@property (nonatomic, strong) UILabel *contentLabel;


@end
