//
//  HLTInfoCell.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/17.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "HLTInfoCell.h"

@implementation HLTInfoCell

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
    CGFloat xPoint = 10;
    CGFloat yPoint = 10;
    CGFloat width = kMainWidth;
    CGFloat height = 80.0;
    
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 0;
    bgView.clipsToBounds = YES;
    bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    bgView.layer.borderWidth = 0;
    [self.contentView addSubview:bgView];
    
    width = width;//-xPoint*2;
    height = 20.0;
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    _titleLabel.font = [UIFont systemFontOfSize:18];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:_titleLabel];
    
    _dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPoint, _titleLabel.maxY_wcr +10, width, height)];
    _dataLabel.textAlignment = NSTextAlignmentLeft;
    _dataLabel.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:_dataLabel];
    
    
    //UIImageView * imageview = [[UIImageView alloc] initWithFrame:CGRectMake(xPoint, _dataLabel.maxY_wcr + 15, width, 1)];
    //imageview.backgroundColor = [UIColor lightGrayColor];
    //[bgView addSubview:imageview];
    
    
    //_textLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(xPoint, imageview.maxY_wcr +12, width, height)];
    //_textLabel1.textColor = [UIColor lightGrayColor];
    //_textLabel1.font = [UIFont systemFontOfSize:18];
    //[bgView addSubview:_textLabel1];
    
    //UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(width , imageview.maxY_wcr+12, height, height)];
    //[button setImage:[UIImage imageNamed:@"后退-拷贝"] forState:UIControlStateNormal];
    //[bgView addSubview:button];
}

-(void)setInfoModel:(HLTInfoModel *)infoModel
{
    _dataLabel.text = infoModel.date;
    _titleLabel.text = infoModel.title;
    //_textLabel1.text = @"查看详情";
    
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
