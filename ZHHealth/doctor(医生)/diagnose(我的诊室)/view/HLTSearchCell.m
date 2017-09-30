//
//  HLTSearchCell.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/22.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "HLTSearchCell.h"

@implementation HLTSearchCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self CreateCell];
    }
    
    return self;
}


-(void)CreateCell
{
    
    CGFloat xPoint = 20.0;
    CGFloat yPoint = 20.0;
    CGFloat width = 60.0;
    CGFloat height = 100.0;
    
    _avatarImage = [[UIImageView alloc] initWithFrame:CGRectMake(xPoint, yPoint, width, width)];
    _avatarImage.layer.cornerRadius = width*0.5;
    _avatarImage.clipsToBounds = YES;
    [self.contentView addSubview:_avatarImage];
    
    
    _patientNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImage.maxX_wcr+xPoint, (height-xPoint)*0.5, width*2, xPoint)];
    [self.contentView addSubview:_patientNameLabel];
    
    
    _genderLabel = [[UILabel alloc] initWithFrame:CGRectMake(_patientNameLabel.maxX_wcr, (height-xPoint)*0.5, xPoint, xPoint)];
    [self.contentView addSubview:_genderLabel];
    
    
    _ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(_genderLabel.maxX_wcr+xPoint, (height-xPoint)*0.5, kMainWidth - _genderLabel.maxX_wcr - xPoint*4, xPoint)];
    [self.contentView addSubview:_ageLabel];
    
}

-(void)setSearchModel:(huanzhe *)searchModel
{
    [_avatarImage sd_setImageWithURL:[NSURL URLWithString:searchModel.avatar] placeholderImage:[UIImage imageNamed:@"ic_error"]];
    _patientNameLabel.text = searchModel.patient;
    if (searchModel.age.length>0) {
        _ageLabel.text = [NSString stringWithFormat:@"%@岁",searchModel.age];
    }
    if (!searchModel.gender.length>0) {
       _genderLabel.text = searchModel.gender;
    }
    
    
    
}

-(void)setHuanzheModel:(huanzhe *)huanzheModel
{
    [_avatarImage sd_setImageWithURL:[NSURL URLWithString:huanzheModel.avatar] placeholderImage:[UIImage imageNamed:@"ic_error"]];
    
    _patientNameLabel.text = huanzheModel.patient;
    if (huanzheModel.age.length>0) {
        _ageLabel.text = [NSString stringWithFormat:@"%@岁",huanzheModel.age];
    }
    if (huanzheModel.gender.length>0) {
        _genderLabel.text = huanzheModel.gender;
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
