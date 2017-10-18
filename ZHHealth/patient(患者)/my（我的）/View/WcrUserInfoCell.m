//
//  WcrUserInfoCell.m
//  ZHMedical
//
//  Created by U1KJ on 15/11/11.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "WcrUserInfoCell.h"

@interface WcrUserInfoCell ()

@end

@implementation WcrUserInfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat width = 90.0f;
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kBorder, 0, width, self.height_wcr)];
        _titleLabel.font = [UIFont systemFontOfSize:KFont - 4];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_titleLabel];
        
        CGFloat xPoint = _titleLabel.maxX_wcr + 10;
        width = kMainWidth - kBorder - 20 - xPoint;
        _detailTF = [[UITextField alloc]initWithFrame:CGRectMake(xPoint, 0, width, self.height_wcr)];
        _detailTF.userInteractionEnabled = NO;
        _detailTF.font = [UIFont systemFontOfSize:KFont - 4];
        _detailTF.backgroundColor = [UIColor clearColor];
        _detailTF.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_detailTF];
        
        width = 10.0f;
        CGFloat height = 15.0f;
        xPoint = kMainWidth - kBorder - width;
        CGFloat yPoint = (self.contentView.height_wcr - height) / 2.0;
        UIImageView *arrowIV = [[UIImageView alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
        arrowIV.backgroundColor = [UIColor clearColor];
        arrowIV.image = [UIImage imageFileNamed:@"后退-拷贝" andType:YES];
        [self.contentView addSubview:arrowIV];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(kBorder, self.height_wcr - 1, kMainWidth - kBorder, 1)];
        line.backgroundColor = KLineColor;
        [self.contentView addSubview:line];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

-(void)setTitleString:(NSString *)titleString {
    _titleString = titleString;
    _titleLabel.text = titleString;
    if ([titleString isEqualToString:@"名字"]) {
        _detailTF.placeholder = @"请输入昵称";
    }else if ([titleString isEqualToString:@"性别"]) {
        _detailTF.placeholder = @"请选择性别";
        _detailTF.text = _account.gender;
    }else if ([titleString isEqualToString:@"出生日期"]) {
        _detailTF.placeholder = @"请选择出生日期";
        _detailTF.text = _account.birthday;
    }else if ([titleString isEqualToString:@"所在地区"]) {
        _detailTF.placeholder = @"请选择地区";
        _detailTF.text = _account.cityName;
    }
}

- (void)setAccount:(LoginResponseAccount *)account{
    _account = account;
    if ([_titleLabel.text isEqualToString:@"名字"]) {
        _detailTF.text = account.patientName;
    }else if ([_titleLabel.text isEqualToString:@"性别"]) {
        _detailTF.text = _account.gender;
    }else if ([_titleLabel.text isEqualToString:@"出生日期"]) {
        _detailTF.text = _account.birthday;
    }else if ([_titleLabel.text isEqualToString:@"所在地区"]) {
        if (_account.cityName.length == 0) {
                _detailTF.text = [NSString stringWithFormat:@"%@",_account.provinceName];
        }else if (_account.districtName.length == 0){
               _detailTF.text = [NSString stringWithFormat:@"%@%@",_account.provinceName,_account.cityName];
        }else{
              _detailTF.text = [NSString stringWithFormat:@"%@%@%@",_account.provinceName,_account.cityName,_account.districtName];
        }

    }
}

@end
