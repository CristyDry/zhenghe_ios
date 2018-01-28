//
//  WcrSettingCell.m
//  ZHMedical
//
//  Created by U1KJ on 15/11/16.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "WcrSettingCell.h"

@interface WcrSettingCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *detailLabel;



@end

@implementation WcrSettingCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat xPoint = kBorder;
        CGFloat yPoint = 0.0f;
        CGFloat width = 200.0f;
        CGFloat height = self.height_wcr;
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
        [_titleLabel labelWithText:@"" andTextColor:kBlackColor andFontSize:KFont - 4 andBackgroundColor:nil];
        [self.contentView addSubview:_titleLabel];
        
        xPoint = kMainWidth - 40.0f - width;
        _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
        [_detailLabel labelWithText:@"" andTextColor:kBlackColor andFontSize:KFont - 5 andBackgroundColor:nil];
        _detailLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_detailLabel];
        
        width = 10.0f;
        height = 15.0f;
        xPoint = kMainWidth - width - kBorder;
        yPoint = (self.height_wcr - height) / 2.0;
        UIImageView *arrowIV = [[UIImageView alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
        arrowIV.backgroundColor = [UIColor clearColor];
        arrowIV.image = [UIImage imageFileNamed:@"后退-拷贝" andType:YES];
        //[self.contentView addSubview:arrowIV];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(kBorder, self.height_wcr - 1, kMainWidth - kBorder, 1)];
        line.backgroundColor = KLineColor;
        [self.contentView addSubview:line];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
    }
    
    return self;
}

-(void)setSetting:(WcrSettingTitle *)setting {
    _detailLabel.text = setting.detail;
    _titleLabel.text = setting.titleString;
}

@end
