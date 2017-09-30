//
//  HLTCdlistCell.h
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/31.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLTMRecordModel.h"

@interface HLTCdlistCell : UITableViewCell

@property (nonatomic, strong) cdList *cdlistModel;


//@property (nonatomic, copy) UILabel *cdDateLabel;//病历时间

@property (nonatomic, copy) UILabel *updateDateLabel;//更新时间

@property (nonatomic, copy) UILabel *incidentLabel;//项目

@property (nonatomic, copy) UILabel *remarkLabel;//备注

@property (nonatomic, strong) UIImageView *image;

@property (nonatomic, strong) UIScrollView *scrollview;

@property (nonatomic, strong) UIView * bgView ;
//@property (nonatomic, copy) UILabel *createDateLabel;//病程时间



@end
