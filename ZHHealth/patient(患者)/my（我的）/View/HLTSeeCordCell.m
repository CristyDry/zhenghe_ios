//
//  HLTSeeCordCell.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/29.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "HLTSeeCordCell.h"

@implementation HLTSeeCordCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat width = 74;
        _textlabel = [[UILabel alloc]initWithFrame:CGRectMake(kBorder, 0, width, self.height_wcr)];
        _textlabel.font = [UIFont systemFontOfSize:KFont - 4];
        _textlabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_textlabel];
        
        CGFloat xPoint = _textlabel.maxX_wcr + 10;
        width = kMainWidth - kBorder  - xPoint;
        _rightTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(xPoint, 0, width, self.height_wcr)];
        _rightTextLabel.font = [UIFont systemFontOfSize:KFont - 4];
        //        _rightTextLabel.backgroundColor = [UIColor clearColor];
        _rightTextLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_rightTextLabel];
    }
    return self;
}

-(void)setTextString:(NSString *)textString {
    _textlabel.text = textString;
    if ([textString isEqualToString:@"病历标题"]) {
        _rightTextLabel.text = _cordModel.mhTitle;
    }else if ([textString isEqualToString:@"姓名"]) {
        _rightTextLabel.text = _cordModel.mhName;
    }else if ([textString isEqualToString:@"性别"]) {
        _rightTextLabel.text = _cordModel.gender;
    }else if ([textString isEqualToString:@"出生日期"]) {
        _rightTextLabel.text = _cordModel.birthday2;
    }else if ([textString isEqualToString:@"科室"]) {
        _rightTextLabel.text = _cordModel.departmentsName;
    }else if ([textString isEqualToString:@"就诊时间"]) {
        _rightTextLabel.text = _cordModel.seeadoctorDate2;
    }
}

- (void)setCordModel:(HLTMRecordModel *)cordModel{
    
//    NSDate *date = [Tools dateFromString:cordModel.birthday];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    [dateFormatter setDateFormat: @"yyyy年MM月dd日"];
//    NSString *destDate= [dateFormatter stringFromDate:date];
    
    if ([_textlabel.text isEqualToString:@"病历标题"]) {
        _rightTextLabel.text = cordModel.mhTitle;
    }else if ([_textlabel.text isEqualToString:@"姓名"]) {
        _rightTextLabel.text = cordModel.mhName;
    }else if ([_textlabel.text isEqualToString:@"性别"]) {
        _rightTextLabel.text = cordModel.gender;
    }else if ([_textlabel.text isEqualToString:@"出生日期"]) {
        _rightTextLabel.text = cordModel.birthday2;
    }else if ([_textlabel.text isEqualToString:@"科室"]) {
        _rightTextLabel.text = cordModel.departmentsName;
    }else if ([_textlabel.text isEqualToString:@"就诊时间"]) {
        _rightTextLabel.text = cordModel.seeadoctorDate2;
    }
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
