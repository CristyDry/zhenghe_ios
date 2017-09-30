//
//  HLTMRecordCell.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/29.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "HLTMRecordCell.h"

@implementation HLTMRecordCell



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self Createcell];
    }
    return self;
}

-(void)Createcell
{
    CGFloat xPoint = AUTO_MATE_WIDTH(10);
    CGFloat yPoint = AUTO_MATE_HEIGHT(10);
    CGFloat width = kMainWidth-xPoint*2;
    CGFloat height = AUTO_MATE_HEIGHT(110);
    
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(xPoint, 0, width, height)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 5;
    bgView.clipsToBounds = YES;
    bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    bgView.layer.borderWidth = 1;
    [self.contentView addSubview:bgView];
    
    
    width = AUTO_MATE_WIDTH(60);
    height = AUTO_MATE_HEIGHT(50);
    _imageview = [[UIImageView alloc] initWithFrame:CGRectMake(kMainWidth-width-xPoint*3, yPoint+5, width, height)];
    [bgView addSubview:_imageview];
    
    width = kMainWidth-xPoint*4-width;
    height = AUTO_MATE_HEIGHT(20);
    _mhTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    _mhTitleLabel.font = [UIFont systemFontOfSize:18];
    _mhTitleLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:_mhTitleLabel];
    
    CGFloat height1 = AUTO_MATE_HEIGHT(5);
    _mhNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPoint, _mhTitleLabel.maxY_wcr , width, height)];
    _mhNameLabel.textAlignment = NSTextAlignmentLeft;
    _mhNameLabel.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:_mhNameLabel];
    
    
    _DescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPoint, _mhNameLabel.maxY_wcr , width, height)];
    _DescriptionLabel.textColor = [UIColor lightGrayColor];
    _DescriptionLabel.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:_DescriptionLabel];
    
    
    UIImageView * imageview = [[UIImageView alloc] initWithFrame:CGRectMake(xPoint, _DescriptionLabel.maxY_wcr +height1, kMainWidth-xPoint*4, 1)];
    imageview.backgroundColor = [UIColor lightGrayColor];
    [bgView addSubview:imageview];
    
    _createDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPoint, imageview.maxY_wcr+5 , width, height)];
    _createDateLabel.textColor = [UIColor lightGrayColor];
    _createDateLabel.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:_createDateLabel];
}

-(void)setCordModel:(HLTMRecordModel *)cordModel
{
    if (cordModel.image.count >0) {
      [_imageview sd_setImageWithURL:[NSURL URLWithString:cordModel.image[0]] placeholderImage:[UIImage imageNamed:@"ic_error"]];
    }
    _mhTitleLabel.text = cordModel.mhTitle;
   
    _mhNameLabel.text = [NSString stringWithFormat:@"%@  %@  %@ 岁",cordModel.mhName,cordModel.gender,cordModel.standby1];
    _DescriptionLabel.text = cordModel.Description;
    _createDateLabel.text = [NSString stringWithFormat:@"%@ 创建",cordModel.createDate];
    
}





- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
