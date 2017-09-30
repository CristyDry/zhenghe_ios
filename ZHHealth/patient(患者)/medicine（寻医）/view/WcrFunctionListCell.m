//
//  WcrFunctionListCell.m
//  ZHMedical
//
//  Created by U1KJ on 15/11/10.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "WcrFunctionListCell.h"

@interface WcrFunctionListCell ()

@property (nonatomic, strong) UIImageView *iconIV;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation WcrFunctionListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat width = 50.0f;
        CGFloat yPoint = (kWcrFunctionCellHeight - width) / 2.0;
        _iconIV = [[UIImageView alloc]initWithFrame:CGRectMake(kBorder, yPoint, width, width)];
        [_iconIV.layer setCornerRadius:width / 2.0];
        _iconIV.clipsToBounds = YES;
        _iconIV.contentMode = UIViewContentModeScaleAspectFill;
        _iconIV.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_iconIV];
        
        CGFloat widthOfLabel = kMainWidth - (_iconIV.maxX_wcr + kBorder * 2 + 20) - 10;
        CGFloat heightOfLabel = _iconIV.height_wcr / 2.0;
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_iconIV.maxX_wcr + kBorder, _iconIV.y_wcr, widthOfLabel, heightOfLabel)];
        _nameLabel.font = [UIFont systemFontOfSize:KFont - 3];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = kBlackColor;
        [self.contentView addSubview:_nameLabel];
        
        _detailLabel = [[UILabel alloc]initWithFrame:_nameLabel.frame];
        _detailLabel.y_wcr = _nameLabel.maxY_wcr;
        _detailLabel.font = [UIFont systemFontOfSize:KFont - 5];
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.textColor = kGrayColor;
        [self.contentView addSubview:_detailLabel];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(kBorder, kWcrFunctionCellHeight - 1, kMainWidth - kBorder, 1)];
        line.backgroundColor = KLineColor;
        [self.contentView addSubview:line];
        
        CGFloat widthOfArrow = 10;
        CGFloat heightOfArrow = 17;
        UIImageView *arrowIV = [[UIImageView alloc]initWithFrame:CGRectMake(kMainWidth - 20 - kBorder, kWcrFunctionCellHeight / 2.0 - 10, widthOfArrow, heightOfArrow)];
        arrowIV.image = [UIImage imageFileNamed:@"后退-拷贝-2" andType:YES];
        arrowIV.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:arrowIV];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    return self;
}

-(void)setFunction:(WcrFunction *)function {
    _function = function;
    
    _iconIV.image = [UIImage imageFileNamed:function.iconName andType:YES];
    
    _nameLabel.text = function.name;
    
    _detailLabel.text = function.detail;
    
}




@end
