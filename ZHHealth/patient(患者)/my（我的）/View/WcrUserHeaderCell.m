//
//  WcrUserHeaderCell.m
//  ZHMedical
//
//  Created by U1KJ on 15/11/11.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "WcrUserHeaderCell.h"

@interface WcrUserHeaderCell ()

@end

@implementation WcrUserHeaderCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kBorder, 0, 200, kWcrUserHeaderCellHight)];
        label.font = [UIFont systemFontOfSize:KFont - 4];
        label.text = @"头像";
        label.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:label];
        
        CGFloat yPoint = 10;
        CGFloat width = kWcrUserHeaderCellHight - yPoint * 2;
        CGFloat height = width;
        CGFloat xPoint = kMainWidth - kBorder - 20.0 - width;
        _iconIV = [[UIImageView alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
        _iconIV.contentMode = UIViewContentModeScaleAspectFill;
        [_iconIV.layer setCornerRadius:width / 2.0];
        _iconIV.clipsToBounds = YES;
        _iconIV.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_iconIV];
        
        width = 10.0f;
        height = 15.0f;
        xPoint = kMainWidth - kBorder - width;
        yPoint = (kWcrUserHeaderCellHight - height) / 2.0;
        UIImageView *arrowIV = [[UIImageView alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
        arrowIV.backgroundColor = [UIColor clearColor];
        arrowIV.image = [UIImage imageFileNamed:@"后退-拷贝" andType:YES];
        [self.contentView addSubview:arrowIV];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, kWcrUserHeaderCellHight - 1, kMainWidth, 1)];
        line.backgroundColor = KLineColor;
        [self.contentView addSubview:line];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

-(void)setIconName:(NSString *)iconName {
    _iconName = iconName;
[_iconIV sd_setImageWithURL:[NSURL URLWithString:iconName] placeholderImage:[UIImage imageNamed:@"ic_error"]];
    
}

@end
