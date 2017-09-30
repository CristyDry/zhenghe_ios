//
//  WcrDoctorCell.m
//  ZHMedical
//
//  Created by U1KJ on 15/11/10.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "WcrDoctorCell.h"

@interface WcrDoctorCell ()

@property (nonatomic, strong) UIImageView *iconIV;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *officeLabel;

@property (nonatomic, strong) UILabel *doctorTypeLabel;

@property (nonatomic, strong) UILabel *hopitalLabel;

@end

@implementation WcrDoctorCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat widthOfIconIV = 55.0f;
        CGFloat yPoint = (kWcrDoctorCellHeight - widthOfIconIV) / 2.0;
        _iconIV = [[UIImageView alloc]initWithFrame:CGRectMake(kBorder, yPoint, widthOfIconIV, widthOfIconIV)];
        [_iconIV.layer setCornerRadius:widthOfIconIV / 2.0];
        
        _iconIV.clipsToBounds = YES;
        _iconIV.contentMode = UIViewContentModeScaleAspectFill;
        _iconIV.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_iconIV];
        
        CGFloat widthOfLabel = kMainWidth - _iconIV.maxX_wcr - 10;
        CGFloat heightOfName = 22;
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_iconIV.maxX_wcr + kBorder, _iconIV.y_wcr, widthOfLabel, heightOfName)];
        _nameLabel.font = [UIFont systemFontOfSize:KFont - 4];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = kBlackColor;
        [self.contentView addSubview:_nameLabel];
        
        CGFloat widthOfOffice = 64;
        CGFloat heightOfOffice = 17;
        _officeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.x_wcr, _nameLabel.maxY_wcr, widthOfOffice, heightOfOffice)];
        _officeLabel.font = [UIFont systemFontOfSize:KFont - 6];
        _officeLabel.textColor = kGrayColor;
        _officeLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_officeLabel];
        
        CGFloat xPointOfType = _officeLabel.maxX_wcr + 15;
        _doctorTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(xPointOfType, _officeLabel.y_wcr, kMainWidth - xPointOfType - 10, heightOfOffice)];
        _doctorTypeLabel.font = [UIFont systemFontOfSize:KFont - 6];
        _doctorTypeLabel.textColor = kGrayColor;
        _doctorTypeLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_doctorTypeLabel];
        
        _hopitalLabel = [[UILabel alloc]initWithFrame:CGRectMake(_officeLabel.x_wcr, _officeLabel.maxY_wcr, _nameLabel.width_wcr, heightOfOffice)];
        _hopitalLabel.font = [UIFont systemFontOfSize:KFont - 6];
        _hopitalLabel.textColor = kGrayColor;
        _hopitalLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_hopitalLabel];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(kBorder, kWcrDoctorCellHeight - 1, kMainWidth - kBorder, 1)];
        line.backgroundColor = KLineColor;
        [self.contentView addSubview:line];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

-(void)setDoctorModel:(BZDoctorModel *)doctorModel {
    _doctorModel = doctorModel;
    NSLog(@"_doctorModel%@",_doctorModel);
    [_iconIV sd_setImageWithURL:[NSURL URLWithString:doctorModel.avatar] placeholderImage:[UIImage imageNamed:@"ic_error"]];

    _nameLabel.text = doctorModel.doctor;

    _officeLabel.text = doctorModel.department;
    
    // 计算科室名实际的长度
//    CGFloat widthOfOffice = [Tools calculateLabelWidth:doctor.department font:[UIFont systemFontOfSize:KFont - 6] AndHeight:<#(CGFloat)#>];
    CGFloat widthOfOffice = [Tools widthForString:doctorModel.department font:[UIFont systemFontOfSize:KFont - 6]];
    _doctorTypeLabel.x_wcr = _officeLabel.x_wcr + widthOfOffice + 15;
    _doctorTypeLabel.width_wcr = kMainWidth - _doctorTypeLabel.x_wcr - 10;
    
    _doctorTypeLabel.text = doctorModel.professional;
    
    _hopitalLabel.text = doctorModel.hospital;
    
}

@end
