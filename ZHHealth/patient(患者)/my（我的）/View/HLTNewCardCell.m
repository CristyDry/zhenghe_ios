//
//  HLTNewCardCell.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/29.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "HLTNewCardCell.h"

@implementation HLTNewCardCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat width = 64.0f;
        _textlabel = [[UILabel alloc]initWithFrame:CGRectMake(kBorder, 0, width, self.height_wcr)];
        _textlabel.font = [UIFont systemFontOfSize:KFont - 4];
        _textlabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_textlabel];
        
        CGFloat xPoint = _textlabel.maxX_wcr + 10;
        width = kMainWidth - kBorder  - xPoint;
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(xPoint, 0, width, self.height_wcr)];
        _textField.userInteractionEnabled = NO;
        _textField.font = [UIFont systemFontOfSize:KFont - 4];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_textField];
        
    }
    return self;
}

-(void)setTextString:(NSString *)textString {
    _textlabel.text = textString;
    if ([textString isEqualToString:@"病历标题"]) {
        _textField.placeholder = @"建议以疾病名称命名";
        _textField.userInteractionEnabled = YES;
    }else if ([textString isEqualToString:@"姓名"]) {
        _textField.text = _cordModel.mhName;
        _textField.userInteractionEnabled = YES;
    }else if ([textString isEqualToString:@"性别"]) {
        _textField.text = _account.gender;
    }else if ([textString isEqualToString:@"出生日期"]) {
        _textField.text = _account.birthday;
    }else if ([textString isEqualToString:@"科室"]) {
        _textField.placeholder = @"选择科室";
    }else if ([textString isEqualToString:@"就诊时间"]) {
        _textField.placeholder = @"选择时间";
    }else if ([textString isEqualToString:@"日期"]){
        _textField.placeholder = @"选择时间";
    }else if ([textString isEqualToString:@"事件"]){
        _textField.placeholder = @"选择事件";
    }
}

- (void)setAccount:(LoginResponseAccount *)account{
    _account = account ;
    if ([_textlabel.text isEqualToString:@"名字"]) {
        _textField.text = _account.patientName;
    }else if ([_textlabel.text isEqualToString:@"性别"]) {
        _textField.text = _account.gender;
    }else if ([_textlabel.text isEqualToString:@"出生日期"]) {
        _textField.text = _account.birthday;
    }else if ([_textlabel.text isEqualToString:@"所在地区"]) {
        if (_account.cityName.length == 0) {
            _textField.text = [NSString stringWithFormat:@"%@",_account.provinceName];
        }else if (_account.districtName.length == 0){
            _textField.text = [NSString stringWithFormat:@"%@%@",_account.provinceName,_account.cityName];
        }else{
            _textField.text = [NSString stringWithFormat:@"%@%@%@",_account.provinceName,_account.cityName,_account.districtName];
        }
        
    }
}

-(void)setCordModel:(HLTMRecordModel *)cordModel
{
//    NSDate *date = [Tools dateFromString:cordModel.birthday];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    [dateFormatter setDateFormat: @"yyyy年MM月dd日"];
//    NSString *destDate= [dateFormatter stringFromDate:date];
    
    if ([_textlabel.text isEqualToString:@"病历标题"]) {
        _textField.text = cordModel.mhTitle;
    }else if ([_textlabel.text isEqualToString:@"姓名"]) {
        _textField.text = cordModel.mhName;
    }else if ([_textlabel.text isEqualToString:@"性别"]) {
        _textField.text = cordModel.gender;
    }else if ([_textlabel.text isEqualToString:@"出生日期"]) {
        _textField.text = cordModel.birthday2;
    }else if ([_textlabel.text isEqualToString:@"科室"]) {
        _textField.text = cordModel.departmentsName;
    }else if ([_textlabel.text isEqualToString:@"就诊时间"]) {
        _textField.text = cordModel.seeadoctorDate2;
    }
}


-(void)setCdlistModel:(cdList *)cdlistModel
{
    if ([_textlabel.text isEqualToString:@"日期"]){
        _textField.text = cdlistModel.cdDate2;
    }else if ([_textlabel.text isEqualToString:@"事件"]){
        _textField.text = cdlistModel.incident;
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
